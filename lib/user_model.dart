import 'dart:convert';

class UserModel {
  final String regId;
  final String fullName;
  final String email;
  final String userType;
  final String clinicName;
  final String mobile;
  final String address;
  final String password;
  final bool isActive;

  UserModel({
    required this.regId,
    required this.fullName,
    required this.email,
    required this.userType,
    required this.clinicName,
    required this.mobile,
    required this.address,
    required this.password,
    required this.isActive
  });

  Map<String, dynamic> toJson() {
    return {
      "regId":regId,
      "fullName": fullName,
      "email": email,
      "userType": userType,
      "clinicName": clinicName,
      "mobile": mobile,
      "address": address,
      "password": password,
      "isActive":isActive
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      regId: json["regId"],
      fullName: json["fullName"],
      email: json["email"],
      userType: json["userType"],
      clinicName: json["clinicName"],
      mobile: json["mobile"],
      address: json["address"],
      password: json["password"],
      isActive:json["isActive"]
    );
  }
}
