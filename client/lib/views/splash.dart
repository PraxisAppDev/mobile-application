import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/join_a_hunt_view.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigate(context);
  }

  _navigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  JoinAHuntView(), //const BottomNavBar(),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Stack(
        children: [
          Center(
            child: Positioned(
                child: Image(
                    width: 1000,
                    height: 1000,
                    image: AssetImage('assets/logo/logo.png'))),
          ),
          Positioned(
              bottom: -40,
              right: -30,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image(
                    width: 200,
                    height: 200,
                    image: AssetImage('assets/logo/corner_logo.png')),
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image(
                  width: 100,
                  height: 100,
                  image: AssetImage('assets/logo/copyright.png'))),
        ],
      ),
    );
  }
}
