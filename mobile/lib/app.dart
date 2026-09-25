import 'package:flutter/material.dart';

import 'core/theme.dart';

class ESumbongApp extends StatelessWidget {
  const ESumbongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Sumbong',
      theme: buildAppTheme(),
      home: const SetupCompleteScreen(),
    );
  }
}

class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('E-Sumbong - Setup Complete')),
    );
  }
}
