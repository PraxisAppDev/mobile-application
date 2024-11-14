import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';
import 'package:praxis_afterhours/apis/hunts_api.dart' as hunts_api;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
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
    return Scaffold(
        appBar: AppStyles.noBackArrowAppBarStyle("Hunts", context),
        body: DecoratedBox(
            decoration: AppStyles.backgroundStyle,
            child: FutureBuilder<List<hunts_api.HuntResponseModel>>(
                future: hunts_api.getHunts(
                    startdate: '2024-10-01', enddate: '2024-10-31', limit: 4),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    // If the data was successfully retrieved, display it
                    final List<hunts_api.HuntResponseModel> huntResponse =
                        snapshot.data!;
                    return ListView.builder(
                      itemCount: huntResponse.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (index == 0)
                              SizedBox(height: 20),
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
                                            "${huntResponse[index].city}, ${huntResponse[index].stateAbbr}, ${huntResponse[index].zipcode}",
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
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HuntModeView(
                                                  huntId: huntResponse[index].id,
                                                  huntName: huntResponse[index].name,
                                                  venue: huntResponse[index].venue,
                                                  huntDate: truncatedDate(huntResponse[index].startDate),
                                                ),
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

                            const SizedBox(
                                height: 20), // Adding space between containers
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available.'));
                  }
                })));
  }

  String truncatedDate(String startDate) {
    String cleanedUtcString = startDate.replaceAll('[UTC]', '');

    DateTime utcDateTime = DateTime.parse(cleanedUtcString);

    final estLocation = tz.getLocation('America/New_York');

    tz.TZDateTime estDateTime = tz.TZDateTime.from(utcDateTime, estLocation);

    String formattedEst = DateFormat('yyyy-MM-dd HH:mm:ss').format(estDateTime);

    return "$formattedEst [EST]";
  }
}
