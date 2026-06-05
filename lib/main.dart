import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'application/providers.dart';
import 'data/budget_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final deviceLang =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  final initialLocale = deviceLang == 'ar' ? 'ar' : 'en';
  final repository = await BudgetRepository.open(initialLocale: initialLocale);

  runApp(
    ProviderScope(
      overrides: [repositoryProvider.overrideWithValue(repository)],
      child: const BudgetApp(),
    ),
  );
}
