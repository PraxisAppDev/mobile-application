import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class StartHuntView extends StatelessWidget {
  const StartHuntView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Start Hunt", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Center(
            child: Container(
              height: 50,
              width: 175,
              decoration: AppStyles.confirmButtonStyle,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChallengeView()),
                  );
                },
                style: AppStyles.elevatedButtonStyle,
                child: const Text('Start Hunt', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
