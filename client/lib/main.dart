import 'package:flutter/material.dart';
import 'package:praxis_afterhours/provider/game_model.dart';
import 'package:praxis_afterhours/provider/websocket_model.dart';
import 'package:praxis_afterhours/views/splash.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();

  // Set the default error widget to a easier to read one
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.black, // Background color
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Text(
          details.exceptionAsString(),
          style: const TextStyle(
            color: Colors.white, // Make text white
            fontSize: 14,
          ),
        ),
      ),
    );
  };


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HuntProgressModel()),
        ChangeNotifierProvider(create: (context) => WebSocketModel())
      ],
      child: MaterialApp(
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
        home: const Splash(),
      ),
    ),
  );
}
