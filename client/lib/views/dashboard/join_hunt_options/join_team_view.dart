import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/apis/teams_api.dart' as teams_api;
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/reusables/hunt_structure.dart';
import 'package:praxis_afterhours/views/dashboard/join_hunt_options/waiting_room_view.dart';

class JoinTeamView extends StatefulWidget {
  final Hunt hunt;
  final String userId;
  const JoinTeamView({
    super.key,
    required this.hunt,
    required this.userId,
  });

  @override
  State<JoinTeamView> createState() => _JoinTeamViewState();
}

class _JoinTeamViewState extends State<JoinTeamView> {
  List<Team>? _teams;
  StreamSubscription<List<Team>>? _teamsSubscription;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _teamsSubscription = teams_api.watchListTeams(widget.hunt.id).listen((teams) {
      setState(() {
        _teams = teams;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
    _teamsSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 16,
                bottom: 100,
              ),
              centerTitle: false,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Select a Team",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight+16),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    Container(
                      color: praxisRed,
                      child: BasicTextField(
                        editingController: _searchController,
                        labelText: "Search for a team",
                        labelStyle: GoogleFonts.poppins(
                          color: praxisWhite,
                          fontSize: 16,
                        ),
                        fieldType: BasicTextFieldType.custom,
                        validatorError: "Please enter a team name",
                        keyboardType: TextInputType.text,
                        onChange: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: praxisRed,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _buildFilteredTeamTiles(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredTeamTiles() {
    List<Widget> teamTiles = [];
    if (_teams == null) {
      return [
        const Center(
          child: CircularProgressIndicator(),
        )
      ];
    }
    List<Team> teams = _teams!;
    if (teams.isEmpty) {
      return [
        Center(
          child: Text(
            "No teams have been created yet!",
            style: GoogleFonts.poppins(
              color: praxisBlack,
              fontSize: 32,
            ),
          ),
        )
      ];
    } else {
      for (Team team in teams) {
        teamTiles.add(_buildTeamTile(widget.hunt, team, widget.userId, context));
      }

      final filteredTiles = teamTiles.where((tile) {
        final teamName = tile.key.toString().toLowerCase();
        final searchQuery = _searchQuery.toLowerCase();
        return teamName.contains(searchQuery);
      }).toList();

      return filteredTiles.map((tile) {
        // final index = filteredTiles.indexOf(tile);
        // the animation occurs after the previous one implicitly
        // so no need to set animation delay based on index
        return tile.animate(delay: 150.milliseconds).fade().slideY(
              begin: 0.5,
              end: 0,
            );
      }).toList();
    }
  }

  Widget _buildTeamTile(
    Hunt hunt,
    Team team,
    String userId,
    BuildContext context,
  ) {
    return Card(
      key: Key(team.name),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Row(
            children: [
              Text(
                team.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (team.isLocked) const Icon(Icons.lock, color: Colors.grey),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Members (${team.players.length}/${hunt.maxTeamSize}):",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 16,
                    children: team.players.map((name) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(name.playerId,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  if (team.players.length == hunt.maxTeamSize)
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "This team is full!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                  else if (team.isLocked)
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "This team is locked!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {
                          openWaitingRoomView(context, hunt, team, userId);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: praxisRed,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Join Team',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void openWaitingRoomView(BuildContext context, Hunt hunt, Team team, String userId) {}
}

enum BasicTextFieldType {
  email,
  password,
  username,
  custom,
}

class BasicTextField extends StatelessWidget {
  final TextEditingController editingController;
  final String labelText;
  final BasicTextFieldType fieldType;
  final String validatorError;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChange;
  final TextStyle labelStyle;

  const BasicTextField({
    super.key,
    required this.editingController,
    required this.labelText,
    this.fieldType = BasicTextFieldType.custom,
    required this.validatorError,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChange,
    this.labelStyle = const TextStyle(fontSize: 16),
  });

  String? validatorFunction(String? value) {
    if (value == null || value.isEmpty) {
      return validatorError;
    }
    switch (fieldType) {
      case BasicTextFieldType.email:
        final emailRegex =
            RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
        if (!emailRegex.hasMatch(value)) {
          return 'Invalid email format';
        }
        break;
      case BasicTextFieldType.password:
        if (value.length < 8) {
          return 'Password should be at least 6 characters long';
        }
        final passwordRegex = RegExp(
            r"^(?=.{8,})(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.+=]).*$");
        if (!passwordRegex.hasMatch(value)) {
          return 'Invalid password';
        }
        break;
      case BasicTextFieldType.username:
        if (value.length < 3) {
          return 'Username should be at least 3 characters long';
        }
        break;
      case BasicTextFieldType.custom:
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validatorFunction,
      controller: editingController,
      onChanged: onChange,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: const UnderlineInputBorder(),
      ),
    );
  }
}
