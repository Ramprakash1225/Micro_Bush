enum UserRole {
  masterUser,
  normalUser;

  String get displayName {
    switch (this) {
      case UserRole.masterUser:
        return 'Master User';
      case UserRole.normalUser:
        return 'Normal User';
    }
  }
}

