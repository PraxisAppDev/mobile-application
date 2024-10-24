import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_alone_team_name_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_alone_view.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_with_team_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class HuntModeView extends StatelessWidget {
  //const HuntModeView({super.key});
  final String huntName;
  final String venue;
  final String huntDate;
  const HuntModeView(
      {super.key,
      required this.huntName,
      required this.venue,
      required this.huntDate});

  //@override
  //_HuntModeViewState createState() => _HuntModeViewState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppStyles.appBarStyle("Hunt Mode", context),
        body: DecoratedBox(
          decoration: AppStyles.backgroundStyle,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 25),
                Text(
                  "Chosen Hunt",
                  style: AppStyles.titleStyle,
                ),
                const SizedBox(width: 350, child: Divider(thickness: 2)),
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
                const SizedBox(height: 75),
                Text(
                  "Game Mode",
                  style: AppStyles.titleStyle,
                ),
                const SizedBox(width: 350, child: Divider(thickness: 2)),
                Container(
                  height: 75,
                  width: 200,
                  decoration: AppStyles.buttonStyleVariation1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HuntAloneTeamNameView(
                                huntName: huntName,
                                venue: venue,
                                huntDate: huntDate)),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Hunt Alone',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 75,
                  width: 200,
                  decoration: AppStyles.buttonStyleVariation2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HuntWithTeamView(
                                huntName: huntName,
                                venue: venue,
                                huntDate: huntDate)),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Hunt With Team',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24)),
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

// class _HuntModeViewState extends State<HuntModeView>{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }