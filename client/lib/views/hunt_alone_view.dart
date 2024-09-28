import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/join_a_team_view.dart';

class HuntAloneView extends StatelessWidget {
  const HuntAloneView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hunt Alone Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JoinATeamView()),
              );
            },
            child: const Text('Go to Join A Team Screen'),
          ),
        ),
      ),
    );
  }
}
