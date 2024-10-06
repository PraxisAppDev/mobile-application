import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class HuntAloneView extends StatefulWidget {
  final String teamName;
  final String huntName;
  final String venue;
  final String huntDate;
  const HuntAloneView({super.key, required this.teamName, required this.huntName, required this.venue, required this.huntDate});

  @override
  _HuntAloneViewState createState() => _HuntAloneViewState();
}

class _HuntAloneViewState extends State<HuntAloneView> {
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
        onTap: _unfocusTextField,
        child: Scaffold(
          appBar: AppStyles.appBarStyle("Hunt Alone", context),
          body: DecoratedBox(
            decoration: AppStyles.backgroundStyle,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 350,
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.infoBoxStyle,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.huntName,
                              textAlign: TextAlign.left,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.white),
                            Text(
                              widget.venue,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.white),
                            Text(
                              widget.huntDate,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "You are currently hunting alone as: ${widget.teamName}",
                    style: AppStyles.logisticsStyle,
                  ),
                  const SizedBox(width: 350, child: Divider(thickness: 2)),
                  Container(
                    height: 75,
                    width: 350,
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.infoBoxStyle,
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 205,
                          child: TextField(
                            //controller: _teamNameController,
                            //focusNode: _focusNode,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit, color: Colors.white),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              filled: true,
                              fillColor: Colors.grey,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.lock, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          "(Solo)",
                          style: AppStyles.logisticsStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(width: 350, child: Divider(thickness: 2)),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.infoBoxStyle,
                    child: const Text(
                      "There are 3 teams and one solo team currently hunting. Select \"Start Hunt\" when you are ready to begin.",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'InriaSerif'),
                    ),
                  ),
                  const SizedBox(height: 50),
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
                  const SizedBox(height: 50),
                  Container(
                    height: 50,
                    width: 175,
                    decoration: AppStyles.cancelButtonStyle,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                              Text('Deleted solo team')),
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
        ),
      );
  }
}
