import 'package:flutter/material.dart';
import 'package:qr_aplication/screens/iniciar_screen.dart';
import 'package:qr_aplication/screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LECTOR CODIGO QR',
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: '/splash_screen',
        routes: {
          '/iniciar_screen': (context) => const Iniciar(),
          '/splash_screen': (context) => const SplashScreen(),
        });
  }
}
