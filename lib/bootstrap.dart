import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kamkor/app/app_bloc_observer.dart';
import 'package:kamkor/app/view/app_root.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:path_provider/path_provider.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final dir = await getApplicationDocumentsDirectory();
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(dir.path),
      );

      await configureDependencies();
      Bloc.observer = const AppBlocObserver();

      runApp(const AppRoot());
    },
    (error, stack) => debugPrint('Uncaught zone error: $error'),
  );
}
