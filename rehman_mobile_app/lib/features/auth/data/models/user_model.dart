import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? designation;
  final String? department;
  @JsonKey(name: 'user_type')
  final String userType;
  @JsonKey(name: 'account_status')
  final String accountStatus;
  @JsonKey(name: 'mobile_no')
  final String? mobileNo;
  @JsonKey(name: 'phone_no')
  final String? phoneNo;
  final String? address;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'google_picture')
  final String? googlePicture;
  @JsonKey(name: 'agent_id')
  final int? agentId;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.designation,
    this.department,
    required this.userType,
    required this.accountStatus,
    this.mobileNo,
    this.phoneNo,
    this.address,
    required this.createdAt,
    this.googlePicture,
    this.agentId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        designation,
        department,
        userType,
        accountStatus,
        mobileNo,
        phoneNo,
        address,
        createdAt,
        googlePicture,
        agentId,
      ];
}
