import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:soccer_life/Routes/Become%20Organizer/view/become_organizer.dart';
import 'package:soccer_life/Routes/Chat%20Screen/view/chat_screen.dart';
import 'package:soccer_life/Routes/Profile/view/profile.dart';
import 'package:soccer_life/Routes/View%20Game%20Requests/view/view_game_requests.dart';
import 'package:soccer_life/modals/constants.dart';

import '../../../modals/global_widgets.dart';
import '../../Settings/view/settings.dart';

class GameRequests extends StatelessWidget {
  GameRequests({super.key});

  final firestore = FirebaseFirestore.instance.collection('Organizer Requests');

  //TODO While Updating Statistics The GAme SHould Be Removed From Here As Well
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Divider(
                indent: 16,
                endIndent: 16,
                thickness: 1.5,
              )),
          title: Text(
            'Game Requests',
          )),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, top: 10, bottom: 10),
        child: StreamBuilder(
            stream: firestore.orderBy('Time Stamp2',descending: true).snapshots(),
            builder: (context, snapshot) {

              List<SentRequestCard> sentRequests = [];

              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(child: CircularProgressIndicator());
                } else {
                  dynamic data = snapshot.data?.docs;
                  {
                    for (var dataOfSnapshots in data) {

                      if (dataOfSnapshots.data()['Email'] == Profile.profileEmail) {
                        sentRequests.add(
                            SentRequestCard(
                          matchImage: dataOfSnapshots.data()['Match Image'],
                          matchName: dataOfSnapshots.data()['Match Name'],
                          date: dataOfSnapshots.data()['Date'],
                          matchFee: dataOfSnapshots.data()['Match Fee'],
                          status: dataOfSnapshots.data()['Status'],
                          city: dataOfSnapshots.data()['City Name'],
                          startTime: dataOfSnapshots.data()['Start Time'],
                          endTime: dataOfSnapshots.data()['End Time'],
                          duration: dataOfSnapshots.data()['Match Duration'],
                          mapImage: dataOfSnapshots.data()['Map Image'],
                          mapLocation: dataOfSnapshots.data()['Match Location'],
                          matchCoordinates: dataOfSnapshots.data()['Match Coordinates'],
                          dateStamp: dataOfSnapshots.data()['Time Stamp2'],
                          email: dataOfSnapshots.data()['Email'],
                          addedBy: dataOfSnapshots.data()['Added By'],
                          matchDescription: dataOfSnapshots.data()['Match Description'],
                          noOfPlayers: dataOfSnapshots.data()['No of Players'],
                          totalPlayers: dataOfSnapshots.data()['Total Players'],
                          organizerPhoto: dataOfSnapshots.data()['Photo'],
                        )
                        );
                      } else if (Profile.profileEmail ==
                          'soccerlifea37@gmail.com') {
                        sentRequests.add(
                            SentRequestCard(
                              matchImage: dataOfSnapshots.data()['Match Image'],
                              matchName: dataOfSnapshots.data()['Match Name'],
                              date: dataOfSnapshots.data()['Date'],
                              matchFee: dataOfSnapshots.data()['Match Fee'],
                              status: dataOfSnapshots.data()['Status'],
                              city: dataOfSnapshots.data()['City Name'],
                              startTime: dataOfSnapshots.data()['Start Time'],
                              endTime: dataOfSnapshots.data()['End Time'],
                              duration: dataOfSnapshots.data()['Match Duration'],
                              mapImage: dataOfSnapshots.data()['Map Image'],
                              mapLocation: dataOfSnapshots.data()['Match Location'],
                              matchCoordinates: dataOfSnapshots.data()['Match Coordinates'],
                              dateStamp: dataOfSnapshots.data()['Time Stamp2'],
                              email: dataOfSnapshots.data()['Email'],
                              addedBy: dataOfSnapshots.data()['Added By'],
                              matchDescription: dataOfSnapshots.data()['Match Description'],
                              noOfPlayers: dataOfSnapshots.data()['No of Players'],
                              totalPlayers: dataOfSnapshots.data()['Total Players'],
                              organizerPhoto: dataOfSnapshots.data()['Photo'],
                            )
                        );
                      }
                    }
                  }
                }
              } else {
                Center(child: CircularProgressIndicator());
              }
              return ListView(children: sentRequests);
            }),

        /////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////
        // child: Profile.profileEmail == 'soccerlifea37@gmail.com'
        //     ? StreamBuilder<QuerySnapshot>(
        //         stream: firestore.orderBy('Time Stamp').snapshots(),
        //         builder: (context, snapshot) {
        //           List<RequestCardAdmin> requestsList = [];
        //           if (snapshot.hasData){
        //             if(snapshot.connectionState == ConnectionState.waiting){
        //               return Center(child: CircularProgressIndicator());
        //             }else{
        //               dynamic data = snapshot.data?.docs;
        //               for (var dataOfSnapshots in data) {
        //                 requestsList.add(RequestCardAdmin(
        //                     status: dataOfSnapshots.data()['Status'],
        //                     playerName: dataOfSnapshots.data()['Player Name'],
        //                     playerImage: dataOfSnapshots.data()['Player Photo'],
        //                     cityName: dataOfSnapshots.data()['City'],
        //                     email: dataOfSnapshots.data()['Email']));
        //               }
        //             }
        //           } else {
        //             return Center(child: CircularProgressIndicator());
        //           }
        //           return ListView(
        //             children: requestsList,
        //           );
        //         },
        //       )
        //     : StreamBuilder<QuerySnapshot>(
        //         stream: firestore
        //             .where('Email', isEqualTo: Profile.profileEmail)
        //             .snapshots(),
        //         builder: (context, snapshot) {
        //           List<OrganizerRequestCard> requestsList = [];
        //           if (snapshot.hasData) {
        //             if(snapshot.connectionState == ConnectionState.waiting){
        //               return Text(
        //                 'No Requests Yet.',
        //                 textAlign: TextAlign.right,
        //               );
        //             }else{
        //               firestore.doc().get().then((doc){
        //                 print(doc.data());
        //               });
        //               dynamic data = snapshot.data?.docs;
        //               for (var dataOfsnapshots in data) {
        //
        //                 requestsList.add(OrganizerRequestCard(
        //                     playerImage: dataOfsnapshots.data()['Player Photo'],
        //                     playerName: dataOfsnapshots.data()['Player Name'],
        //                     cityName: dataOfsnapshots.data()['City'],
        //                     status: dataOfsnapshots.data()['Status']
        //                 ));
        //               }
        //             }
        //           } else {
        //             return Text(
        //               'No Requests Yet.',
        //               textAlign: TextAlign.right,
        //             );
        //           }
        //           return ListView(children: requestsList);
        //         }),
      ),
    );
  }
}

