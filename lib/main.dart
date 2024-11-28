import 'package:flutter/material.dart';
import 'package:elemental_breaker/screens/home_screen.dart';

// Launch ekranında animasyon yukarıda logo starta basınca aşşağıya launchera dönüşecek
void main() {
  runApp(
    MaterialApp(
      title: 'Elemental Breaker',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    ),
  );
}
 