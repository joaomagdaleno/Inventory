enum UserRole { admin, tecnico, comum }

class User {
  final int? id;
  final String username;
  final String password; // Should be a hash
  final UserRole role;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role.toString().split('.').last, // Store role as a string
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.comum,
      ),
    );
  }
}
