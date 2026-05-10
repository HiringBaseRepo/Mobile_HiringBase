class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? imageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? '',
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'imageUrl': imageUrl,
      };
}
