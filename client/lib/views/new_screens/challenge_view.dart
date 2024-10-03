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
          body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/cracked_background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: FutureBuilder<hunts_api.HuntResponseModel>(
              future: hunts_api.getHunts(), // Call the async function here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the future to complete, show a loading indicator
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If there was an error, display it
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // If the data was successfully retrieved, display it
                  final huntResponse = snapshot.data!;
                  return Center(
                    child: Text(
                      huntResponse.message,
                      style: const TextStyle(fontSize: 24), // Set font size
                    ),
                  );
                } else {
                  // In case of unexpected state
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ),
      ),
    );
  }
}
