import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';

class HuntAloneView extends StatelessWidget {
  HuntAloneView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Hunt Alone",
          style: TextStyle(
            color: praxisWhite,
            fontSize: 35,
          ),
        ),
        backgroundColor: praxisRed,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                color: praxisWhite,
                child: const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your team name",
                  ),
                ),
              ),
            ),
            const Text(
              "\nYou will be put in a team which will be locked by default and contain only you.",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: const Color(0xFFEEEEEE),
                    child: TextButton(
                      onPressed: () {},
                      child: const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "I'm Ready!",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
