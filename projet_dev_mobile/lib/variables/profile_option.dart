enum ProfileOption {
  Profile,
  Deconnexion,
}

extension ProfileOptionExtension on ProfileOption {
  String get value {
    switch (this) {
      case ProfileOption.Profile:
        return 'Connexion';
      case ProfileOption.Deconnexion:
        return 'Déconnexion';
    }
  }
}


