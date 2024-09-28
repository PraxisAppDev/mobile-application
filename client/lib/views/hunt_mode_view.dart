import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/hunt_alone_view.dart';
import 'package:praxis_afterhours/views/hunt_with_team_view.dart';

class HuntModeView extends StatelessWidget {
  const HuntModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hunt Mode Screen'),
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
                        builder: (context) => const HuntAloneView()),
                  );
                },
                child: const Text('Go to Hunt Alone Screen'),
              ),
              const SizedBox(height: 20), // Add space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HuntWithTeamView()),
                  );
                },
                child: const Text('Go to Hunt With Team Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
