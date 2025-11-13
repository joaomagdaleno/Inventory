import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/domain/entities/user.dart';
import 'package:patrimonio_ifsul/domain/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository userRepository;

  AuthProvider({required this.userRepository});

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String username, String password) async {
    final user = await userRepository.login(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
