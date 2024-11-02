import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/dashboard/join_hunt_view.dart';
// import 'package:praxis_afterhours/views/new_screens/challenge_view.dart';
import 'package:praxis_afterhours/views/new_screens/leaderboard.dart';
import 'package:praxis_afterhours/views/new_screens/join_a_team_view.dart';
import 'package:praxis_afterhours/views/splash.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          expansionTileTheme: ExpansionTileThemeData(
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          fontFamily: "Poppins",
        ),
        home: Splash() //const Splash(),
        ),
  );
}
