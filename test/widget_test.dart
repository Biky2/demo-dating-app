import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dating_app/main.dart';
import 'package:dating_app/presentation/providers/app_providers.dart';

void main() {
  testWidgets('App starts and shows login screen', (WidgetTester tester) async {
    // Mock SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const DatingApp(),
      ),
    );

    // Initial pump to settle initialization
    await tester.pump();

    // Verify login button exists (LoginScreen)
    expect(find.text('Login'), findsWidgets);
  });
}
