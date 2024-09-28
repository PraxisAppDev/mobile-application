import 'package:flutter/material.dart';

class JoinATeamView extends StatelessWidget {
  const JoinATeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Join A Team Screen'),
        ),
        body: const Center(
          child: Text(
            'Join A Team Screen, waiting for team leader to start hunt...',
            style: TextStyle(fontSize: 24), // Set font size
          ),
        ),
      ),
    );
  }
}
