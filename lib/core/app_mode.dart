import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UIMode { lightMode, performanceMode, premiumMode }

final uiModeProvider = StateProvider<UIMode>((ref) => UIMode.premiumMode);
