import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _hhmmSuffixRegex = r'([+-])([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$';

extension DateTimeExension on DateTime {
  static const dateFormat = DateFormat.YEAR_MONTH_DAY;
  static const timeFormat = DateFormat.HOUR24_MINUTE;

  static DateFormat getDateFormat({
    String? date = dateFormat,
    String? time = timeFormat,
  }) {
    assert(date != null || time != null);
    if (date == null) {
      return DateFormat(time);
    }
    if (time == null) {
      return DateFormat(date);
    }
    return DateFormat(date).addPattern(time);
  }

  static DateTime fromAPIString(String value) {
    final regex = RegExp(_hhmmSuffixRegex);
    final index = value.lastIndexOf(regex);
    if (index == -1) {
      return DateTime.parse(value);
    }

    final previous = value.substring(0, index);
    final ending = value.substring(index);
    final prefix = ending.substring(0, 1);
    final hhMm = ending.substring(1).split(':');
    final formattedSuffix = Duration(
      hours: int.parse(hhMm[0]),
      minutes: int.parse(hhMm[1]),
    ).toHHMMSS(hideSeconds: true);
    final formatted = '$previous$prefix$formattedSuffix';
    return DateTime.parse(formatted);
  }

  bool isBetween(DateTime from, DateTime to) {
    return (isAfter(from) || this == from) && (isBefore(to) || this == to);
  }

  bool isInTheSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool isInTheSameMonth(DateTime date) {
    return year == date.year && month == date.month;
  }

  bool isInTheSameYear(DateTime date) {
    return year == date.year;
  }

  String timeDifference(DateTime startDate, {bool? hideSeconds}) {
    RegExp rgx;
    if (hideSeconds == true) {
      rgx = RegExp(r':\d{2}\.\d{6}$');
    } else {
      rgx = RegExp(r'\.\d{6}$');
    }
    return difference(startDate).toString().replaceAll(rgx, '');
  }

  bool isEarlierThan(Duration duration, [DateTime? dateTime]) {
    return subtract(duration).isBefore((dateTime ?? DateTime.now()));
  }

  bool isLaterThan(Duration duration, [DateTime? dateTime]) {
    return add(duration).isAfter((dateTime ?? DateTime.now()));
  }

  String get asHhMm {
    return DateFormat('hh:mm').format(this);
  }

  String get asHm {
    return DateFormat('Hm').format(this);
  }

  String get asHhMma {
    return DateFormat('hh:mm a').format(this);
  }

  String get dayName {
    return DateFormat('EEEE').format(this);
  }

  String get shortDayName {
    return DateFormat('EEE').format(this).substring(0, 3);
  }

  String get shortMonthName {
    return DateFormat('MMM').format(this).substring(0, 3);
  }

  // note: we should use this for all date-time parsing.
  String toFormattedString({
    String? date = dateFormat,
    String? time = timeFormat,
  }) {
    return getDateFormat(date: date, time: time).format(this);
  }

  String get asMmDdYyHHMm {
    return DateFormat('MMM d, yyyy HH:mm').format(this);
  }

  String get asMmDdYy {
    return DateFormat('MMM d, yyyy').format(this);
  }

  //todo: ubuduce refactoracti tak da imamo toFormattedString koji prima pattern
  String get asMMMd {
    return DateFormat('MMM d').format(this);
  }

  String get timeOfDayName {
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }

  String toAPIString({bool inUtc = false}) {
    if (inUtc) return toIso8601UtcString();
    return toIso8601OffsetString();
  }

  /// Converts to UCT `yyyy-MM-ddTHH:mm:ss.mmmuuZ` format and returns a string.
  String toIso8601UtcString() {
    return toUtc().toIso8601String();
  }

  /// Returns a string in ISO8601 format with respect to
  /// offset times other than UTC and with an offset according to the locale.
  String toIso8601OffsetString() {
    var base = toIso8601String();
    if (isUtc) {
      return base;
    }
    final sections = base.split('.');
    final lastOne = sections.removeLast();
    base = [...sections, lastOne.padRight(7, '0')].join('.');
    final offset = timeZoneOffset;
    final hour = offset.inHours;
    final minute = offset.inMinutes - hour * 60;
    final hh = hour.abs().toString().padLeft(2, '0');
    final mm = minute.abs().toString().padLeft(2, '0');
    final time = '$hh:$mm';

    return base + (offset.inMinutes >= 0 ? '+$time' : '-$time');
  }

  //todo: pogledati jednog dana jer se ne cini kao najbolje rjesenje
  DateTimeRange thisWeek() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = start.add(const Duration(days: 6));
    final end = DateTime.now().isBefore(endOfWeek) ? DateTime.now() : endOfWeek;

    return DateTimeRange(
      start: start.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 1,
      ),
      end: end.copyWith(
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      ),
    );
  }

  DateTimeRange thisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final end =
        DateTime.now().isBefore(endOfMonth) ? DateTime.now() : endOfMonth;

    return DateTimeRange(start: start, end: end);
  }

  DateTimeRange thisYear() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year + 1, 1, 0);
    final end = DateTime.now().isBefore(endOfYear) ? DateTime.now() : endOfYear;

    return DateTimeRange(start: start, end: end);
  }

  bool isInRange(DateTimeRange range) {
    return isAfter(range.start) && isBefore(range.end);
  }
}

extension DateTimeRangeExtensions on DateTimeRange {
  DateTimeRange subtractWeek() {
    final from = start.subtract(const Duration(days: 7));
    final to = end.subtract(const Duration(days: 7));
    return DateTimeRange(start: from, end: to);
  }

  DateTimeRange subtractMonth() {
    final from = DateTime(start.year, start.month - 1, 1);
    final to = DateTime(end.year, end.month, 0);
    return DateTimeRange(start: from, end: to);
  }

  DateTimeRange subtractYear() {
    final from = DateTime(start.year - 1, start.month, 1);
    final to = DateTime(end.year - 1, end.month, 31);
    return DateTimeRange(start: from, end: to);
  }

  DateTimeRange addWeek() {
    final from = start.add(const Duration(days: 7));
    final to = end.add(const Duration(days: 7));
    return DateTimeRange(start: from, end: to);
  }

  DateTimeRange addMonth() {
    final from = DateTime(start.year, start.month + 1, 1);
    final to = DateTime(end.year, end.month + 2, 0);
    return DateTimeRange(start: from, end: to);
  }

  DateTimeRange addYear() {
    final from = DateTime(start.year + 1, start.month, 1);
    final to = DateTime(end.year + 1, 13, 0);
    return DateTimeRange(start: from, end: to);
  }

  bool isWeek() {
    return end.difference(start).inDays < 8;
  }

  bool isMonth() {
    final numberOfDays = end.difference(start).inDays;
    return numberOfDays > 7 && numberOfDays < 33;
  }

  bool isYear() {
    final numberOfDays = end.difference(start).inDays;
    return numberOfDays > 31 && numberOfDays < 367;
  }

  bool isMultipleMonths() {
    final numberOfDays = end.difference(start).inDays;
    return !start.isInTheSameMonth(end) && numberOfDays < 367;
  }

  bool isMultipleYears() {
    return end.difference(start).inDays > 366;
  }
}

extension DateTimeRangeNullableExtensions on DateTimeRange? {
  bool isDateTimeRangeEqual(DateTimeRange? range) {
    if (this == null && range == null) return true;
    if (this == null || range == null) return false;

    return this!.start.isInTheSameDay(range.start) &&
        this!.end.isInTheSameDay(range.end);
  }
}

extension DurationExtensions on Duration {
  String toHHMMSS({
    bool hideSeconds = false,
    bool hidePrefix = true,
    bool leadingZero = true,
  }) {
    final hh = inHours.abs().toString().padLeft(leadingZero ? 2 : 1, '0');
    final mm = inMinutes.abs().remainder(60).toString().padLeft(2, '0');
    final ss = !hideSeconds
        ? inSeconds.abs().remainder(60).toString().padLeft(2, '0')
        : null;

    final prefix = hidePrefix
        ? ''
        : isNegative
            ? '-'
            : '+';

    return '$prefix$hh:$mm${ss != null ? ':$ss' : ''}';
  }

  double get decimalValue {
    return inSeconds / 3600;
  }
}
