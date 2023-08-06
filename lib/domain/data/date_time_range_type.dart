import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:flutter/material.dart';

enum DateTimeRangeType {
  week,
  month,
  year,
  allTime,
  custom,
}

extension DateTimeRangeTypeExtension on DateTimeRangeType {
  DateTimeRange? get value {
    final now = DateTime.now();
    switch (this) {
      case DateTimeRangeType.week:
        return now.thisWeek();
      case DateTimeRangeType.month:
        return now.thisMonth();
      case DateTimeRangeType.year:
        return now.thisYear();
      case DateTimeRangeType.allTime:
        return null;
      case DateTimeRangeType.custom:
        return null;
    }
  }
}
