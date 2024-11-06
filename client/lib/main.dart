import 'package:flutter/material.dart';
import 'package:praxis_afterhours/provider/game_model.dart';
import 'package:praxis_afterhours/provider/websocket_model.dart';
import 'package:praxis_afterhours/views/splash.dart';
import 'package:provider/provider.dart';

void main() {
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
