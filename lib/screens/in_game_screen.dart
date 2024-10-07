// main.dart

import 'package:elemental_breaker/Constants/overlay_identifiers.dart';
import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:elemental_breaker/screens/paused_menu.dart';
import 'package:elemental_breaker/widgets/pause_button.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class InGameScreen extends StatelessWidget {
  const InGameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            Colors.grey.shade900, // Optional: Set a background color
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Stack(
            children: [
              GameWidget<ElementalBreaker>(
                game: ElementalBreaker(),
                initialActiveOverlays: [OverlayIdentifiers.pauseButton],
                overlayBuilderMap: {
                  OverlayIdentifiers.pauseButton:
                      (BuildContext context, ElementalBreaker game) {
                    return PauseButton(game: game);
                  },
                  OverlayIdentifiers.pausedMenu:
                      (BuildContext context, ElementalBreaker game) {
                    return PausedMenu(game: game);
                  },
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
