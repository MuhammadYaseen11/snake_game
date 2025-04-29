import 'package:flutter/material.dart';
import '../../constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Snake Game'),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text(
          'Game Screen - Coming Soon!',
          style: TextStyle(color: textColor, fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.home),
      ),
    );
  }
}
