import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform, exit;
import '../widgets/menu_button.dart';
import 'game_screen.dart';
import 'options_screen.dart';
import '../constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Method to handle Play button
  void _playGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  // Method to handle Options button
  void _openOptions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OptionsScreen()),
    );
  }

  // Method to handle Quit button
  void _quitApp(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: backgroundColor.withOpacity(0.9),
            title: const Text(
              'Quit Game',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to exit?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Close dialog
                  Navigator.pop(context);

                  try {
                    if (kIsWeb) {
                      // For web - we can't really quit, but we can attempt to close the current tab
                      // This may be blocked by browsers
                      SystemChannels.platform.invokeMethod(
                        'SystemNavigator.pop',
                      );
                    } else if (Platform.isAndroid) {
                      SystemNavigator.pop(); // Android-specific exit
                    } else if (Platform.isIOS) {
                      exit(0); // Force exit on iOS
                    } else {
                      // For desktop platforms (Windows, macOS, Linux)
                      exit(
                        0,
                      ); // This is a hard exit that should work on desktop
                    }
                  } catch (e) {
                    // Fallback method if the above fails
                    Text('Error occurred while trying to exit.');

                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Unable to exit the app on this platform.",
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text('QUIT', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

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
            MenuButton(text: 'PLAY', onPressed: () => _playGame(context)),
            const SizedBox(height: 20),
            MenuButton(
              text: 'OPTIONS',
              onPressed: () => _openOptions(context),
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            MenuButton(
              text: 'QUIT',
              onPressed: () => _quitApp(context),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
