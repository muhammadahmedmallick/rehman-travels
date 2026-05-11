import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/core_api_client.dart';
import '../constants/api_endpoints.dart';

class AppConfig {
  final String phone;
  final String whatsapp;
  final String email;
  final String name;
  final String website;
  final String facebook;
  final String instagram;
  final String twitter;
  final String youtube;
  final String officeName;
  final String officeAddress;
  final String officeHours;

  const AppConfig({
    this.phone = '+9251111786785',
    this.whatsapp = '923111786785',
    this.email = 'info@rehmantravel.com',
    this.name = 'Rehman Travel',
    this.website = 'https://www.rehmantravel.com',
    this.facebook = 'https://www.facebook.com/rehmantravelofficial',
    this.instagram = 'https://instagram.com/rehmantravel',
    this.twitter = 'https://twitter.com/rehmantravel',
    this.youtube = 'https://youtube.com/@rehmantravel',
    this.officeName = 'Rehman Group of Travels',
    this.officeAddress = 'Blue Area, Islamabad, Pakistan',
    this.officeHours = 'Mon - Sat: 9:00 AM - 8:00 PM',
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    final social = json['social'] as Map<String, dynamic>? ?? {};
    final office = json['office'] as Map<String, dynamic>? ?? {};
    return AppConfig(
      phone: json['phone'] ?? '+9251111786785',
      whatsapp: json['whatsapp'] ?? '923111786785',
      email: json['email'] ?? 'info@rehmantravel.com',
      name: json['name'] ?? 'Rehman Travel',
      website: json['website'] ?? 'https://www.rehmantravel.com',
      facebook: social['facebook'] ?? 'https://www.facebook.com/rehmantravelofficial',
      instagram: social['instagram'] ?? 'https://instagram.com/rehmantravel',
      twitter: social['twitter'] ?? 'https://twitter.com/rehmantravel',
      youtube: social['youtube'] ?? 'https://youtube.com/@rehmantravel',
      officeName: office['name'] ?? 'Rehman Group of Travels',
      officeAddress: office['address'] ?? 'Blue Area, Islamabad, Pakistan',
      officeHours: office['hours'] ?? 'Mon - Sat: 9:00 AM - 8:00 PM',
    );
  }
}

class AppConfigNotifier extends StateNotifier<AppConfig> {
  final CoreApiClient _apiClient;

  AppConfigNotifier(this._apiClient) : super(const AppConfig()) {
    fetch();
  }

  Future<void> fetch() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.appConfig);
      if (response.data is Map<String, dynamic>) {
        state = AppConfig.fromJson(response.data);
      }
    } catch (e) {
      if (kDebugMode) print('AppConfig fetch failed: $e');
      // Keep defaults
    }
  }
}

final appConfigProvider = StateNotifierProvider<AppConfigNotifier, AppConfig>((ref) {
  return AppConfigNotifier(ref.read(coreApiClientProvider));
});
