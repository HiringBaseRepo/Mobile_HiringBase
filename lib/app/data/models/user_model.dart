/// Represents an authenticated HR user.
///
/// Maps to the `UserResponse` schema returned by the HiringBase backend.
/// Server fields: id (int), email, full_name, role (UserRole enum string),
/// company_id, is_active, created_at.
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final int? companyId;
  final bool isActive;
  final String? imageUrl;
  final String? phone;
  final String? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.companyId,
    this.isActive = true,
    this.imageUrl,
    this.phone,
    this.createdAt,
  });

  /// Deserialises from the server's `UserResponse` JSON.
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: (json['id'] ?? 0).toString(),
        name: json['full_name'] ?? json['name'] ?? '',
        email: json['email'] ?? '',
        role: _normaliseRole(json['role']?.toString() ?? ''),
        companyId: json['company_id'] as int?,
        isActive: json['is_active'] as bool? ?? true,
        imageUrl: json['avatar_url'] as String? ?? json['imageUrl'] as String?,
        phone: json['phone'] as String?,
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': name,
        'email': email,
        'role': role,
        'company_id': companyId,
        'is_active': isActive,
        'imageUrl': imageUrl,
      };

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    int? companyId,
    bool? isActive,
    String? imageUrl,
    String? phone,
    String? createdAt,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        companyId: companyId ?? this.companyId,
        isActive: isActive ?? this.isActive,
        imageUrl: imageUrl ?? this.imageUrl,
        phone: phone ?? this.phone,
        createdAt: createdAt ?? this.createdAt,
      );

  /// Normalises the server role string to the values expected by [AppService].
  /// Server sends `UserRole` enum values like `hr`, `super_admin`, `applicant`.
  static String _normaliseRole(String serverRole) {
    if (serverRole == 'super_admin') return 'hr';
    return serverRole; // 'hr' | 'applicant'
  }
}
