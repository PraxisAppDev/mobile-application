import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class MyTeamCreateView extends StatelessWidget {
  final String teamName;
  final String individualName;

  const MyTeamCreateView(
      {super.key, required this.teamName, required this.individualName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBarStyle("My Team", context),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/cracked_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Team Name",
                style: AppStyles.logisticsStyle,
              ),
              const SizedBox(width: 350, child: Divider(thickness: 2)),
              Text(
                teamName,
                style: AppStyles.logisticsStyle,
              ),
              const SizedBox(height: 20),
              Container(
                height: 75,
                width: 325,
                padding: const EdgeInsets.all(16),
                decoration: AppStyles.infoBoxStyle,
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.crown, color: Color(0xFFFFD700)),
                    const SizedBox(width: 5),
                    Icon(Icons.person, color: Colors.green),
                    const SizedBox(width: 5),
                    SizedBox(
                      child: Text(
                        individualName,
                        style: AppStyles.logisticsStyle,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "(Me)",
                      style: AppStyles.logisticsStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: 175,
                decoration: AppStyles.confirmButtonStyle,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => const StartHuntView()),
                          builder: (context) => const ChallengeView()),
                    );
                  },
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text('Start Hunt',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: 175,
                decoration: AppStyles.cancelButtonStyle,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted team')),
                    );
                  },
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text('Delete Team',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}