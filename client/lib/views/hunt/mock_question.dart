import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/constants/colors.dart';

class MockQuestionView extends StatelessWidget {
  const MockQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: praxisRed,
        title: Text(
          "Question 1",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.person_outline_outlined)),
          IconButton(onPressed: () => {}, icon: const Icon(Icons.timer_sharp)),
          Text("2:36:42",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 35,
              )),
        ],
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "What company's logo is this?",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "images/google.png",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Your Answer:",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 35,
              )),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Answer Here",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(praxisRed),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  side: const BorderSide(color: praxisRed),
                ),
              ),
            ),
            onPressed: () => {challengeSuccessDialog(context)},
            child: Text(
              "Submit",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "30 guesses left",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "(59 seconds until next guess)",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ]),
    );
  }

  Future<dynamic> challengeSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Congrats!",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
                bottom: 80.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Text(
                "You solved \"Question 1\"!",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.check_outlined,
                color: Colors.green,
                size: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
                bottom: 80.0,
                left: 8.0,
                right: 8.0,
              ),
              child: TextButton(
                style: ButtonStyle(
                  // backgroundColor: const MaterialStatePropertyAll(praxisRed),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.pop(context),
                },
                child: Text(
                  "Back to Problem List",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
