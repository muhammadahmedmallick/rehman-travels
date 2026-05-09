import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/services/secure_storage.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/auth_response_model.dart';

// Auth State
class AuthState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final int? userId;
  final String? email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? error;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userId,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.error,
    this.accessToken,
    this.refreshToken,
  });

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      return lastName != null && lastName!.isNotEmpty
          ? '$firstName $lastName'
          : firstName!;
    }
    return username ?? email ?? '';
  }

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    int? userId,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? error,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      error: error,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [
        isAuthenticated,
        isLoading,
        userId,
        email,
        username,
        firstName,
        lastName,
        phoneNumber,
        error,
        accessToken,
        refreshToken,
      ];
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier({required this.authService}) : super(const AuthState());

  void _setStateFromResponse(AuthResponseModel response) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      userId: response.user.id,
      email: response.user.email,
      username: response.user.username,
      firstName: response.user.firstName,
      lastName: response.user.lastName,
      phoneNumber: response.user.phoneNumber,
      accessToken: response.access,
      refreshToken: response.refresh,
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authService.loginWithEmail(
        email: email,
        password: password,
      );
      _setStateFromResponse(response);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authService.registerWithEmail(
        username: username,
        email: email,
        password: password,
      );
      _setStateFromResponse(response);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authService.signInWithGoogle();
      _setStateFromResponse(response);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await authService.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> restoreSession() async {
    final restored = await authService.restoreSession();
    if (restored) {
      try {
        final user = await authService.getUserProfile();
        final accessToken = await SecureStorage.getAccessToken();
        final refreshToken = await SecureStorage.getRefreshToken();
        state = state.copyWith(
          isAuthenticated: true,
          userId: user.id,
          email: user.email,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.phoneNumber,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } catch (_) {
        // Token expired or invalid, stay logged out
      }
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authServiceProvider = Provider((ref) {
  final apiClient = ref.watch(coreApiClientProvider);
  return AuthService(apiClient: apiClient);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService: authService);
});
