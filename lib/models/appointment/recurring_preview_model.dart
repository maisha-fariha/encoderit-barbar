class RecurringPreviewAlternativeBarber {
  const RecurringPreviewAlternativeBarber({
    required this.id,
    required this.name,
    this.avatar,
  });

  final int id;
  final String name;
  final String? avatar;

  factory RecurringPreviewAlternativeBarber.fromJson(Map<String, dynamic> json) {
    return RecurringPreviewAlternativeBarber(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      name: (json['name'] ?? '').toString(),
      avatar: (json['avatar'] ?? json['avatar_url'])?.toString(),
    );
  }
}

class RecurringPreviewDateItem {
  const RecurringPreviewDateItem({
    required this.date,
    required this.time,
    required this.dateTimeString,
    required this.dateTimeStringIt,
    required this.status,
    required this.reason,
    required this.reasonIt,
    required this.nextAvailableSlot,
    required this.nextAvailableDate,
    required this.alternativeBarbers,
  });

  final String date;
  final String time;
  final String dateTimeString;
  final String dateTimeStringIt;
  final String status;
  final String reason;
  final String reasonIt;
  final String? nextAvailableSlot;
  final String? nextAvailableDate;
  final List<RecurringPreviewAlternativeBarber> alternativeBarbers;

  bool get isAvailable => status.trim().toLowerCase() == 'available';

  /// Italian by default; English when [languageCode] is `en`.
  String dateTimeLabelFor(String languageCode) {
    final isEn = languageCode.toLowerCase() == 'en';
    if (isEn) {
      if (dateTimeString.trim().isNotEmpty) return dateTimeString.trim();
      if (dateTimeStringIt.trim().isNotEmpty) return dateTimeStringIt.trim();
    } else {
      if (dateTimeStringIt.trim().isNotEmpty) return dateTimeStringIt.trim();
      if (dateTimeString.trim().isNotEmpty) return dateTimeString.trim();
    }
    final d = date.trim();
    final t = time.trim();
    if (d.isEmpty) return t;
    if (t.isEmpty) return d;
    return '$d $t';
  }

  /// Italian by default; English when [languageCode] is `en`.
  String reasonLabelFor(String languageCode) {
    final isEn = languageCode.toLowerCase() == 'en';
    if (isEn) {
      if (reason.trim().isNotEmpty) return reason.trim();
      return reasonIt.trim();
    }
    if (reasonIt.trim().isNotEmpty) return reasonIt.trim();
    return reason.trim();
  }

  factory RecurringPreviewDateItem.fromJson(Map<String, dynamic> json) {
    final alternativesRaw = json['alternative_barbers'];
    final alternatives = alternativesRaw is List
        ? alternativesRaw
            .whereType<Map>()
            .map(
              (e) => RecurringPreviewAlternativeBarber.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList(growable: false)
        : const <RecurringPreviewAlternativeBarber>[];
    return RecurringPreviewDateItem(
      date: (json['date'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
      dateTimeString: (json['date_time_string'] ?? '').toString(),
      dateTimeStringIt: (json['date_time_string_it'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      reason: (json['reason'] ?? '').toString(),
      reasonIt: (json['reason_it'] ?? '').toString(),
      nextAvailableSlot: json['next_available_slot']?.toString(),
      nextAvailableDate: json['next_available_date']?.toString(),
      alternativeBarbers: alternatives,
    );
  }
}

class RecurringPreviewResult {
  const RecurringPreviewResult({required this.dates});

  final List<RecurringPreviewDateItem> dates;

  factory RecurringPreviewResult.fromJson(Map<String, dynamic> json) {
    final datesRaw = json['dates'];
    final dates = datesRaw is List
        ? datesRaw
            .whereType<Map>()
            .map(
              (e) => RecurringPreviewDateItem.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList(growable: false)
        : const <RecurringPreviewDateItem>[];
    return RecurringPreviewResult(dates: dates);
  }
}
