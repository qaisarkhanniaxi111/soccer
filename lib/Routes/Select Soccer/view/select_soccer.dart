import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:soccer_life/Routes/Game%20Details/view/game_details.dart';
import 'package:soccer_life/Routes/Profile/view/profile.dart';
import 'package:soccer_life/Routes/Settings/view/settings.dart';
import 'package:soccer_life/modals/global_widgets.dart';

class SelectSoccer extends StatelessWidget {
  SelectSoccer({super.key});

  //Variables For Cities Info
  String? matchName;
  String? matchDescription;
  String? matchImage;
  String? matchLocation;
  GeoPoint? matchCoordinates;
  int dateStamp = 0;
  int totalPlayers = 0;
  String? mapImage;
  String? startTime;
  String? endTime;
  String? players;
  String? date;
  String? matchFee;
  String? addedBy;
  String? playerName;
  String? playerPhoto;

  //Firebase Instance
  final firestore = FirebaseFirestore.instance;

  getPlayersInfo() async {
    print('object');
    await firestore
        .collection('Matches')
        .doc(matchName)
        .collection('Players')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc['Player Name']);
      });
    });
  }

  checkPlayers(String matchName) async {
    await firestore
        .collection('Matches')
        .doc(matchName)
        .collection('Players')
        .where('Email', isEqualTo: Profile.profileEmail)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        return GameDetails.joinGameText = 'Join Game';
      } else {
        return GameDetails.joinGameText = 'Joined';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Soccer'),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 5),
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Matches').snapshots(),
                builder: (context, snapshot) {
                  List<SportsCard> todayMatches = [];
                  List<SportsCard> upcomingMatches = [];
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ));
                    } else {
                      dynamic data = snapshot.data?.docs;
                      for (var dataOfSnapshots in data) {
                        print(dataOfSnapshots.data()['Match Name']);
                        print(dataOfSnapshots.data()['Date']);
                        print(dataOfSnapshots.data()['Start Time']);
                        print(dataOfSnapshots.data()['Match Start Time']);

                        matchName = dataOfSnapshots.data()['Match Name'];
                        matchDescription =
                        dataOfSnapshots.data()['Match Description'];
                        matchImage = dataOfSnapshots.data()['Match Image'];
                        endTime = dataOfSnapshots.data()['Match Start Time'];
                        startTime = dataOfSnapshots.data()['Start Time'];
                        players = dataOfSnapshots.data()['No of Players'];
                        date = dataOfSnapshots.data()['Date'];
                        matchFee = dataOfSnapshots.data()['Match Fee'];
                        addedBy = dataOfSnapshots.data()['Added By'];
                        mapImage = dataOfSnapshots.data()['Map Image'];
                        matchLocation =
                        dataOfSnapshots.data()['Match Location'];
                        matchCoordinates =
                        dataOfSnapshots.data()['Match Coordinates'];
                        dateStamp = dataOfSnapshots.data()['Time Stamp2'];
                        totalPlayers = dataOfSnapshots.data()['Total Players'];

                        //TODO UnCommit This To Show Users Only Matches Which Exist In Their Selected City
                        // if(Settings2.cityName == dataOfSnapshots.data()['City Name'])
                        if (dataOfSnapshots.data()['Date'] ==
                            DateFormat.yMd().format(DateTime.now())) {

                          todayMatches.add(
                              SportsCard(
                                totalPLayers: totalPlayers,
                            matchImage: '$matchImage',
                            matchName: '$matchName',
                            matchDescription: '$matchDescription',
                            date: '$date',
                            players: '$players',
                            onTap: () async {
                              await getPlayersInfo();
                              await checkPlayers(
                                  dataOfSnapshots.data()['Match Name']);

                              Get.to(() => GameDetails(
                                matchName:
                                dataOfSnapshots.data()['Match Name'],
                                matchDescription: dataOfSnapshots
                                    .data()['Match Description'],
                                matchFee: dataOfSnapshots.data()['Match Fee'],
                                startTime: dataOfSnapshots.data()['Start Time'],
                                endTime: dataOfSnapshots.data()['End Time'],
                                players:
                                dataOfSnapshots.data()['No of Players'],
                                matchImage:
                                dataOfSnapshots.data()['Match Image'],
                                matchLocation:
                                dataOfSnapshots.data()['Match Location'],
                                matchCoordinates: dataOfSnapshots
                                    .data()['Match Coordinates'],
                                mapImage: dataOfSnapshots.data()['Map Image'],
                                matchDuration:
                                dataOfSnapshots.data()['Match Duration'],
                                date: dataOfSnapshots.data()['Date'],
                                matchHostName:
                                dataOfSnapshots.data()['Added By'],
                                matchHostEmail:
                                dataOfSnapshots.data()['Email'],
                                matchHostPhoto:
                                dataOfSnapshots.data()['Photo'],
                              )
                              );
                            },
                          )
                          );


                        } else if (dataOfSnapshots.data()['Time Stamp2'] >
                            DateTime.now().millisecondsSinceEpoch) {
                          upcomingMatches.add(SportsCard(
                            totalPLayers: totalPlayers,
                            matchImage: '$matchImage',
                            matchName: '$matchName',
                            matchDescription: '$matchDescription',
                            date: '$date',
                            players: '$players',
                            onTap: () async {
                              print(dataOfSnapshots.data()['Start Time']);
                              print(dataOfSnapshots.data()['End Time']);
                              await getPlayersInfo();
                              await checkPlayers(
                                  dataOfSnapshots.data()['Match Name']);

                              Get.to(() => GameDetails(
                                matchName:
                                dataOfSnapshots.data()['Match Name'],
                                matchDescription: dataOfSnapshots
                                    .data()['Match Description'],
                                matchFee: dataOfSnapshots.data()['Match Fee'],
                                startTime: dataOfSnapshots.data()['Start Time'],
                                endTime: dataOfSnapshots.data()['End Time'],
                                players:
                                dataOfSnapshots.data()['No of Players'],
                                matchImage:
                                dataOfSnapshots.data()['Match Image'],
                                matchLocation:
                                dataOfSnapshots.data()['Match Location'],
                                matchCoordinates: dataOfSnapshots
                                    .data()['Match Coordinates'],
                                mapImage: dataOfSnapshots.data()['Map Image'],
                                matchDuration:
                                dataOfSnapshots.data()['Match Duration'],
                                date: dataOfSnapshots.data()['Date'],
                                matchHostName:
                                dataOfSnapshots.data()['Added By'],
                                matchHostEmail:
                                dataOfSnapshots.data()['Email'],
                                matchHostPhoto:
                                dataOfSnapshots.data()['Photo'],
                              ));
                            },
                          ));
                        }
                      }
                    }
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Hey Player! Choose a pick-up game to play in:',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      Text('Today',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100),
                      Column(children: todayMatches),
                      Text('Upcoming Games',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100),
                      Column(
                        children: upcomingMatches,
                      ),
                    ],
                  );
                }),
          )),
    );
  }
}
