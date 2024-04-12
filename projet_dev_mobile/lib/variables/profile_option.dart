enum ProfileOption {
  Profile,
  Deconnexion,
}

extension ProfileOptionExtension on ProfileOption {
  String get value {
    switch (this) {
      case ProfileOption.Profile:
        return 'Profile';
      case ProfileOption.Deconnexion:
        return 'Déconnexion';
    }
  }
}


