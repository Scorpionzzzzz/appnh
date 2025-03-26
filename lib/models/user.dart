class User {
  final int id;
  final String username;
  final String password;
  final String fullName;
  final String accountNumber;
  final double balance;
  final String phoneNumber;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.accountNumber,
    required this.balance,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullName': fullName,
      'accountNumber': accountNumber,
      'balance': balance,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      fullName: map['fullName'],
      accountNumber: map['accountNumber'],
      balance: map['balance'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? fullName,
    String? accountNumber,
    double? balance,
    String? phoneNumber,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }
} 