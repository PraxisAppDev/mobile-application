import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle logisticsStyle =
    TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontFamily: 'InriaSerif');

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
      borderRadius: BorderRadius.circular(10));

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
      borderRadius: BorderRadius.circular(10));

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
      borderRadius: BorderRadius.circular(10));

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
}