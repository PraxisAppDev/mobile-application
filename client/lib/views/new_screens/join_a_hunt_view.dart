import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '../../provider/game_model.dart';
import 'hunt_mode_view.dart';

class JoinAHuntView extends StatefulWidget {
  const JoinAHuntView({super.key});

  @override
  _JoinAHuntViewState createState() => _JoinAHuntViewState();
}

class _JoinAHuntViewState extends State<JoinAHuntView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final huntProgressModel = Provider.of<HuntProgressModel>(context, listen: true);

    return Scaffold(
      appBar: AppStyles.homeAppBarStyle("Hunts", context),
      body: DecoratedBox(
        decoration: AppStyles.backgroundStyle,
        child: FutureBuilder<List<hunts_api.HuntResponseModel>>(
          future: hunts_api.getHunts(
            startdate: '2024-10-01',
            enddate: '2025-03-31',
            limit: 4,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final List<hunts_api.HuntResponseModel> huntResponse = snapshot.data!;

              return ListView.builder(
                itemCount: huntResponse.length,
                itemBuilder: (context, index) {
                  final isPressed = huntProgressModel.pressedHunts.contains(index);

                  return Column(
                    children: [
                      if (index == 0) SizedBox(height: 20),
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: 375,
                            padding: const EdgeInsets.all(16),
                            decoration: AppStyles.infoBoxStyle,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_pin, color: Colors.transparent),
                                    SizedBox(width: 5),
                                    Text(
                                      huntResponse[index].name,
                                      textAlign: TextAlign.left,
                                      style: AppStyles.logisticsStyle.copyWith(fontSize: 20),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_pin, color: Colors.white),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          huntResponse[index].venue,
                                          style: AppStyles.logisticsStyle,
                                        ),
                                        Text(
                                          huntResponse[index].address,
                                          style: AppStyles.logisticsStyle.copyWith(fontSize: 12),
                                        ),
                                        Text(
                                          huntResponse[index].city,
                                          style: AppStyles.logisticsStyle.copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 50,
                                      width: 75,
                                      decoration: AppStyles.confirmButtonStyle,
                                      child: ElevatedButton(
                                        onPressed: isPressed
                                            ? null // Disable button if already pressed
                                            : () {
                                          setState(() {
                                            huntProgressModel.currentHuntIndex = index;
                                          });
                                          huntProgressModel.huntName = huntResponse[index].name;
                                          huntProgressModel.venue = huntResponse[index].venue;
                                          huntProgressModel.huntDate =
                                              truncatedDate(huntResponse[index].startDate);
                                          huntProgressModel.huntId = huntResponse[index].id;
                                          huntProgressModel.city = huntResponse[index].city;
                                          huntProgressModel.stateAbbr =
                                              huntResponse[index].stateAbbr;
                                          huntProgressModel.zipCode = huntResponse[index].zipcode;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HuntModeView(),
                                            ),
                                          );
                                        },
                                        style: AppStyles.elevatedButtonStyle,
                                        child: const Text(
                                          'GO',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text(
                                      truncatedDate(huntResponse[index].startDate),
                                      style: AppStyles.logisticsStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Blur effect when button is pressed
                          if (isPressed)
                            Positioned.fill( // Ensures it spans the entire container
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20), // Adding space between containers
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ),
      ),
    );
  }

  String truncatedDate(String startDate) {
    String cleanedUtcString = startDate.replaceAll('[UTC]', '').trim();
    DateTime utcDateTime = DateTime.parse(cleanedUtcString);
    final estLocation = tz.getLocation('America/New_York');
    tz.TZDateTime estDateTime = tz.TZDateTime.from(utcDateTime, estLocation);

    String formattedEst = DateFormat('MM/dd/yyyy h:mm a').format(estDateTime);
    return formattedEst;
  }
}