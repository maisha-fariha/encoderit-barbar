# Mobile App — Timezone Integration Guide

**Audience:** mobile developer (Flutter / React Native / native)
**Context:** the API and web admin were reworked so that every appointment is
anchored to the **shop's timezone**. The mobile app must follow the same rule or
it will book on the wrong day / wrong time and display times inconsistently.

---

## 0. The one rule

> **An appointment time is "wall-clock at the shop", not "on the device".**
> The shop's timezone is the single source of truth. The device timezone is
> **never** used to decide a booking time.

A booking at "2:00 PM" for a Dhaka shop means **2:00 PM in Dhaka**, whether the
customer's phone is in Dhaka, Los Angeles, or on a plane. Do not convert using
the device timezone.

You do **not** do UTC conversion yourself for booking. You send the shop-local
`date` + `time` strings and the backend converts. For **display** you convert the
UTC the API returns into the **shop's** timezone (not the device's).

---

## 1. API contract (what changed)

### Every shop carries its timezone
`GET /api/v1/shops` and `GET /api/v1/shops/{id}` return:
```jsonc
{ "id": 1, "name": "...", "timezone": "Asia/Dhaka", ... }
```
`timezone` is an **IANA** identifier (`Asia/Dhaka`, `Europe/Rome`, …). Read it and
keep it with the shop. Always use the **current** value (see §7 — don't cache a
stale copy after a shop edits its timezone).

### Availability slots are shop-local `HH:mm`
`GET /api/v1/availability/slots?barber_id=&service_id=&date=YYYY-MM-DD&shop_id=`
```jsonc
{ "data": {
    "date": "2026-07-10",
    "slots": [ { "time": "09:00", "available": true }, { "time": "09:15", "available": false }, ... ],
    "reason": "The selected date is in the past."   // present only when no slots
} }
```
- `date` is a **shop-local** calendar date.
- `time` values are **shop-local** wall-clock labels — display them **as-is**.
- If `slots` is empty, `reason` explains why (past date, shop closed, holiday, …).

### Booking accepts shop-local `date` + `time`
`POST /api/v1/appointments`
```jsonc
{ "shop_id": 1, "barber_id": 6, "service_id": 1,
  "date": "2026-07-10",   // yyyy-MM-dd, SHOP-LOCAL
  "time": "14:00",        // HH:mm, SHOP-LOCAL wall-clock
  "notes": "..." }
```
Recurring: `POST /api/v1/appointments/recurring` — same `date`/`time`, plus
`"repeat": { "type": "weekly"|"monthly", "value": 4, "interval": 1 }`.

**Send exactly the `date` from the calendar and the `time` from the tapped slot.
Do NOT convert to UTC. Do NOT re-interpret in device time.**

Booking a time already past **at the shop** returns a `422`/`400` validation error
on `time` ("Cannot book an appointment in the past.").

### Appointment timestamps come back as UTC ISO-8601 (Zulu)
`GET /api/v1/appointments/{id}`, `GET /api/v1/profile/appointments`, etc.:
```jsonc
{ "starts_at": "2026-07-10T08:00:00Z", "ends_at": "2026-07-10T08:30:00Z",
  "alternative_starts_at": null, "shop": { "timezone": "Asia/Dhaka" }, ... }
```
`starts_at`, `ends_at`, `alternative_starts_at`, `alternative_ends_at`,
`created_at` are all **UTC** with a trailing `Z`. Convert to the **shop's**
timezone for display.

---

## 2. Calendar / date picker — MUST run in shop timezone

The bug to avoid: the device says it's July 9 while the shop (Dhaka) is already on
July 10, so the user picks a day that is past at the shop.

Do this:
1. Compute **"shop today"** = today's date in `shop.timezone`, not the device.
2. **Disable** every day before shop-today.
3. When the user taps a day, take that day's **calendar label** (`yyyy-MM-dd`) and
   use it verbatim as the booking `date`. (The visual day the user tapped *is* the
   shop-local date they intend.)
4. When you render a `yyyy-MM-dd` string back into the picker, treat it as a
   **plain calendar date** (local midnight), not a UTC instant — otherwise it
   shows one day early on devices behind UTC.

**Flutter:**
```dart
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

String shopToday(String ianaTz) {
  final loc = tz.getLocation(ianaTz);
  final now = tz.TZDateTime.now(loc);
  return DateFormat('yyyy-MM-dd').format(now); // formats the shop-local Y/M/D
}

bool isDayDisabled(DateTime cell, String ianaTz) {
  final cellStr = DateFormat('yyyy-MM-dd').format(cell); // the visual label
  return cellStr.compareTo(shopToday(ianaTz)) < 0;       // string compare
  // (also OR-in shop closed weekdays / holidays / vacations if you show them)
}
```
Set the calendar's "today" highlight and initial month to `shopToday`, not the
device today.

**React Native (date-fns-tz):** identical logic —
`formatInTimeZone(new Date(), shopTz, "yyyy-MM-dd")` for shop-today; string-compare
the cell label; `parseISO(dateStr)` (never `new Date(dateStr)`) when rendering.

---

## 3. Time slots — display and send as-is

- Render each slot's `time` (`"14:00"`) **exactly as returned**. It is already
  shop-local. Do **not** reformat through the device timezone.
- On tap, store the raw `time` string and send it with the booking. No conversion.
- **Optional client-side "past" grey-out** (only meaningful for shop-today): build
  the real instant from the shop wall-clock and compare to now.

**Flutter:**
```dart
bool slotIsPast(String date, String time, String ianaTz) {
  final loc = tz.getLocation(ianaTz);
  final parts = date.split('-'); final t = time.split(':');
  final slot = tz.TZDateTime(loc, int.parse(parts[0]), int.parse(parts[1]),
      int.parse(parts[2]), int.parse(t[0]), int.parse(t[1]));
  return slot.toUtc().isBefore(DateTime.now().toUtc());
}
```
(The backend also rejects past times, so this is just UX polish.)

---

## 4. Booking request — never device-convert

```dart
await api.post('/appointments', body: {
  'shop_id': shop.id, 'barber_id': barberId, 'service_id': serviceId,
  'date': selectedDate,   // 'yyyy-MM-dd' from the calendar
  'time': selectedSlot,   // 'HH:mm'   from the tapped slot
  'notes': notes,
});
```
If your current code does anything like `pickedDateTime.toUtc().toIso8601String()`
or converts the slot to the device timezone before sending — **remove it**. Send
the plain `date` + `time`.

---

## 5. Displaying appointment times — convert UTC → shop timezone

The API returns UTC (`...Z`). Convert to the appointment's **shop** timezone, so
the customer and the shop always see the same agreed wall-clock.

**Flutter:**
```dart
String formatApptTime(String utcIso, String ianaTz) {
  final loc = tz.getLocation(ianaTz);
  final shopLocal = tz.TZDateTime.from(DateTime.parse(utcIso).toUtc(), loc);
  return DateFormat('d MMM yyyy, h:mm a').format(shopLocal);
}
// formatApptTime("2026-07-10T08:00:00Z", "Asia/Dhaka") -> "10 Jul 2026, 2:00 PM"
```
Do **not** use `DateTime.parse(iso).toLocal()` — that renders in the **device**
timezone and will show the wrong time for a shop in another zone.

**Optional nicety:** you may show a secondary "(your local time)" line by
converting the same UTC instant to the device zone — but the shop time is the
primary/canonical value.

---

## 6. Recurring appointments & DST

- Send `date` + `time` shop-local exactly as above; the backend generates each
  occurrence and handles Daylight Saving per occurrence. "Every Monday 2 PM" stays
  2 PM at the shop across DST — you do nothing special.
- Never compute occurrence dates in device time.

---

## 7. Keep the shop timezone fresh

Fetch/refresh the shop (with its `timezone`) when the booking screen opens, or
invalidate the cached shop after any shop edit. A stale shop object (timezone
missing/old) makes the picker silently fall back to UTC and mis-gate "today" —
this exact bug bit the web admin. If `timezone` is ever null/absent, fall back to
`"UTC"` (matches the backend fallback), but treat a null timezone as a data issue
to report.

---

## 8. Do / Don't

| Do | Don't |
|---|---|
| Gate the calendar on **shop-today** | Gate on device today / `DateTime.now()` |
| Send `date`+`time` shop-local as typed/tapped | Convert the booking to UTC on the client |
| Display timestamps in **shop** timezone (`shop.timezone`) | Use `.toLocal()` / device timezone for display |
| Show slot `HH:mm` labels verbatim | Reformat slots through device tz |
| Parse `yyyy-MM-dd` as a plain calendar date | Parse it as UTC midnight (`new Date("2026-07-10")`) |
| Read `shop.timezone` fresh each booking | Cache a shop object across a tz change |

---

## 9. Worked example (the failure this prevents)

Shop = **Asia/Dhaka (UTC+6)**. Device = **America/Los_Angeles (UTC−7)**.
Real instant: **2026-07-09 12:30 in LA = 2026-07-10 01:30 in Dhaka**.

- **Shop today** = `2026-07-10`. Calendar disables `2026-07-09` (already past at the
  shop). ✅ Without this, the user could pick July 9 → backend rejects "past".
- User picks `2026-07-10`, taps slot `"14:00"` → send `{ date: "2026-07-10",
  time: "14:00" }`.
- Backend stores `2026-07-10T08:00:00Z` (14:00 Dhaka − 6h).
- Any client displays it back as **2:00 PM (Dhaka)** by converting `...Z` →
  `Asia/Dhaka`, regardless of the viewer's device zone.

---

## 10. Test checklist

Set the device timezone to one **different** from the shop's and verify:
- [ ] Calendar "today" and earliest selectable day match the **shop's** date, not the device's (test at a day-boundary hour, e.g. LA evening vs Dhaka next-day).
- [ ] Slot labels match what the web admin / API returns (no ±1h shift).
- [ ] Booking a shop-noon slot succeeds and, re-fetched, displays as shop-noon on both the mobile app and web admin.
- [ ] A booked appointment shows the **same** wall-clock on a device in a different timezone.
- [ ] Recurring weekly across a DST change keeps the same shop-local time.
- [ ] Booking a time already past at the shop is blocked (and ideally greyed out client-side).

---

## Reference — backend building blocks (for parity / questions)

- `app/ValueObjects/ShopDateTime.php` — how the server interprets `date`+`time` in
  the shop tz and converts to/from UTC.
- `app/Http/Resources/AppointmentResource.php` — emits `toIso8601ZuluString()` (UTC `Z`).
- `app/Services/AvailabilityService.php` — generates shop-local slots.
- Web-admin equivalents you can mirror: `src/lib/shop-time.ts`
  (`shopTimeZone`, `shopToday`, `shopWallClockToUtc`, `formatInShopTz`) and
  `src/components/shared/create-appointment-dialog.tsx` (shop-tz calendar gating).
