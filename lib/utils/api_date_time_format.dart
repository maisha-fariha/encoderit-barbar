/// Formats datetimes parsed from API ISO-8601 strings for display.
///
/// Uses the date/time components from the payload (as returned by
/// [DateTime.tryParse] on strings with an offset), without converting to the
/// device local timezone.
String formatApiDateTimeDisplay(
  DateTime? dateTime, {
  String languageCode = 'it',
}) {
  if (dateTime == null) return '';

  final months = languageCode == 'en'
      ? _apiDisplayMonthsEn
      : _apiDisplayMonthsIt;
  final month = months[(dateTime.month - 1).clamp(0, 11)];
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final hour = dateTime.hour.toString().padLeft(2, '0');
  return '${dateTime.day} $month ${dateTime.year}, $hour:$minute';
}

const _apiDisplayMonthsIt = <String>[
  'gennaio',
  'febbraio',
  'marzo',
  'aprile',
  'maggio',
  'giugno',
  'luglio',
  'agosto',
  'settembre',
  'ottobre',
  'novembre',
  'dicembre',
];

const _apiDisplayMonthsEn = <String>[
  'january',
  'february',
  'march',
  'april',
  'may',
  'june',
  'july',
  'august',
  'september',
  'october',
  'november',
  'december',
];
