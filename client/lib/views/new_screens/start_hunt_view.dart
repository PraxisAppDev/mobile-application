import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/fetch_challenges.dart';
import 'package:praxis_afterhours/apis/fetch_hunts.dart';
import 'package:praxis_afterhours/apis/fetch_teams.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view_2.dart';

class StartHuntView extends StatefulWidget {
  final String huntID;
  
  const StartHuntView({super.key, required this.huntID});

  @override
  _StartHuntViewState createState() => _StartHuntViewState();
}

class _StartHuntViewState extends State<StartHuntView> {
  List<dynamic> challenges = [];
  List<dynamic> hunts = [];
  late List<dynamic> teams = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchChallengesData(); // Fetch challenges when the widget is initialized
    fetchHuntsData();
    fetchTeamsData();
  }

  Future<void> fetchChallengesData() async {
    var data = await fetchChallenges(widget.huntID); // Call the imported fetchChallenges function
    setState(() {
      challenges = data;  // Update the challenges list
      isLoading = false;  // Update loading state
    });
  }

  Future<void> fetchHuntsData() async {
    var data = await fetchHunts(); // Call the imported fetchChallenges function
    setState(() {
      hunts = data;  // Update the challenges list
      isLoading = false;  // Update loading state
    });
  }

  Future<void> fetchTeamsData() async {
    var data = await fetchTeamsFromHunt(widget.huntID); // Call the imported fetchTeamsFromHunt function
    setState(() {
      teams = data;  // Update the challenges list
      isLoading = false;  // Update loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Start Hunt", context),
        body: Center(
            child: Column(
              children: [
                Text("Challenges:", style: TextStyle(fontSize: 12)),
                for (var challenge in challenges)
                  Text(challenge.toString(), style: TextStyle(fontSize: 12)),
                Text("\nHunts:", style: TextStyle(fontSize: 12)),
                for (var hunt in hunts)
                  Text(hunt.toString(), style: TextStyle(fontSize: 12)),
                Text("\nTeams:", style: TextStyle(fontSize: 12)),
                Flexible(  // Use Expanded to prevent ListView from causing layout overflow
                  child: ListView(
                    shrinkWrap: true,
                    children: teams.map((team) {
                      String key = team.key;
                      dynamic value = team.value;
                      return Text(
                        '$key: $value',
                        style: TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
                Text("\nEnd", style: TextStyle(fontSize: 12)),
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
                            builder: (context) => StartHuntView2()),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Start Hunt',
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
