import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';

class HuntAloneView extends StatelessWidget {
  const HuntAloneView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hunt Alone Screen'),
        ),
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
                              "Explore Praxis",
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
                              "The Greene Turtle (in-person only)",
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.white),
                            Text(
                              "01/30/2024 at 8:30pm",
                              style: AppStyles.logisticsStyle,
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                Text(
                  "You are currently hunting alone as...",
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
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit, color: Colors.white),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Enter name here...',
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              filled: true,
                              fillColor: Colors.grey),
                          style: TextStyle(color: Colors.white),
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
                const SizedBox(height: 50), // Add space between buttons
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.confirmButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StartHuntView()),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Start Hunt'),
                  ),
                ),
                const SizedBox(height: 50), // Add space between buttons
                Container(
                  height: 50,
                  width: 175,
                  decoration: AppStyles.cancelButtonStyle,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StartHuntView()),
                      );
                    },
                    style: AppStyles.elevatedButtonStyle,
                    child: const Text('Delete Team'),
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