// class RequestCardAdmin extends StatelessWidget {
//   RequestCardAdmin({
//     super.key,
//     required this.status,
//     required this.playerName,
//     required this.playerImage,
//     required this.email,
//     required this.cityName,
//   });
//
//   final String status;
//   final String playerName;
//   final String playerImage;
//   final String? email;
//   final String? cityName;
//
//   final firestore = FirebaseFirestore.instance.collection('Organizer Requests');
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 35,
//               backgroundColor: Colors.transparent,
//               backgroundImage: NetworkImage('$playerImage'),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.35,
//                       child: Text('$playerName',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.bold)),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.35,
//                       child: Text('For $cityName',
//                           textAlign: TextAlign.right,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//                 //Approve Decline Buttons
//                 Visibility(
//                   visible: status == 'Pending' ? true : false,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: kGreenColor,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: OtpBorderRadius)),
//                           onPressed: () async {
//                             print('Approved');
//
//                             await firestore
//                                 .doc('$email' + '$cityName')
//                                 .update({'Status': 'Approved'});
//                           },
//                           child: Text(
//                             'Approve',
//                           )),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width / 50,
//                       ),
//                       ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: OtpBorderRadius)),
//                           onPressed: () async {
//                             print('Declined1');
//                             print(email);
//                             print(cityName);
//
//                             await firestore
//                                 .doc('$email' + '$cityName')
//                                 .update({'Status': 'Declined'});
//                           },
//                           child: Text(
//                             'Decline',
//                           )),
//                     ],
//                   ),
//                 ),
//                 //Approved OR Declined Buttons
//                 Visibility(
//                   visible: status != 'Pending' ? true : false,
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               status == 'Approved' ? kGreenColor : Colors.red,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: OtpBorderRadius)),
//                       onPressed: () {
//                         AlertDialog alert = AlertDialog(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: OtpBorderRadius),
//                           title: Text('Request Status',
//                               style: TextStyle(color: Colors.black)),
//                           content: Text('Wanna Change Request Status?'),
//                           actions: [
//                             CustomButton(
//                                 buttonText: 'Approve',
//                                 textColor: kGreenColor,
//                                 buttonColor: Colors.white,
//                                 outlineColor: kGreenColor,
//                                 onPressed: () async {
//                                   await firestore
//                                       .doc('$email' + '$cityName')
//                                       .update({'Status': 'Approved'});
//                                   Get.back();
//                                 }),
//                             SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height / 50),
//                             CustomButton(
//                               buttonText: 'Decline',
//                               textColor: Colors.red,
//                               buttonColor: Colors.white,
//                               outlineColor: Colors.red,
//                               onPressed: () async {
//                                 await firestore
//                                     .doc('$email' + '$cityName')
//                                     .update({'Status': 'Declined'});
//                                 Get.back();
//                               },
//                             ),
//                           ],
//                         );
//                         showDialog(
//                             context: context,
//                             builder: (BuildContext contex) {
//                               return alert;
//                             });
//                       },
//                       child: Text(
//                         status == 'Approved' ? 'Approved' : 'Declined',
//                       )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Divider(
//           height: 40,
//         )
//       ],
//     );
//   }
// }
//
// class OrganizerRequestCard extends StatelessWidget {
//   const OrganizerRequestCard({
//     super.key,
//     required this.playerImage,
//     required this.playerName,
//     required this.status,
//     required this.cityName,
//   });
//
//   final String playerImage;
//   final String playerName;
//   final String status;
//   final String cityName;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         status == 'Approved'
//             ? Get.to(() => BecomeOrganizer(
//                   cityName: cityName,
//                 ))
//             : Fluttertoast.showToast(msg: 'Your Request Is $status');
//       },
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CircleAvatar(
//                 radius: 35,
//                 backgroundColor: Colors.transparent,
//                 backgroundImage: NetworkImage('$playerImage'),
//               ),
//               Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width / 2.3,
//                     child: Text(
//                       '$playerName',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width / 2.3,
//                     child: Text(
//                       status == 'Pending'
//                           ? 'Your Request is Pending for city $cityName.'
//                           : status == 'Approved'
//                               ? 'Request Approved! For $cityName'
//                               : 'Request Declined! For $cityName',
//                       style:
//                           TextStyle(color: Colors.grey.shade500, fontSize: 13),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 alignment: Alignment.center,
//                 width: MediaQuery.of(context).size.width * 0.22,
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                     borderRadius: OtpBorderRadius,
//                     border: Border.all(
//                         color: status == 'Pending'
//                             ? kNumberColor
//                             : status == 'Approved'
//                                 ? kGreenColor
//                                 : Colors.red)),
//                 child: Text(
//                   '$status',
//                   style: TextStyle(
//                       color: status == 'Pending'
//                           ? kNumberColor
//                           : status == 'Approved'
//                               ? kGreenColor
//                               : Colors.red),
//                 ),
//               )
//             ],
//           ),
//           Divider(
//             height: 40,
//           )
//         ],
//       ),
//     );
//   }
// }

class SentRequestCard extends StatelessWidget {
  const SentRequestCard({
    super.key,
    required this.matchImage,
    required this.matchName,
    required this.date,
    required this.matchFee,
    required this.status,
    required this.city,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.mapImage,
    required this.mapLocation,
    required this.matchCoordinates,
    required this.dateStamp,
    required this.email,
    required this.addedBy,
    required this.matchDescription,
    required this.organizerPhoto,
    required this.noOfPlayers,
    required this.totalPlayers,
  });

  final String matchImage;
  final String matchDescription;
  final String organizerPhoto;
  final String matchName;
  final String date;
  final String matchFee;
  final String status;
  final String city;
  final String startTime;
  final String endTime;
  final String duration;
  final String mapImage;
  final String mapLocation;
  final String email;
  final String addedBy;
  final String noOfPlayers;
  final int totalPlayers;
  final GeoPoint matchCoordinates;
  final int dateStamp;

  //TODO What of Match Expires Here
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ViewGameRequests(
            matchImage: matchImage,
            matchDescription: matchDescription,
            matchName: matchName,
            startTime: startTime,
            endTime: endTime,
            date: date,
            matchFee: matchFee,
            duration: duration,
            status: status,
            mapImage: mapImage,
            mapLocation: mapLocation,
            matchCoordinates: matchCoordinates,
            email: email,
            dateStamp: dateStamp,
            cityName: city,
            organizerPhoto: organizerPhoto,
            totalPlayers: totalPlayers,
            noOfPlayers: noOfPlayers,
            addedBy: addedBy,
          )),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        elevation: 1,
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.15,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: kBorderRadius,
              border: Border.all(color: Colors.grey.shade300)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 23.0, top: 10, bottom: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 25),
                  width: MediaQuery.sizeOf(context).width * 0.25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage('$matchImage')),
                      borderRadius: kBorderRadius),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      child: Text(
                        '$matchName',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: 140,
                      child: Text(
                        'Date: $date',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: kNumberColor),
                      ),
                    ),
                    Container(
                      width: 140,
                      child: Text(
                        'City: $city',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: kNumberColor),
                      ),
                    ),
                    Visibility(
                      visible: email == 'soccerlifea37@gmail.com' ? true : true,
                      child: Container(
                        width: 140,
                        child: Text(
                          'Host: $addedBy',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: kNumberColor),
                        ),
                      ),
                    ),
                   Container(
                      width: 140,
                      child: Text(
                        'Status: $status',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: status == 'APPROVED'
                                ? kGreenColor
                                : status == 'PENDING'
                                    ? kNumberColor
                                    : Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
