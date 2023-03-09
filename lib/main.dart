import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/bloc/auth/auth_bloc.dart';
import 'package:mooz/app/screens/home/homeframe.dart';
import 'package:mooz/app/screens/login/login.dart';
import 'package:mooz/app/screens/splash/splash.dart';

import 'firebase_options.dart';

// ...

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MoozApp());
}

class MoozApp extends StatelessWidget {
  const MoozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.pink,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/homeframe': (context) => const Homeframe(),
        },
      ),
    );
  }
}
