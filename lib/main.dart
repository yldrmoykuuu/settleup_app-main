import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settleup_app/core/components/AuthWrapper.dart';
import 'package:settleup_app/core/services/preferences_service.dart';
import 'package:settleup_app/core/theme/app_theme.dart';
import 'package:settleup_app/firebase_options.dart';
import 'package:settleup_app/viewmodels/auth_viewmodel.dart';

import 'package:settleup_app/viewmodels/dashboard_viewmodel.dart';
import 'package:settleup_app/data/repositories/group_repository.dart';

final ValueNotifier<bool> themeNotifier = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  themeNotifier.value = await PreferencesService().loadIsDarkMode();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardViewmodel(GroupRepository()),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],

      child: ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (context, isDark, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'OrtakHesap',

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
