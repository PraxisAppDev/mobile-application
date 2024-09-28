import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your team name',
                ),
              ),
              const SizedBox(height: 20), // Add space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StartHuntView()),
                  );
                },
                child: const Text('Go to Start Hunt Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
