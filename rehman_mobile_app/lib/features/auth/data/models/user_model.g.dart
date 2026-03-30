// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileProfile _$MobileProfileFromJson(Map<String, dynamic> json) =>
    MobileProfile(
      phoneNumber: json['phone_number'] as String?,
      deviceType: json['device_type'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$MobileProfileToJson(MobileProfile instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'device_type': instance.deviceType,
      'is_verified': instance.isVerified,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      mobileProfile: json['mobile_profile'] == null
          ? null
          : MobileProfile.fromJson(
              json['mobile_profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'mobile_profile': instance.mobileProfile,
    };
