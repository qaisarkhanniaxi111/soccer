import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soccer_life/modals/constants.dart';
import 'package:soccer_life/modals/global_widgets.dart';

class GameStatistics extends StatelessWidget {
  GameStatistics({super.key, this.matchName, this.matchImage, this.matchFee, this.date, this.addedBy});

  final matchName;
  final matchImage;
  final matchFee;
  final date;
  final addedBy;

  final firestore = FirebaseFirestore.instance;



   void deleteMatch()async{
     print('Deleting Match');
     try{
       addData();
       await firestore.collection('Matches').doc(matchName).delete();
       Fluttertoast.showToast(msg: 'Stats Updated Successfully');
       Get.back();
     }on FirebaseException catch (e){
       print(e);
       Fluttertoast.showToast(msg: 'Please Check Your Internet Connection');
     }
   }
   void addData()async{
     await firestore.collection('Completed Games').doc(matchName).set({
       'Match Name': matchName,
       'Match Image': matchImage,
       'Date': date,
       'Match Fee': matchFee,
       'Added By': addedBy
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
          padding: EdgeInsets.only(left: 18, right: 18,bottom: 15),
          child: CustomButton(
              buttonText: 'Submit',
              textColor: Colors.white,
              buttonColor: kGreenColor,
              outlineColor: Colors.transparent,
              onPressed: () {
                AlertDialog alert = AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: kBorderRadius
                  ),
                  title: Text('Update Statistics',style: TextStyle(color: Colors.black),),
                  content: Text(
                      'After Updating Stats, The Match Will Be Permanently Removed!'),
                  actions: [
                    CustomButton(
                        buttonText: 'Review',
                        textColor: kGreenColor,
                        buttonColor: Colors.white,
                        outlineColor: kGreenColor,
                        onPressed: () => Get.back()),
                    SizedBox(height: 10),
                    CustomButton(
                        buttonText: 'Update',
                        textColor: Colors.white,
                        buttonColor: kGreenColor,
                        outlineColor: Colors.transparent,
                        onPressed: (){
                          Get.back();
                          deleteMatch();
                        }),
                  ],
                );
                showDialog(context: context, builder: (BuildContext context){
                  return alert;
                });
              })),
      appBar: AppBar(
          bottom: PreferredSize(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text('$matchName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade500),
                        textAlign: TextAlign.center),
                  ),
                  Divider(endIndent: 16, indent: 16, thickness: 2)
                ],
              ),
              preferredSize: Size.fromHeight(20)),
          title: Text('Match Statistics')),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, top: 10, bottom: 20),
        child: StreamBuilder(
            stream: firestore.collection('Matches').doc(matchName).collection('Players').snapshots(),
            builder: (context, snapshot) {
              List<PlayerStatisticsCard> statistics = [];
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(child: CircularProgressIndicator());
                } else {
                  dynamic data = snapshot.data?.docs;
                  for (var dataOfSnapshots in data) {
                    statistics.add(PlayerStatisticsCard(
                      playerName: dataOfSnapshots.data()['Player Name'],
                      playerImage: dataOfSnapshots.data()['Player Photo'],
                      email: dataOfSnapshots.data()['Email'],
                      goals: dataOfSnapshots.data()['Goals'],
                      assists: dataOfSnapshots.data()['Assist'],
                      matchName: matchName,
                    ));
                  }
                }
              } else {
                Center(child: CircularProgressIndicator());
              }
              return ListView(
                  physics: BouncingScrollPhysics(), children: statistics);
            }),
      ),
    );
  }
}

class PlayerStatisticsCard extends StatelessWidget {
  final String playerName;
  final String playerImage;
  final String email;
  final String matchName;
  int goals;
  int assists;

  PlayerStatisticsCard({
    super.key,
    required this.playerName,
    required this.playerImage,
    required this.goals,
    required this.assists,
    required this.email,
    required this.matchName,
  });

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
                radius: 35, backgroundImage: NetworkImage('$playerImage')),
            Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Text('$playerName',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis))),
                SizedBox(height: MediaQuery.sizeOf(context).height / 55),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Goals'),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: MediaQuery.sizeOf(context).height / 25,
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (goals != 0) goals--;

                                    firestore
                                        .collection('Matches')
                                        .doc(matchName)
                                        .collection('Players')
                                        .doc(email)
                                        .update({'Goals': goals});

                                    firestore
                                        .collection('Users')
                                        .doc(email)
                                        .collection('Games')
                                        .doc(matchName)
                                        .update({'Goals': goals});
                                  },
                                  child:
                                      Icon(FontAwesomeIcons.minus, size: 10)),
                              Text('$goals'),
                              InkWell(
                                onTap: () {
                                  print('Goals1');

                                  goals++;
                                  print(goals);
                                  firestore
                                      .collection('Matches')
                                      .doc(matchName)
                                      .collection('Players')
                                      .doc(email)
                                      .update({
                                    'Goals': goals,
                                  });
                                  firestore
                                      .collection('Users')
                                      .doc(email)
                                      .collection('Games')
                                      .doc(matchName)
                                      .update({'Goals': goals});
                                },
                                child: Icon(FontAwesomeIcons.plus, size: 10),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width / 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Assists'),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: MediaQuery.sizeOf(context).height / 25,
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (assists != 0) assists--;
                                  firestore
                                      .collection('Matches')
                                      .doc(matchName)
                                      .collection('Players')
                                      .doc(email)
                                      .update({'Assist': assists});
                                  firestore
                                      .collection('Users')
                                      .doc(email)
                                      .collection('Games')
                                      .doc(matchName)
                                      .update({'Assist': assists});
                                },
                                child: Icon(FontAwesomeIcons.minus, size: 10),
                              ),
                              Text('$assists'),
                              InkWell(
                                onTap: () {
                                  assists++;
                                  firestore
                                      .collection('Matches')
                                      .doc(matchName)
                                      .collection('Players')
                                      .doc(email)
                                      .update({'Assist': assists});
                                  firestore
                                      .collection('Users')
                                      .doc(email)
                                      .collection('Games')
                                      .doc(matchName)
                                      .update({'Assist': assists});
                                },
                                child: Icon(FontAwesomeIcons.plus, size: 10),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Divider(thickness: 1.5),
      ],
    );
  }
}
