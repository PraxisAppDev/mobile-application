import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/views/instructions.dart';

class HuntHistoryView extends StatelessWidget {
  const HuntHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock API Data
    const eventsJson = [
      {
        "place": 5,
        "title": "Recruit Mixer",
        "location": "The Greene Turtle (In-Person Only)",
        "date": "01/30/024 at 8:30 PM"
      },
      {
        "place": 1,
        "title": "Friday Employee Drinks",
        "location": "Looney's Pub",
        "date": "2/07/2024 at 7:30 PM"
      },
      {
        "place": 3,
        "title": "End of Quarter Party",
        "location": "Cornerstone Grill & Loft",
        "date": "02/14/2024 at 7:00 PM"
      },
      {
        "place": 4,
        "title": "Event",
        "location": "Location",
        "date": "02/28/2024 at 6:00 PM"
      },
    ];

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            "Hunt History",
            style: TextStyle(
              color: praxisWhite,
              fontSize: 35,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Instructions(
                              title: 'Instructions',
                            )),
                  )
                },
                icon: const Icon(Icons.info_outline),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.notifications),
              ),
            )
          ],
          backgroundColor: praxisRed,
        ),
        body: Column(
            children: eventsJson.map((event) {
          final String huntId = event['_id'].toString();
          final String place = event['place'].toString();
          final String title = event['title'].toString();
          final String location = event['location'].toString();
          final String date = event['date'].toString();

          return buildEvent(huntId, title, location, date, place);
        }).toList()));
  }
}

Widget buildEvent(String huntId, String title, String location, String date, String place) {
  return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 0, right: 0),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () {},
                child: const SizedBox()),
          ),
        ],
      )
  );
}
