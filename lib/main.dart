import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/archivedStorageCubit.dart';
import 'package:habitmaker/BLoC/storage/storageCubit.dart';
import 'package:habitmaker/BLoC/theme/themeCubit.dart';
import 'package:habitmaker/BLoC/theme/themeState.dart';
import 'package:habitmaker/model/habit.dart';
import 'package:habitmaker/screens/navBar.dart';
import 'package:habitmaker/screens/onboarding.dart';
import 'package:habitmaker/services/hiveStorage.dart';
import 'package:habitmaker/themes/appTheme.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<Habit>('archived');

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => Themecubit()),
          BlocProvider(create: (_) => StorageCubit(Hivestorage())..loadEntries()),
          BlocProvider(create: (_) => Archivedstoragecubit(Hivestorage())..archivedEntries()),
        ],
        child: MainApp(isFirstTime: isFirstTime),
      ),
    );
  });
}

class MainApp extends StatelessWidget {
  final bool isFirstTime;
  const MainApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Themecubit, ThemeState>(builder: (context, state) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.LightTheme,
        darkTheme: AppTheme.DarkTheme,
        themeMode: state.themeMode,
        home: isFirstTime ? const OnboardingScreen() : const NavBar(),
      );
    });
  }
}
