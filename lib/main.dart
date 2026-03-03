import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';
import 'core/app_mode.dart';
import 'data/datasources/local_datasource.dart';
import 'presentation/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Mock Data
  LocalDataSource.initializeData();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const DatingApp(),
    ),
  );
}

class DatingApp extends ConsumerWidget {
  const DatingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final uiMode = ref.watch(uiModeProvider);
    
    // Performance optimization: Minimize rebuilds by selecting only needed theme data
    final isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return MaterialApp.router(
      title: 'demo dating app made by BIKY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(uiMode, isDarkMode),
      routerConfig: router,
    );
  }
}
