class User {
  User({
    required this.id,
    this.phoneNumber,
  });

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(id: id, phoneNumber: json['phoneNumber'] as String?);
  }

  final String id;
  final String? phoneNumber;
}
