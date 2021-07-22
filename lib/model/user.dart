class User {
  final String id;
  final String email;
  final String password;
  final String state;
  final String temporal;
  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.state,
      required this.temporal});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        id: parsedJson['id'],
        email: parsedJson['email'],
        password: parsedJson['password'],
        state: parsedJson['state'],
        temporal: parsedJson['temporal']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'state': state,
      'temporal': temporal,
    };
  }
}
