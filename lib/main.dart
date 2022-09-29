import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Locals',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xff494949),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.grey,
          backgroundColor: Color(0xFF161616),
        ),
        canvasColor: const Color(0xFF1f1f1f),
      ),
      themeMode: ThemeMode.dark,
      home: const Home(),
    );
  }
}