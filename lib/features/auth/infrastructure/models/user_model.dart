import 'package:webant_gallery/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.phone,
    super.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String?,
      phone: json['phone'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'] as String)
          : null,
    );
  }
}
