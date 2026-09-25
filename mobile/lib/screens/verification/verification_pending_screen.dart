import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/app_user.dart';
import '../../models/enums.dart';
import '../../providers/auth_provider.dart';

class VerificationPendingScreen extends ConsumerWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return Scaffold(
      body: Center(child: _buildContent(context, ref, profile)),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<AppUser?> profile,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: profile.when(
        loading: () => const CircularProgressIndicator(),
        error: (_, _) => const Text('Unable to load verification status.'),
        data: (value) {
          final appUser = value;
          if (appUser == null) {
            return const Text('Unable to load verification status.');
          }

          final message = switch (appUser.verificationStatus) {
            VerificationStatus.pending =>
              'Your Barangay ID is being reviewed by staff.',
            VerificationStatus.rejected =>
              'Your registration was rejected. Please contact the barangay office for details.',
            VerificationStatus.verified => 'Verified',
          };

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                appUser.verificationStatus == VerificationStatus.verified
                    ? Icons.verified
                    : Icons.hourglass_top,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                appUser.verificationStatus == VerificationStatus.verified
                    ? 'Verified'
                    : 'Verification status',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              if (appUser.verificationStatus == VerificationStatus.verified) ...[
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => ref.invalidate(currentProfileProvider),
                  child: const Text('Refresh'),
                ),
              ],
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => ref.read(authServiceProvider).signOut(),
                child: const Text('Sign out'),
              ),
            ],
          );
        },
      ),
    );
  }
}
