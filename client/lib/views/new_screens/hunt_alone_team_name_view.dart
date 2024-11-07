import 'package:flutter/material.dart';
import 'package:praxis_afterhours/apis/post_create_teams.dart';
import 'package:praxis_afterhours/apis/put_start_hunt.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_alone_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class HuntAloneTeamNameView extends StatefulWidget {
  final String huntId;
  final String huntName;
  final String venue;
  final String huntDate;
  const HuntAloneTeamNameView(
      {super.key,
      required this.huntId,
      required this.huntName,
      required this.venue,
      required this.huntDate});

  @override
  _HuntAloneTeamViewState createState() => _HuntAloneTeamViewState();
}

class _HuntAloneTeamViewState extends State<HuntAloneTeamNameView> {
  final TextEditingController _teamNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _teamNameController.dispose();
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
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyles.infoBoxStyle,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.huntName,
                              textAlign: TextAlign.left,
                              style: AppStyles.titleStyle.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.white),
                            Text(
                              widget.venue,
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                    )),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'You are hunting alone You have chosen to hunt alone, please enter your team name:',
                  style: AppStyles.logisticsStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 250,
                child: TextField(
                  controller: _teamNameController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: _isFocused ? null : 'Enter your team name here',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 200,
                height: 60,
                child: Stack(
                  children: [
                    Container(
                      decoration: AppStyles.confirmButtonStyle,
                    ),
                    ElevatedButton(
                      style: AppStyles.elevatedButtonStyle,
                      onPressed: () {
                        if (_teamNameController.text.trim().isEmpty) {
                          ShowEmptyTeamDialog(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HuntAloneView(
                                  teamName: _teamNameController.text.trim(),
                                  huntId: widget.huntId,
                                  huntName: widget.huntName,
                                  venue: widget.venue,
                                  huntDate: widget.huntDate), // Pass the huntID
                            ),
                          );
                        }
                      },
                      child: const Center(
                        child: Text('Continue',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Tells players the game is starting, dissappears after 3 seconds
Future<void> ShowEmptyTeamDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.black,
          contentPadding: EdgeInsets.all(0),
          content: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff261919),
                    Color(0xff332323),
                    Color(0xff261919),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 32,
                          ),
                          Expanded(
                            child: DotDivider,
                          ),
                          SizedBox(
                              width: 32,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close, color: Colors.white)))
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Your team name cannot be empty!',
                        style: AppStyles.titleStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 45, child: DotDivider)
                  ],
                ),
              )));
    },
  );
}
