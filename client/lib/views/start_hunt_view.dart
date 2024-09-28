import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/challenge_view.dart';

class StartHuntView extends StatelessWidget {
  const StartHuntView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Start Hunt Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChallengeView()),
              );
            },
            child: const Text('Start Hunt'),
          ),
        ),
      ),
    );
  }
}
