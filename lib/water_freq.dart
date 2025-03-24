enum WaterFreq {
  onceAMonth,
  twiceAMonth,
  onceAWeek,
  twiceAWeek,
  threeTimesAWeek,
  fourTimesAWeek,
  fiveTimesAWeek,
  everyDay,
}

extension WaterFreqExtension on WaterFreq {
  String get label {
    switch (this) {
      case WaterFreq.onceAMonth:
        return '1 time a month';
      case WaterFreq.twiceAMonth:
        return '2 times a month';
      case WaterFreq.onceAWeek:
        return '1 time a week';
      case WaterFreq.twiceAWeek:
        return '2 times a week';
      case WaterFreq.threeTimesAWeek:
        return '3 times a week';
      case WaterFreq.fourTimesAWeek:
        return '4 times a week';
      case WaterFreq.fiveTimesAWeek:
        return '5 times a week';
      case WaterFreq.everyDay:
        return 'Every day';
    }
  }
}
