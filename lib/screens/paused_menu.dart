// paused_menu.dart

import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:flutter/material.dart';

class PausedMenu extends StatelessWidget {
  final ElementalBreaker game;

  const PausedMenu({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Paused',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('PausedMenu');
                game.resumeEngine();
              },
              child: Text('Resume'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement quit functionality as needed
                Navigator.pop(context);
              },
              child: Text('Quit'),
            ),
          ],
        ),
      ),
    );
  }
}
