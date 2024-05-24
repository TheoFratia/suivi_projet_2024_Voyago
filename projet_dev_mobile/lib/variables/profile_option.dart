enum ProfileOption {
  profile,
  deconnexion,
}

extension ProfileOptionExtension on ProfileOption {
  String get value {
    switch (this) {
      case ProfileOption.profile:
        return 'Connexion';
      case ProfileOption.deconnexion:
        return 'Déconnexion';
    }
  }
}


