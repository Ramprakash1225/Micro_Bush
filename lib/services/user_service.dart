import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/user_role.dart';

class UserService extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isMasterUser => _currentUser?.role == UserRole.masterUser;
  bool get isNormalUser => _currentUser?.role == UserRole.normalUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Initialize with a default user for demo purposes
  void initializeDefaultUser() {
    _currentUser = User(
      id: '1',
      name: 'Admin User',
      role: UserRole.masterUser,
    );
    notifyListeners();
  }
}

