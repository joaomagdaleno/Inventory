import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:patrimonio_ifsul/data/datasources/database_helper.dart';
import 'package:patrimonio_ifsul/domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<User?> getUserByUsername(String username);
  Future<int> insertUser(User user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final DatabaseHelper databaseHelper;

  UserLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<User?> getUserByUsername(String username) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> insertUser(User user) async {
    final db = await databaseHelper.database;
    final bytes = utf8.encode(user.password);
    final digest = sha256.convert(bytes);

    final userWithHashedPassword = User(
      username: user.username,
      password: digest.toString(),
      role: user.role,
    );

    return await db.insert('users', userWithHashedPassword.toMap());
  }
}
