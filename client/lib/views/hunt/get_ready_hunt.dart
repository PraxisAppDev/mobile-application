import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/views/hunt_challenge_screen.dart';

class GetReadyHuntView extends StatefulWidget {
  const GetReadyHuntView({super.key});

  @override
  State<GetReadyHuntView> createState() => _GetReadyHuntViewState();
}

class _GetReadyHuntViewState extends State<GetReadyHuntView> {
  int status = 1;

  void _updateStatus() {
    setState(() {
      status = (status + 2) % 3 - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: praxisRed,
      appBar: AppBar(
        backgroundColor: praxisRed,
        elevation: 0,
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: praxisWhite),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Instructions"),
                    content: const Text(
                        "You are currently in the waiting room. You will be assigned to a team shortly."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              _buildContent(context),
              const SizedBox(height: 16),
              _buildButtons(context),
              const SizedBox(height: 16),
              // _buildTestingButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (status) {
      case -1:
        return const Column(
          children: [
            Icon(Icons.close, size: 80, color: praxisWhite),
            SizedBox(height: 16),
            Text(
              "You have been kicked from the waiting room.",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: praxisWhite,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 1:
        return const Column(
          children: [
            Icon(Icons.check_circle, size: 80, color: praxisWhite),
            SizedBox(height: 16),
            Text(
              "Get Ready!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: praxisWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '"Recruit Mixer" is starting in 1 minute 15 seconds!',
              style: TextStyle(fontSize: 18, color: praxisWhite),
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return const Column(
          children: [
            Icon(Icons.hourglass_empty, size: 80, color: praxisWhite),
            SizedBox(height: 16),
            Text(
              "Waiting for Team Leader",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: praxisWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "... don't worry! there are 4 other people requesting this team",
              style: TextStyle(fontSize: 18, color: praxisWhite),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }

  Widget _buildButtons(BuildContext context) {
    switch (status) {
      case -1:
        return ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: praxisRed,
            backgroundColor: praxisWhite,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "See other teams",
            style: TextStyle(fontSize: 18),
          ),
        );
      case 1:
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle "My Team" button press
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: praxisRed,
                backgroundColor: praxisWhite,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "My Team",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Handle "Instructions" button press
              },
              child: const Text(
                "Instructions",
                style: TextStyle(fontSize: 18, color: praxisWhite),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Handle "Exit Challenge" button press
              },
              child: const Text(
                "Exit Challenge",
                style: TextStyle(fontSize: 18, color: praxisWhite),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HuntChallengeScreen(),
                  ),
                );
              },
              child: const Text(
                "(Go to Hunt Challenge mock screen)",
                style: TextStyle(fontSize: 18, color: praxisWhite),
              ),
            ),
          ],
        );
      default:
        return ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: praxisRed,
            backgroundColor: praxisWhite,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Leave Waiting Room",
            style: TextStyle(fontSize: 18),
          ),
        );
    }
  }

  // Widget _buildTestingButton() {
  //   return ElevatedButton(
  //     onPressed: _updateStatus,
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: praxisRed,
  //       backgroundColor: praxisWhite,
  //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //     ),
  //     child: Text(
  //       "Testing: $status",
  //       style: const TextStyle(fontSize: 14),
  //     ),
  //   );
  // }
}
