import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'models/enums.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/common/error_screen.dart';
import 'screens/common/loading_screen.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/verification/verification_pending_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  ref.watch(authStateProvider);
  final profile = ref.watch(currentProfileProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/verification-pending',
        builder: (context, state) => const VerificationPendingScreen(),
      ),
      GoRoute(path: '/loading', builder: (context, state) => const LoadingScreen()),
      GoRoute(
        path: '/error',
        builder: (context, state) => ErrorScreen(message: state.uri.queryParameters['message']),
      ),
      GoRoute(path: '/report', builder: (context, state) => const _FeaturePlaceholder(title: 'Report an incident')),
      GoRoute(path: '/resident', builder: (context, state) => const _FeaturePlaceholder(title: 'Resident reports')),
      GoRoute(path: '/admin', builder: (context, state) => const _FeaturePlaceholder(title: 'Operations dashboard')),
      GoRoute(path: '/admin/incidents', builder: (context, state) => const _FeaturePlaceholder(title: 'Incident desk')),
      GoRoute(path: '/admin/verifications', builder: (context, state) => const _FeaturePlaceholder(title: 'Verification queue')),
      GoRoute(path: '/admin/map', builder: (context, state) => const _FeaturePlaceholder(title: 'Operations map')),
    ],
    redirect: (context, state) {
      final path = state.uri.path;
      final currentUser = ref.read(currentUserProvider);
      const publicRoutes = {'/', '/login', '/register'};

      if (currentUser == null) {
        return publicRoutes.contains(path) ? null : '/login';
      }

      if (profile.isLoading) {
        return path == '/loading' ? null : '/loading';
      }

      if (profile.hasError) {
        return path == '/error' ? null : '/error';
      }

      final appUser = profile.asData?.value;
      if (appUser == null) {
        return path == '/error' ? null : '/error';
      }

      if (!appUser.isVerified ||
          appUser.verificationStatus == VerificationStatus.pending) {
        return path == '/verification-pending'
            ? null
            : '/verification-pending';
      }

      if (appUser.isStaff) {
        return path == '/' || path.startsWith('/admin') ? null : '/admin';
      }

      if (path.startsWith('/admin')) return '/resident';
      const residentRoutes = {'/', '/report', '/resident'};
      return residentRoutes.contains(path) ? null : '/resident';
    },
  );
});

class _FeaturePlaceholder extends StatelessWidget {
  const _FeaturePlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
