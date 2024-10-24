import 'package:flutter/material.dart';
import 'package:praxis_afterhours/views/new_screens/hunt_alone_view.dart';
import 'package:praxis_afterhours/styles/app_styles.dart';


class HuntAloneTeamNameView extends StatefulWidget {
  final String huntName;
  final String venue;
  final String huntDate;
  const HuntAloneTeamNameView({super.key, required this.huntName, required this.venue, required this.huntDate});


 @override
 _HuntAloneViewState createState() => _HuntAloneViewState();
}


class _HuntAloneViewState extends State<HuntAloneTeamNameView> {
 final TextEditingController _teamNameController = TextEditingController();
 final FocusNode _focusNode = FocusNode();
 bool _isFocused = false;


 @override
 void initState() {
   super.initState();
   _focusNode.addListener(() {
     setState(() {
       _isFocused = _focusNode.hasFocus;
     });
   });
 }


 @override
 void dispose() {
   _focusNode.dispose();
   _teamNameController.dispose();
   super.dispose();
 }
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     home: Scaffold(
       appBar: AppStyles.appBarStyle("Hunt Alone", context),
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
                             widget.huntName,
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
                             widget.venue,
                             style: AppStyles.logisticsStyle,
                           ),
                         ],
                       ),
                       const SizedBox(height: 20),
                       Row(
                         children: [
                           Icon(Icons.calendar_month, color: Colors.white),
                           Text(
                             widget.huntDate,
                             style: AppStyles.logisticsStyle,
                           ),
                         ],
                       ),
                     ],
                   )),
               const SizedBox(height: 10),
               const SizedBox(
                 width: 350,
                 child: Divider(
                   thickness: 2,
                   color: Colors.white,
                 ),
               ),
               const SizedBox(height: 10),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 child: Text(
                   'You have chosen to hunt alone, please enter your team name:',
                   style: AppStyles.logisticsStyle,
                   textAlign: TextAlign.left,
                 ),
               ),
               const SizedBox(height: 10),
               Container(
                 width: 250,
                 child: TextField(
                   controller: _teamNameController,
                   focusNode: _focusNode,
                   style: const TextStyle(color: Colors.grey),
                   textAlign: TextAlign.center,
                   decoration: InputDecoration(
                     filled: true,
                     fillColor: Colors.white,
                     hintText: _isFocused ? null : 'Enter your team name here',
                     hintStyle: const TextStyle(color: Colors.grey),
                     border: const OutlineInputBorder(
                       borderRadius: BorderRadius.all(Radius.circular(12)),
                     ),
                     enabledBorder: const OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.transparent),
                       borderRadius: BorderRadius.all(Radius.circular(12)),
                     ),
                     focusedBorder: const OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.green),
                       borderRadius: BorderRadius.all(Radius.circular(12)),
                     ),
                   ),
                 ),
               ),
               const SizedBox(height: 50),
               SizedBox(
                 width: 200,
                 height: 60,
                 child: Stack(
                   children: [
                     Container(
                       decoration: AppStyles.confirmButtonStyle,
                     ),
                     ElevatedButton(
                       style: AppStyles.elevatedButtonStyle,
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => HuntAloneView(teamName: _teamNameController.text, huntName: widget.huntName, venue: widget.venue, huntDate: widget.huntDate),  // Pass the teamName
                           ),
                         );
                       },
                       child: const Center(
                         child: Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       ),
     ),
   );
 }
}

