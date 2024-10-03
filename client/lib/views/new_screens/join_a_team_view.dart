import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;

class JoinATeamView extends StatelessWidget {
  const JoinATeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Join A Team Screen'),
        ),
        body: Column(
          children: [
            FutureBuilder<hunts_api.HuntsResponseModel>(
              future: hunts_api.getHunts("2024-10-02", "2024-10-03", 10), // Call the async function here
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
                      huntResponse.venue,
                      style: const TextStyle(fontSize: 24), // Set font size
                    ),
                  );
                } else {
                  // In case of unexpected state
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
            Center(
              child: Text(
              'Join A Team Screen, waiting for team leader to start hunt...',
              style: TextStyle(fontSize: 24), // Set font size
              ),
            ),
          ],
        )
      ),
    );
  }
}
