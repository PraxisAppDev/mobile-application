import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/create_a_team_view.dart';
import 'package:praxis_afterhours/views/new_screens/join_a_team_view.dart';

class HuntWithTeamView extends StatelessWidget {
  const HuntWithTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hunt With Team Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateATeamView()),
                  );
                },
                child: const Text('Go to Create A Team Screen'),
              ),
              const SizedBox(height: 20), // Add space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JoinATeamView()),
                  );
                },
                child: const Text('Go to Join A Team Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
