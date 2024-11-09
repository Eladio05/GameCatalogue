import 'package:flutter/material.dart';
import 'bottom_nav_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Bibliothèque de Jeux',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 26, 26, 29),
        scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 29),
        colorScheme: ColorScheme.dark(
          primary: const Color.fromARGB(255, 26, 26, 29),
          secondary: const Color.fromARGB(255, 173, 20, 87),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        useMaterial3: true,
      ),
      home: const BottomNavPage(),
    );
  }
}
