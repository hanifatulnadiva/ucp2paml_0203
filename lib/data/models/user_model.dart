import 'package:equatable/equatable.dart';

enum UserRole {customer, admin}

extension UserRoleExtention on UserRole{
    String get value {
        switch (this){
            case UserRole.admin:
                return 'admin';
            case UserRole.customer:
                return 'customer';        
        }
    }

    String get displayName{
        switch(this){
            case UserRole.admin:
                return 'admin';
            case UserRole.customer:
                return 'customer';
        }
    }
    static UserRole fromString(String value){
        switch(value.toLowerCase()){
            case 'admin':
                return UserRole.admin;
            case 'customer':
                return UserRole.customer;
            default:
                return UserRole.customer;
        }
    }
}
class UserModel extends Equatable{
  final String id;
  final String nama;
  final UserRole role;


  const UserModel({
    required this.id,
    required this.nama,
    required this.role,
  });

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      role: UserRoleExtention.fromString(json['role'] ?? 'customer'),
    );
  }
  @override
  List<Object?> get props=>[id,nama, role];
}