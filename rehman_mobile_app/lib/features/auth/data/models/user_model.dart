import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class MobileProfile extends Equatable {
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'device_type')
  final String? deviceType;
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  const MobileProfile({
    this.phoneNumber,
    this.deviceType,
    this.isVerified = false,
  });

  factory MobileProfile.fromJson(Map<String, dynamic> json) =>
      _$MobileProfileFromJson(json);

  Map<String, dynamic> toJson() => _$MobileProfileToJson(this);

  @override
  List<Object?> get props => [phoneNumber, deviceType, isVerified];
}

@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String username;
  final String email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'mobile_profile')
  final MobileProfile? mobileProfile;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.mobileProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      return lastName != null && lastName!.isNotEmpty
          ? '$firstName $lastName'
          : firstName!;
    }
    return username;
  }

  String? get phoneNumber => mobileProfile?.phoneNumber;

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        mobileProfile,
      ];
}
