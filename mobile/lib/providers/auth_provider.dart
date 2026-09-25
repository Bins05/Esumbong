import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../core/supabase_client.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return const AuthService();
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => ref.read(authServiceProvider).currentUser,
    error: (_, _) => ref.read(authServiceProvider).currentUser,
  );
});

final currentProfileProvider = FutureProvider<AppUser?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final profile = await supabaseClient
      .from('users')
      .select()
      .eq('id', user.id)
      .maybeSingle();

  if (profile == null) return null;
  return AppUser.fromMap(profile);
});
