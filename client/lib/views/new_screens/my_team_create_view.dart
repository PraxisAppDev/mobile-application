import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class MyTeamCreateView extends StatefulWidget {
  final String teamName;
  final String individualName;

  const MyTeamCreateView({
    Key? key,
    required this.teamName,
    required this.individualName,
  }) : super(key: key);

  @override
  _MyTeamCreateViewState createState() => _MyTeamCreateViewState();
}

class _MyTeamCreateViewState extends State<MyTeamCreateView> {
  late TextEditingController _teamNameController;
  late FocusNode _focusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(text: widget.teamName);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _unfocusTextField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusTextField,  // Unfocus when tapping outside the TextField
      child: Scaffold(
        appBar: AppStyles.appBarStyle("My Team", context),
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/cracked_background.jpg"),
              fit: BoxFit.cover,
            ),
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
                Container(
                  height: 75,
                  width: 325,
                  padding: const EdgeInsets.all(16),
                  decoration: AppStyles.infoBoxStyle,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _teamNameController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.edit, color: Colors.white),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText: _isEditing ? null : widget.teamName,
                            labelStyle: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            filled: true,
                            fillColor: Colors.grey,
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
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
                      Icon(FontAwesomeIcons.crown, color: Color(0xFFFFD700)),
                      const SizedBox(width: 5),
                      Icon(Icons.person, color: Colors.green),
                      const SizedBox(width: 5),
                      SizedBox(
                        child: Text(
                          widget.individualName,
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
                          builder: (context) => const ChallengeView(),
                        ),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text(
                      'Start Hunt',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    child: const Text(
                      'Delete Team',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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