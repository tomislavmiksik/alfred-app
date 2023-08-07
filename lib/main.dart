import 'package:alfred_app/common/loading_dialog.dart';
import 'package:alfred_app/domain/data/journal_entry.dart';
import 'package:alfred_app/domain/data/session.dart';
import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/domain/data/user.dart';
import 'package:alfred_app/generated/l10n.dart';
import 'package:alfred_app/providers/app_theme_provider.dart';
import 'package:alfred_app/providers/navigation_providers.dart';
import 'package:alfred_app/util/env.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  await Env.load();
  await Hive.initFlutter();
  await initializeDateFormatting();

  registerHiveAdapters();

  runApp(const ProviderScope(child: App()));
}

void registerHiveAdapters() {
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.read(appRouterProvider);
    final theme = ref.read(themeProvider);

    return MaterialApp.router(
      builder: LoadingDialog.init(),
      localizationsDelegates: const [Translations.delegate],
      supportedLocales: Translations.delegate.supportedLocales,
      routeInformationParser: appRouter.defaultRouteParser(),
      routerDelegate: AutoRouterDelegate(
        appRouter,
        // placeholder: (_) => const SplashScreen(),
      ),
      theme: theme.data,
    );
  }
}
