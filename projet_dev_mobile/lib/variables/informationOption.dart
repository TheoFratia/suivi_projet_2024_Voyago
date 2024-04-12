enum InformationOption {
  hotel,
  activities,
}

extension InformationOptionExtension on InformationOption {
  String get value {
    switch (this) {
      case InformationOption.hotel:
        return 'hotel';
      case InformationOption.activities:
        return 'activities';
    }
  }
}
