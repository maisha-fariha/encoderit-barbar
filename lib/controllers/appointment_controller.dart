import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/appointment/appointment_model.dart';
import '../repositories/appointment_repository.dart';

/// Reactive state and orchestration for booking a single appointment.
///
/// UI binds to:
/// - [isBooking]    : show loader on the confirm button, disable other actions
/// - [lastBooked]   : last successfully created [AppointmentModel] (nullable)
/// - [errorMessage] : last user-facing error (cleared on next attempt)
class AppointmentController extends GetxController {
  AppointmentController({required this.repository});

  final AppointmentRepository repository;

  final RxBool isBooking = false.obs;
  final Rxn<AppointmentModel> lastBooked = Rxn<AppointmentModel>();
  final RxString errorMessage = ''.obs;

  /// Last successful recurring booking outcome (nullable).
  final Rxn<RecurringAppointmentResult> lastRecurringResult =
      Rxn<RecurringAppointmentResult>();

  /// Books a single (non-recurring) appointment.
  ///
  /// Returns the structured outcome so the caller (UI) can decide what to do
  /// on success vs. business failure vs. network error.
  Future<BookAppointmentOutcome> bookSingle({
    required int shopId,
    required int barberId,
    required int serviceId,
    required String date, // YYYY-MM-DD
    required String time, // HH:mm
    String notes = '',
  }) async {
    if (isBooking.value) {
      // Defensive: prevent double-tap submitting twice.
      return const BookAppointmentOutcome(
        success: false,
        message: 'Booking already in progress',
      );
    }

    isBooking.value = true;
    errorMessage.value = '';

    try {
      final request = AppointmentBookingRequest(
        shopId: shopId,
        barberId: barberId,
        serviceId: serviceId,
        date: date,
        time: time,
        notes: notes,
      );

      if (kDebugMode) {
        debugPrint('[AppointmentController] bookSingle request=${request.toJson()}');
      }

      final outcome = await repository.bookAppointment(request);

      if (kDebugMode) {
        debugPrint(
          '[AppointmentController] outcome success=${outcome.success} '
          'message=${outcome.message} '
          'isNetworkError=${outcome.isNetworkError}',
        );
      }

      if (outcome.success) {
        lastBooked.value = outcome.appointment;
      } else {
        errorMessage.value = _extractMessage(outcome);
      }

      return outcome;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AppointmentController] unexpected error: $e\n$st');
      }
      errorMessage.value = e.toString();
      return BookAppointmentOutcome(
        success: false,
        message: e.toString(),
        isNetworkError: true,
      );
    } finally {
      isBooking.value = false;
    }
  }

  /// Books a recurring series of appointments.
  ///
  /// Validates inputs locally, then delegates to
  /// [AppointmentRepository.bookRecurringAppointment]. The method always
  /// returns a [BookRecurringOutcome] and never throws.
  Future<BookRecurringOutcome> bookRecurring({
    required int shopId,
    required int barberId,
    required int serviceId,
    required String date, // YYYY-MM-DD
    required String time, // HH:mm
    required RecurringRepeatType repeatType,
    required int repeatValue,
    String? notes,
  }) async {
    if (isBooking.value) {
      return const BookRecurringOutcome(
        success: false,
        message: 'Booking already in progress',
      );
    }

    // API constraint: value in [1, 52].
    final clampedValue = repeatValue.clamp(1, 52);
    if (clampedValue < 1) {
      return const BookRecurringOutcome(
        success: false,
        message: 'Invalid recurring count',
      );
    }

    isBooking.value = true;
    errorMessage.value = '';

    try {
      final request = RecurringAppointmentRequest(
        shopId: shopId,
        barberId: barberId,
        serviceId: serviceId,
        date: date,
        time: time,
        notes: notes,
        repeat: RecurringRepeat(type: repeatType, value: clampedValue),
      );

      if (kDebugMode) {
        debugPrint(
          '[AppointmentController] bookRecurring request=${request.toJson()}',
        );
      }

      final outcome = await repository.bookRecurringAppointment(request);

      if (kDebugMode) {
        final r = outcome.result;
        debugPrint(
          '[AppointmentController] recurring outcome success=${outcome.success} '
          'message=${outcome.message} '
          'booked=${r?.booked.length ?? 0} skipped=${r?.skipped.length ?? 0} '
          'isNetworkError=${outcome.isNetworkError}',
        );
      }

      if (outcome.success) {
        lastRecurringResult.value = outcome.result;
      } else {
        errorMessage.value = _extractRecurringMessage(outcome);
      }

      return outcome;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AppointmentController] recurring unexpected error: $e\n$st');
      }
      errorMessage.value = e.toString();
      return BookRecurringOutcome(
        success: false,
        message: e.toString(),
        isNetworkError: true,
      );
    } finally {
      isBooking.value = false;
    }
  }

  /// Pulls the most informative human-readable message from the API outcome.
  /// Order: explicit `message` → first `errors[*]` value → empty.
  String _extractMessage(BookAppointmentOutcome outcome) {
    if (outcome.message.trim().isNotEmpty) return outcome.message.trim();
    return _firstErrorString(outcome.errors);
  }

  String _extractRecurringMessage(BookRecurringOutcome outcome) {
    if (outcome.message.trim().isNotEmpty) return outcome.message.trim();
    return _firstErrorString(outcome.errors);
  }

  String _firstErrorString(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) return '';
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty && value.first is String) {
        final v = (value.first as String).trim();
        if (v.isNotEmpty) return v;
      }
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }
}
