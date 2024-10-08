import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;
import 'package:praxis_afterhours/styles/app_styles.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppStyles.appBarStyle("Challenge Screen", context),
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
