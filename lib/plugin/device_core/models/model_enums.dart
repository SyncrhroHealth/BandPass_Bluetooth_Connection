import 'package:flutter/material.dart';

enum TimePeriod {
  am,
  pm;

  int get toNativeValue {
    switch (this) {
      case TimePeriod.am:
        return 0;
      case TimePeriod.pm:
        return 1;
    }
  }

  static TimePeriod fromNativeValue(int value) {
    switch (value) {
      case 0:
        return TimePeriod.am;
      case 1:
        return TimePeriod.pm;
      default:
        throw Exception('Invalid value for TimePeriod');
    }
  }

  String get name {
    switch (this) {
      case TimePeriod.am:
        return 'AM';
      case TimePeriod.pm:
        return 'PM';
    }
  }

  static TimePeriod fromDayPeriod(DayPeriod dayPeriod) {
    switch (dayPeriod) {
      case DayPeriod.am:
        return TimePeriod.am;
      case DayPeriod.pm:
        return TimePeriod.pm;
    }
  }

  DayPeriod get toDayPeriod {
    switch (this) {
      case TimePeriod.am:
        return DayPeriod.am;
      case TimePeriod.pm:
        return DayPeriod.pm;
    }
  }
}
