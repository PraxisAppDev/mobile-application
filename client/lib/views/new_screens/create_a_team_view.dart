import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';

class CreateATeamView extends StatelessWidget {
  const CreateATeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create a Team Screen'),
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
