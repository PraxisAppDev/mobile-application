import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/leaderboard.dart' as leaderboard;

class AppStyles {
  static TextStyle appBarTextStyle = const TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontFamily: 'InriaSerif',
    fontWeight: FontWeight.bold
  );

  static BoxDecoration backgroundStyle = const BoxDecoration(
    image: DecorationImage(
        image: AssetImage(
            "images/cracked_background.jpg"
        ),
        fit: BoxFit.cover
    ),
  );

  static TextStyle logisticsStyle =
      const TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'InriaSerif');

  static TextStyle titleStyle =
      TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'InriaSerif');

  static BoxDecoration infoBoxStyle = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xFF454966),
        Color(0xFF523737),
        Color(0xFF54576C)
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(10)
  );

  static BoxDecoration textFieldStyle = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(10));

  static BoxDecoration confirmButtonStyle = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xFF155B3E),
        Color(0xFF246927),
        Color(0xFF26551A)
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(10)
  );

  static BoxDecoration cancelButtonStyle = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xFF6A0606),
        Color(0xFF903B3B),
        Color.fromARGB(255, 146, 14, 14)
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(10)
  );

  static BoxDecoration challengeButtonStyle = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFF534D5F),
          Color(0xFF745C6C),
          Color(0xFF514859)
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      borderRadius: BorderRadius.circular(10)
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontSize: 20,
      fontFamily: 'InriaSerif',
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static BoxDecoration buttonStyleVariation1 = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xFF313342),
        Color(0xFF876D6D),
        Color(0xFF2A2730)
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(20)
  );

  static BoxDecoration buttonStyleVariation2 = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color(0xFF836A6B),
        Color(0xFF3A3947),
        Color(0xFF876D6D),
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.circular(20)
  );
  static AppBar appBarStyle(String screenName, BuildContext context) {
    return AppBar(
      title: Text(screenName, style: AppStyles.appBarTextStyle),
      leading: IconButton(
        icon: const Icon(Icons.keyboard_double_arrow_left,
            color: Colors.white, size: 40),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.leaderboard),
            color: Colors.white,  // Uses the leaderboard icon
          onPressed: () {
            // Define the action for when the icon is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const leaderboard.Leaderboard()),
            );
          },
        ),
      ],
      centerTitle: true,
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: Image(
          image: const AssetImage("images/small_boomerang.jpg"),
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static AppBar noBackArrowAppBarStyle(String screenName, dynamic context) {
    return AppBar(
        title: Text(screenName, style: AppStyles.appBarTextStyle),
        centerTitle: true,
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Image(
            image: const AssetImage("images/small_boomerang.jpg"),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ));
  }

  static BoxDecoration popupStyle() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xff261919),
          Color(0xff332323),
          Color(0xff281717),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  static BoxDecoration challengeBoxStyle(int index, int currentChallenge) {
    if (index < currentChallenge) {
      return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF155B3E),
              Color(0xFF246927),
              Color(0xFF26551A)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(10)
      );
    } else if (index == currentChallenge) {
      return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF6A553D),
              Color(0xFF9D7E5A),
              Color(0xFF6A553D)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(10)
      );
    } else {
      return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF494444),
              Color(0xFF9A9797),
              Color(0xFF534D4D)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(10)
      );
    }
  }

}
