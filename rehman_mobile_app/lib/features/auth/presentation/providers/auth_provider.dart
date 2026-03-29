import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/services/secure_storage.dart';

// Auth State
class AuthState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final int? userId;
  final String? email;
  final String? username;
  final String? designation;
  final String? department;
  final String? mobileNo;
  final String? phoneNo;
  final String? address;
  final String? photoUrl;
  final String? error;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userId,
    this.email,
    this.username,
    this.designation,
    this.department,
    this.mobileNo,
    this.phoneNo,
    this.address,
    this.photoUrl,
    this.error,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    int? userId,
    String? email,
    String? username,
    String? designation,
    String? department,
    String? mobileNo,
    String? phoneNo,
    String? address,
    String? photoUrl,
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
      designation: designation ?? this.designation,
      department: department ?? this.department,
      mobileNo: mobileNo ?? this.mobileNo,
      phoneNo: phoneNo ?? this.phoneNo,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
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
        designation,
        department,
        mobileNo,
        phoneNo,
        address,
        photoUrl,
        error,
        accessToken,
        refreshToken,
      ];
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier({required this.authService}) : super(const AuthState());

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authService.loginWithEmail(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: response.user.id,
        email: response.user.email,
        username: response.user.username,
        designation: response.user.designation,
        department: response.user.department,
        mobileNo: response.user.mobileNo,
        phoneNo: response.user.phoneNo,
        address: response.user.address,
        photoUrl: response.user.googlePicture,
        accessToken: response.access,
        refreshToken: response.refresh,
      );
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
    required String phone,
    required String password,
    String? address,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authService.registerWithEmail(
        username: username,
        email: email,
        password: password,
        mobileNo: phone,
        address: address,
      );

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: response.user.id,
        email: response.user.email,
        username: response.user.username,
        designation: response.user.designation,
        department: response.user.department,
        mobileNo: response.user.mobileNo,
        phoneNo: response.user.phoneNo,
        address: response.user.address,
        accessToken: response.access,
        refreshToken: response.refresh,
      );
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

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: response.user.id,
        email: response.user.email,
        username: response.user.username,
        designation: response.user.designation,
        department: response.user.department,
        mobileNo: response.user.mobileNo,
        phoneNo: response.user.phoneNo,
        address: response.user.address,
        photoUrl: response.user.googlePicture,
        accessToken: response.access,
        refreshToken: response.refresh,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithFacebook() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement Facebook Sign In
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        isLoading: false,
        error: 'Facebook Sign-in not yet implemented',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement Apple Sign In
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        isLoading: false,
        error: 'Apple Sign-in not yet implemented',
      );
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
      if (state.refreshToken != null) {
        await authService.logout(refreshToken: state.refreshToken!);
      }
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService: authService);
});
