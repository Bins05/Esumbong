import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/supabase_client.dart';

class AuthService {
  const AuthService();

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => supabaseClient.auth.signOut();

  Stream<AuthState> get authStateChanges =>
      supabaseClient.auth.onAuthStateChange;

  User? get currentUser => supabaseClient.auth.currentUser;
}
