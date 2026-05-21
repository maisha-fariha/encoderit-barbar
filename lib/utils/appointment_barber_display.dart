import '../gen/l10n/app_localizations.dart';
import '../models/appointment/appointment_model.dart';

/// View-only barber line for appointment list cards (home / reservations).
class AppointmentBarberDisplay {
  const AppointmentBarberDisplay({
    required this.pillText,
    this.isAlternativeBarber = false,
  });

  final String pillText;
  final bool isAlternativeBarber;

  factory AppointmentBarberDisplay.fromAppointment(
    AppointmentModel appointment,
    AppLocalizations l10n,
  ) {
    final alt = appointment.alternativeBarberName;
    if (alt != null) {
      return AppointmentBarberDisplay(
        pillText: l10n.alternativeBarberLabel(alt),
        isAlternativeBarber: true,
      );
    }
    final primary = appointment.primaryBarberName;
    return AppointmentBarberDisplay(
      pillText: primary == 'Barber' ? 'con Barber' : 'con $primary',
      isAlternativeBarber: false,
    );
  }
}
