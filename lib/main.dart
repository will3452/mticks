
import 'package:flutter/material.dart';
import 'package:mticks/auth/login.dart';
import 'package:mticks/auth/register.dart';
import 'package:mticks/home/app.dart';
import 'package:mticks/home/booking.dart';
import 'package:mticks/home/qr.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Ticks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        "login": (_) => const LoginPage(),
        "register": (_) => const RegisterPage(),
        "home": (_) => const App(),
        'qr': (_) => const Qr(),
        'booking': (_) => const Booking(),
      },
    );
  }
}
