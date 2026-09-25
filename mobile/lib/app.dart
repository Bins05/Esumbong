import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'router.dart';

class ESumbongApp extends ConsumerWidget {
  const ESumbongApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'E-Sumbong',
      theme: buildAppTheme(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
