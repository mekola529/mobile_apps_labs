class User {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? city;

  const User({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.city,
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? city,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'city': city,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
    );
  }
}
