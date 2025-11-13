import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:patrimonio_ifsul/data/datasources/user_local_data_source.dart';
import 'package:patrimonio_ifsul/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> login(String username, String password);
  Future<int> createUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<User?> login(String username, String password) async {
    final user = await localDataSource.getUserByUsername(username);
    if (user != null) {
      final bytes = utf8.encode(password);
      final digest = sha256.convert(bytes);
      if (digest.toString() == user.password) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<int> createUser(User user) {
    return localDataSource.insertUser(user);
  }
}
