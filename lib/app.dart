import 'package:flutter/material.dart';
import 'package:elemental_breaker/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elemental Breaker',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
