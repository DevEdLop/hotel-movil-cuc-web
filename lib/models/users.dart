class User {
  final String userId;
  final String username;
  final bool isAdmin;
  final String email;
  // Agrega más campos según tu modelo Django

  User({
    required this.userId,
    required this.username,
    required this.isAdmin,
    required this.email,
    // Incluye más campos aquí
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'].toString(),
      username: json['username'],
      isAdmin: json['is_admin'],
      email: json['email'],
      // Incluye más campos aquí según tu modelo Django
    );
  }
}
