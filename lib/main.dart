import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injector.dart';
import 'core/base/bloc_observer.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'smart_splash.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  Bloc.observer = SimpleBlocObserver();

  runApp(const SmartApp());
}

class SmartApp extends StatelessWidget {
  const SmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ Bọc toàn bộ app trong BlocProvider<AuthBloc>
      create: (_) => GetIt.instance<AuthBloc>(),
      child: MaterialApp(
        title: 'Smart Curtain App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const SmartSplashScreen(),
        routes: {'/home': (_) => const HomePage()},
      ),
    );
  }
}
