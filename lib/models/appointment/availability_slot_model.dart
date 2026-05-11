class AvailabilitySlot {
  const AvailabilitySlot({
    required this.time,
    required this.available,
  });

  final String time;
  final bool available;

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    final time = (json['time'] ?? '').toString().trim();
    final availableRaw = json['available'];
    final available = availableRaw is bool
        ? availableRaw
        : (availableRaw is num ? availableRaw != 0 : false);
    return AvailabilitySlot(time: time, available: available);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'time': time,
        'available': available,
      };
}

class AvailabilitySlotsResult {
  const AvailabilitySlotsResult({
    required this.date,
    required this.slots,
  });

  final String date;
  final List<AvailabilitySlot> slots;

  factory AvailabilitySlotsResult.fromJson(Map<String, dynamic> json) {
    final slotsRaw = json['slots'];
    final slots = slotsRaw is List
        ? slotsRaw
            .whereType<Map>()
            .map((e) => AvailabilitySlot.fromJson(Map<String, dynamic>.from(e)))
            .where((e) => e.time.isNotEmpty)
            .toList(growable: false)
        : const <AvailabilitySlot>[];
    return AvailabilitySlotsResult(
      date: (json['date'] ?? '').toString(),
      slots: slots,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date,
        'slots': slots.map((e) => e.toJson()).toList(growable: false),
      };
}
