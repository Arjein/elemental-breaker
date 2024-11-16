import 'package:elemental_breaker/elemental_breaker.dart';
import 'package:flutter/material.dart';
import 'package:elemental_breaker/screens/in_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void navigateToGame(BuildContext context, ElementalBreaker game) {
    Navigator.of(context).push(_customPageRoute(InGameScreen(
      elementalBreakerGame: game,
    )));
  }

  PageRouteBuilder _customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Scale and fade transition
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            ElementalBreaker game = ElementalBreaker();
            navigateToGame(context, game);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8.0), // Adjust this value to make the corners less rounded
            ),
            side: BorderSide(
              color: Colors.blue, // Border color
              width: 2, // Border width
            ),
            textStyle:
                const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          child: const Text('Play'),
        ),
      ),
    );
  }
}
