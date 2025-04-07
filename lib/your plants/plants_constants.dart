List<String> plantTypes = [
    'Succulents',
    'Cacti',
    'Monstera',
    'Spider Plants',
    'Pothos',
    'Orchids',
    'Columbine',
    'Snake Plants',
    'Lilies',
];

List<String> icons = [
  'assets/images/plant_icon_1.png',
  'assets/images/plant_icon_2.png',
  'assets/images/plant_icon_3.png',
  'assets/images/plant_icon_4.png',
  'assets/images/plant_icon_5.png',
  'assets/images/plant_icon_6.png',
  'assets/images/plant_icon_7.png',
  'assets/images/plant_icon_8.png',
  'assets/images/plant_icon_9.png',
];


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

int getDaysBetweenWaterings(String frequencyLabel) {
  switch (frequencyLabel) {
    case '1 time a month':
      return 30;
    case '2 times a month':
      return 15;
    case '1 time a week':
      return 7;
    case '2 times a week':
      return 3;
    case '3 times a week':
      return 2;
    case '4 times a week':
      return 2; // could be 1.5, but keeping it simple
    case '5 times a week':
      return 1;
    case 'Every day':
      return 1;
    default:
      return 7;
  }
}