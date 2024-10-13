import 'package:flutter/material.dart';
import 'package:praxis_afterhours/reusables/hunt_structure.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/views/new_screens/my_team_create_view.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart'; 
import 'package:praxis_afterhours/apis/teams_api.dart'; 

class CreateATeamView extends StatefulWidget {
  final String huntName;
  final String venue;
  final String huntDate;

  const CreateATeamView({
    super.key,
    required this.huntName,
    required this.venue,
    required this.huntDate,
  });

  @override
  _CreateATeamViewState createState() => _CreateATeamViewState();
}

class _CreateATeamViewState extends State<CreateATeamView> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _individualNameController = TextEditingController();
  final FocusNode _teamFocusNode = FocusNode();
  final FocusNode _individualFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _teamFocusNode.addListener(() {});
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _teamFocusNode.dispose();
    _individualNameController.dispose();
    _individualFocusNode.dispose();
    super.dispose();
  }

  Future<String?> getHuntIdByName(String huntName) async {
    try {
      List<HuntResponseModel> hunts = await getHunts(); 
      final hunt = hunts.firstWhere((hunt) => hunt.name == huntName);
      return hunt?.id; 
    } catch (e) {
      print("Error fetching hunt: $e");
      return null;
    }
  }

  Future<void> _createTeam() async {
    String teamName = _teamNameController.text.trim();
    String playerName = _individualNameController.text.trim();

    if (teamName.isEmpty || playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both team name and player name.')),
      );
      return;
    }

    String? huntId = await getHuntIdByName(widget.huntName);
    if (huntId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to find hunt with name: ${widget.huntName}.')),
      );
      return;
    }

    try {
      Team newTeam = await createTeam(huntId, teamName, playerName, false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team "${newTeam.name}" created successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyTeamCreateView(
            teamName: newTeam.name,
            individualName: playerName,
            huntName: widget.huntName,
            venue: widget.venue,
            huntDate: widget.huntDate,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create team: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Create Team", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hunt Details",
                  style: AppStyles.logisticsStyle,
                ),
                const SizedBox(width: 350, child: Divider(thickness: 2)),
                Text(
                  "Hunt: ${widget.huntName}",
                  style: AppStyles.logisticsStyle,
                ),
                Text(
                  "Venue: ${widget.venue}",
                  style: AppStyles.logisticsStyle,
                ),
                Text(
                  "Date: ${widget.huntDate}",
                  style: AppStyles.logisticsStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  "Choose Your Team Name",
                  style: AppStyles.logisticsStyle,
                ),
                const SizedBox(width: 350, child: Divider(thickness: 2)),
                SizedBox(
                  width: 325,
                  child: TextField(
                    controller: _teamNameController,
                    focusNode: _teamFocusNode,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Enter team name here...',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 75,
                  width: 325,
                  padding: const EdgeInsets.all(16),
                  decoration: AppStyles.infoBoxStyle,
                  child: Row(
                    children: [
                      Text(
                        "(Me)",
                        style: AppStyles.logisticsStyle,
                      ),
                      Icon(Icons.person, color: Colors.green),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 205,
                        child: TextField(
                          controller: _individualNameController,
                          focusNode: _individualFocusNode,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.edit, color: Colors.white),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Enter name here...',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                            filled: true,
                            fillColor: Colors.grey,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.confirmButtonStyle,
                  child: ElevatedButton(
                    onPressed: _createTeam, // Call the create team function
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
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
