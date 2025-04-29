import 'package:flutter/material.dart';
import '../../constants.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Options'),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text(
          'Options Screen - Coming Soon!',
          style: TextStyle(color: textColor, fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
