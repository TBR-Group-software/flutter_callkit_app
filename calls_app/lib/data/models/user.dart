class User {
  User({
    required this.id,
    this.phoneNumber,
    this.name,
  });

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      id: id,
      phoneNumber: json['phoneNumber'] as String?,
      name: json['name'] as String?,
    );
  }

  final String id;
  final String? phoneNumber;
  final String? name;

  User copyWith({
    String? id,
    String? phoneNumber,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
    );
  }
}
