// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      designation: json['designation'] as String?,
      department: json['department'] as String?,
      userType: json['user_type'] as String,
      accountStatus: json['account_status'] as String,
      mobileNo: json['mobile_no'] as String?,
      phoneNo: json['phone_no'] as String?,
      address: json['address'] as String?,
      createdAt: json['created_at'] as String,
      googlePicture: json['google_picture'] as String?,
      agentId: (json['agent_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'designation': instance.designation,
      'department': instance.department,
      'user_type': instance.userType,
      'account_status': instance.accountStatus,
      'mobile_no': instance.mobileNo,
      'phone_no': instance.phoneNo,
      'address': instance.address,
      'created_at': instance.createdAt,
      'google_picture': instance.googlePicture,
      'agent_id': instance.agentId,
    };
