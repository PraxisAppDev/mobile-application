import 'package:flutter/material.dart';
import 'package:praxis_afterhours/constants/colors.dart';

class ProfileAvatar extends StatefulWidget {
  final String firstName;
  final String lastName;
  final double screenWidth;

  const ProfileAvatar(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.screenWidth});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor: praxisWhite,
            ),
            child: AlertDialog(
              title: const Text('Edit Profile Picture'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    children: [
                      buildProfileImage(
                        widget.firstName,
                        widget.lastName,
                        200,
                        praxisRed,
                      ),
                      buildProfileImage(
                        widget.firstName,
                        widget.lastName,
                        200,
                        Colors.blue,
                      ),
                      buildProfileImage(
                        widget.firstName,
                        widget.lastName,
                        200,
                        Colors.green,
                      ),
                      buildProfileImage(
                        widget.firstName,
                        widget.lastName,
                        200,
                        Colors.yellow,
                      ),
                      buildProfileImage(
                        widget.firstName,
                        widget.lastName,
                        200,
                        Colors.pink,
                      ),
                      buildProfileImage(
                        widget.firstName,
                        widget.lastName,
                        200,
                        Colors.orange,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: praxisWhite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                                color: praxisBlack,
                                width: 0.3) // Adjust the border radius here
                            )),
                    child: const Text('Upload new profile picture',
                        style: TextStyle(color: praxisBlack)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: buildProfileImage(
        widget.firstName,
        widget.lastName,
        widget.screenWidth,
        null,
      ),
    );
  }
}

// Build default from username for now
Widget buildProfileImage(String firstName, String lastName, double screenWidth,
    Color? backgroundColor) {
  // Extract initials from username
  String initials = firstName[0];

  // If last name exists
  if (lastName.isNotEmpty) {
    initials += lastName[0];
  }

  double avatarSize = screenWidth * 0.3;
  double maxAvatarSize = 150;

  // Limit avatar size for larger screen
  if (screenWidth > 600) {
    avatarSize = maxAvatarSize;
  }

  double fontSize = avatarSize * 0.5;

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? praxisGrey,
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
                color: praxisBlack,
                fontWeight: FontWeight.bold,
                fontSize: fontSize),
          ),
        )),
  );
}
