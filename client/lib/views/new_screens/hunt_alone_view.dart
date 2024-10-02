import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/start_hunt_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';


class HuntAloneView extends StatefulWidget {
 final String teamName;
 const HuntAloneView({super.key, required this.teamName});


 @override
 _HuntAloneViewState createState() => _HuntAloneViewState();
}


class _HuntAloneViewState extends State<HuntAloneView> {
 late TextEditingController _teamNameController;
 late FocusNode _focusNode;
 bool _isEditing = false;


 @override
 void initState() {
   super.initState();
   _teamNameController = TextEditingController(text: widget.teamName);
   _focusNode = FocusNode();


   _focusNode.addListener(() {
     setState(() {
       _isEditing = _focusNode.hasFocus;
     });
   });
 }


 @override
 void dispose() {
   _teamNameController.dispose();
   _focusNode.dispose();
   super.dispose();
 }


 void _unfocusTextField() {
   if (_focusNode.hasFocus) {
     _focusNode.unfocus();
   }
 }


 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     home: GestureDetector(
       onTap: _unfocusTextField,
       child: Scaffold(
         appBar: AppStyles.appBarStyle("Hunt Alone Screen", context),
         body: DecoratedBox(
           decoration: AppStyles.backgroundStyle,
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                   height: 150,
                   width: 350,
                   padding: const EdgeInsets.all(16),
                   decoration: AppStyles.infoBoxStyle,
                   child: Column(
                     children: [
                       Row(
                         children: [
                           Text(
                             "Explore Praxis",
                             textAlign: TextAlign.left,
                             style: AppStyles.logisticsStyle,
                           ),
                         ],
                       ),
                       const SizedBox(height: 20),
                       Row(
                         children: [
                           Icon(Icons.location_pin, color: Colors.white),
                           Text(
                             "The Greene Turtle (in-person only)",
                             style: AppStyles.logisticsStyle,
                           ),
                         ],
                       ),
                       const SizedBox(height: 20),
                       Row(
                         children: [
                           Icon(Icons.calendar_month, color: Colors.white),
                           Text(
                             "01/30/2024 at 8:30pm",
                             style: AppStyles.logisticsStyle,
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(height: 20),
                 Text(
                   "You are currently hunting alone as: ${_teamNameController.text}",
                   style: AppStyles.logisticsStyle,
                 ),
                 const SizedBox(width: 350, child: Divider(thickness: 2)),
                 Container(
                   height: 75,
                   width: 350,
                   padding: const EdgeInsets.all(16),
                   decoration: AppStyles.infoBoxStyle,
                   child: Row(
                     children: [
                       Icon(Icons.person, color: Colors.white),
                       const SizedBox(width: 5),
                       SizedBox(
                         width: 205,
                         child: TextField(
                           controller: _teamNameController,
                           focusNode: _focusNode,
                           decoration: InputDecoration(
                             suffixIcon: Icon(Icons.edit, color: Colors.white),
                             border: UnderlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(color: Colors.white),
                             ),
                             hintText: _isEditing ? null : widget.teamName,
                             labelStyle: const TextStyle(
                                 color: Colors.white, fontSize: 14),
                             filled: true,
                             fillColor: Colors.grey,
                           ),
                           style: const TextStyle(color: Colors.white),
                         ),
                       ),
                       const SizedBox(width: 5),
                       Icon(Icons.lock, color: Colors.white),
                       const SizedBox(width: 5),
                       Text(
                         "(Solo)",
                         style: AppStyles.logisticsStyle,
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(height: 20),
                 const SizedBox(width: 350, child: Divider(thickness: 2)),
                 Container(
                   width: 350,
                   padding: const EdgeInsets.all(16),
                   decoration: AppStyles.infoBoxStyle,
                   child: const Text(
                     "There are 3 teams and one solo team currently hunting. Select \"Start Hunt\" when you are ready to begin.",
                     style: TextStyle(
                         fontSize: 20,
                         color: Colors.white,
                         fontFamily: 'InriaSerif'),
                   ),
                 ),
                 const SizedBox(height: 50),
                 Container(
                   height: 50,
                   width: 175,
                   decoration: AppStyles.confirmButtonStyle,
                   child: ElevatedButton(
                     onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => const StartHuntView()),
                       );
                     },
                     style: AppStyles.elevatedButtonStyle,
                     child: const Text('Start Hunt',
                         style: TextStyle(fontWeight: FontWeight.bold)),
                   ),
                 ),
                 const SizedBox(height: 50),
                 Container(
                   height: 50,
                   width: 175,
                   decoration: AppStyles.cancelButtonStyle,
                   child: ElevatedButton(
                     onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => const StartHuntView()),
                       );
                     },
                     style: AppStyles.elevatedButtonStyle,
                     child: const Text('Delete Team',
                         style: TextStyle(fontWeight: FontWeight.bold)),
                   ),
                 ),
               ],
             ),
           ),
         ),
       ),
     ),
   );
 }
}



