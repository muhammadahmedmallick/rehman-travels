import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

// Auth State
class AuthState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final String? userId;
  final String? email;
  final String? displayName;
  final String? phone;
  final String? photoUrl;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userId,
    this.email,
    this.displayName,
    this.phone,
    this.photoUrl,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? userId,
    String? email,
    String? displayName,
    String? phone,
    String? photoUrl,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isAuthenticated,
        isLoading,
        userId,
        email,
        displayName,
        phone,
        photoUrl,
        error,
      ];
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement Email Sign In with API
      await Future.delayed(const Duration(seconds: 1));

      // Simulate validation
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Please enter email and password');
      }
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: 'user_123',
        email: email,
        displayName: email.split('@').first,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement Email Sign Up with API
      await Future.delayed(const Duration(seconds: 1));

      // Simulate validation
      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        throw Exception('Please fill all fields');
      }
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }
      if (!email.contains('@')) {
        throw Exception('Please enter a valid email');
      }

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: name,
        phone: phone,
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
      // TODO: Implement Google Sign In
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: 'user_google_123',
        email: 'user@gmail.com',
        displayName: 'Google User',
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
        isAuthenticated: true,
        isLoading: false,
        userId: 'user_fb_123',
        email: 'user@facebook.com',
        displayName: 'Facebook User',
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
        isAuthenticated: true,
        isLoading: false,
        userId: 'user_apple_123',
        email: 'user@icloud.com',
        displayName: 'Apple User',
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
      // TODO: Implement Sign Out
      await Future.delayed(const Duration(milliseconds: 500));
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

// Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
