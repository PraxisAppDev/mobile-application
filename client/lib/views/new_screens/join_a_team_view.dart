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
        body: FutureBuilder<List<hunts_api.HuntResponseModel>>(
          future: hunts_api.getHunts(startdate: '2024-10-01', enddate: '2024-10-31', limit: 10),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // If the data was successfully retrieved, display it
              final List<hunts_api.HuntResponseModel> huntResponse = snapshot.data!;
              print(snapshot.data);
              return ListView.builder(
                itemCount: huntResponse.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(huntResponse[index].name),
                    subtitle: Text(huntResponse[index].venue),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        )
      ),
    );
  }
}
