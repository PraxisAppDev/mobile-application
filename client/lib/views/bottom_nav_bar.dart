import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/views/hunt_history_view.dart';
import 'package:praxis_afterhours/views/dashboard/join_hunt_view.dart';
import 'package:praxis_afterhours/views/profile_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 0;
  final screens = [
    const JoinHuntView(),
    //const HuntHistoryView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: praxisRed,
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.play_arrow,
              color: currentPageIndex == 0 ? Colors.white : Colors.black,
            ),
            label: "Join a Hunt",
          ),
          // NavigationDestination(
          //   icon: Icon(
          //     Icons.history,
          //     color: currentPageIndex == 1 ? Colors.white : Colors.black,
          //   ),
          //   label: "History",
          // ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color: currentPageIndex == 2 ? Colors.white : Colors.black,
            ),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
