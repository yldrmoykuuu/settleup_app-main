import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settleup_app/core/services/preferences_service.dart';
import 'package:settleup_app/views/screens/DashboardScreen.dart';
import 'package:settleup_app/views/screens/LoginScreen.dart';
import 'package:settleup_app/views/screens/OnboardingScreen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _preferencesService = PreferencesService();
  late final Future<bool> _hasSeenOnboardingFuture;
  bool? _hasSeenOnboardingOverride;

  @override
  void initState() {
    super.initState();
    _hasSeenOnboardingFuture = _preferencesService.loadHasSeenOnboarding();
  }

  Widget _splash() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSeenOnboardingFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _splash();
        }

        final hasSeenOnboarding =
            _hasSeenOnboardingOverride ?? snapshot.data!;

        if (!hasSeenOnboarding) {
          return OnboardingScreen(
            onFinished: () async {
              await _preferencesService.saveHasSeenOnboarding();
              setState(() => _hasSeenOnboardingOverride = true);
            },
          );
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return _splash();
            }

            if (authSnapshot.data != null) {
              return const DashboardScreen();
            }

            return const LoginScreen();
          },
        );
      },
    );
  }
}
