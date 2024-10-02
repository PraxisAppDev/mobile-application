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
          body: const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/cracked_background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Center(
              child: Text(
                'Challenge Screen',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          )),
    );
  }
}
