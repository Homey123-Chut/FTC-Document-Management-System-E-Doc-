
class UserModel {
    final String id;
    final String username;
    final String email;
    final String password;
    final String phoneNumber;
    final String profileImg; 
    final String gender;
    final String role;  
    final String department;
     
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.profileImg,
    required this.gender,
    required this.role,
    required this.department,
  });

  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      profileImg: json['profileImg']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'profileImg': profileImg,
      'gender': gender,
      'role': role,
      'department': department,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    String? profileImg,
    String? gender,
    String? role,
    String? department,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImg: profileImg ?? this.profileImg,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      department: department ?? this.department,
    );
  }
}

