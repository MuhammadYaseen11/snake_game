import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import 'game_screen.dart';
import 'options_screen.dart';
import '../constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SNAKE GAME', style: titleStyle),
            const SizedBox(height: 60),
            MenuButton(
              text: 'PLAY',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            MenuButton(
              text: 'OPTIONS',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OptionsScreen(),
                  ),
                );
              },
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            MenuButton(
              text: 'QUIT',
              onPressed: () {
                // Close the app
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
