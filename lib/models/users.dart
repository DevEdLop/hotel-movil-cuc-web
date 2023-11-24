class User {
  final String username;
  final String email;
  // Agrega más campos según tu modelo Django

  User({
    required this.username,
    required this.email,
    // Incluye más campos aquí
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      // Incluye más campos aquí según tu modelo Django
    );
  }
}
