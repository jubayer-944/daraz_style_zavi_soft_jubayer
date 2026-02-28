import 'package:daraz_style/features/home/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.username,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final nameJson = json['name'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final firstName = nameJson['firstname'] as String? ?? '';
    final lastName = nameJson['lastname'] as String? ?? '';
    final fullName = (firstName.isEmpty && lastName.isEmpty)
        ? json['username'] as String? ?? ''
        : '$firstName $lastName'.trim();

    return UserModel(
      id: (json['id'] as num).toInt(),
      name: fullName,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}

