import '../gen/l10n/app_localizations.dart';

/// Localized label for an appointment API `status` value.
String appointmentStatusLabel(String raw, AppLocalizations l10n) {
  switch (raw.trim().toLowerCase()) {
    case 'booked':
    case 'confirmed':
      return l10n.confirmed;
    case 'upcoming':
      return l10n.upcoming;
    case 'completed':
    case 'complete':
    case 'done':
      return l10n.completed;
    case 'cancelled':
    case 'canceled':
      return l10n.cancelled;
    case 'waiting':
    case 'waitlist':
    case 'waiting_list':
      return l10n.waitingList;
    case 'no_show':
    case 'noshow':
      return l10n.noShow;
    default:
      return raw.trim();
  }
}
