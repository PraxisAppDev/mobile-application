import 'package:flutter/material.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Challenge Screen'),
        ),
        body: const Center(
          child: Text(
            'Challenge Screen',
            style: TextStyle(fontSize: 24), // Set font size
          ),
        ),
      ),
    );
  }
}
