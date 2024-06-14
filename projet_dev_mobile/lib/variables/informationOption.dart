enum InformationOption {
  hotel,
  activities,
  important,
  essential,
}

extension InformationOptionExtension on InformationOption {
  String get value {
    switch (this) {
      case InformationOption.essential:
        return 'essential';
      case InformationOption.important:
        return 'important';
      case InformationOption.hotel:
        return 'hotel';
      case InformationOption.activities:
        return 'activities';
    }
  }
}
