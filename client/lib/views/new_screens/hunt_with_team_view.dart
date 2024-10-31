import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/create_a_team_view.dart';
import 'package:praxis_afterhours/views/new_screens/join_a_team_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class HuntWithTeamView extends StatelessWidget {
  final String huntId;
  final String huntName;
  final String venue;
  final String huntDate;
  const HuntWithTeamView({super.key, required this.huntId, required this.huntName, required this.venue, required this.huntDate});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Hunt With Team", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                    width: 350,
                    height: 150,
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.infoBoxStyle,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              huntName,
                              textAlign: TextAlign.left,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.white),
                            Text(
                              venue,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.white),
                            Text(
                              huntDate,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 100),
                Container(
                  height: 75,
                  width: 250,
                  decoration: AppStyles.buttonStyleVariation1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                JoinATeamView(huntID: huntId)),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Join a Team',
                        style: TextStyle(fontSize: 30)),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 75,
                  width: 250,
                  decoration: AppStyles.buttonStyleVariation2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateATeamView(huntId: huntId, huntName: huntName)),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Create a Team',
                        style: TextStyle(fontSize: 30)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
