import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soccer_life/Routes/Game%20Statistics/view/game_statistics.dart';
import 'package:soccer_life/Routes/Join%20Game/view/join_game.dart';
import 'package:soccer_life/Routes/Message%20Screen/view/message_screen.dart';
import 'package:soccer_life/Routes/Profile/view/profile.dart';
import 'package:soccer_life/modals/constants.dart';

import '../../../modals/global_widgets.dart';
import '../../Chat Screen/view/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double lat, double lon) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}

class GameDetails extends StatefulWidget {
  static String? joinGameText;

  GameDetails({
    super.key,
    this.matchImage,
    this.matchName,
    this.startTime,
    this.endTime,
    this.date,
    this.matchFee,
    this.matchDuration,
    this.matchDescription,
    this.players,
    this.matchHostName,
    this.matchHostEmail,
    this.matchHostPhoto,
    this.mapImage,
    this.matchLocation,
    this.matchCoordinates,
    this.dateStamp = 999999999999999999,
  });

  final String? matchImage;
  final String? mapImage;
  final String? matchName;
  final String? matchLocation;
  final GeoPoint? matchCoordinates;
  final String? startTime;
  final String? endTime;
  final String? date;
  final int dateStamp;
  final String? matchFee;
  final String? matchDuration;
  final String? matchDescription;
  final String? players;
  final String? matchHostName;
  final String? matchHostEmail;
  final String? matchHostPhoto;

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  String? totalPlayers;

  String? playerName;

  String? playerPhoto;

  String? profileName;

  String? profilePhoto;

  // Firebase Instance
  final firestore = FirebaseFirestore.instance;

  //Controller
  TextEditingController messageController = TextEditingController();

  Future<void> getUserData() async {
    await firestore
        .collection('Users')
        .where('Email', isEqualTo: Profile.profileEmail)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        profileName = doc['Name'];
        profilePhoto = doc['PhotoURL'];
      });
    });
  }

  void addGroupMessage() async {
    print('Firebase Begin');
    await firestore
        .collection('Matches')
        .doc(widget.matchName)
        .collection('Match Chat')
        .add({
      'Email': Profile.profileEmail,
      'Sent By': Profile.profileName,
      'Message': messageController.text.trim(),
      'Time Stamp': FieldValue.serverTimestamp()
    });
    messageController.clear();
  }

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String? currentUserName;

  String? currentUserEmail;

  String? roomId;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Details')),
      body: Form(
        key: globalKey,
        child: ListView(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.6,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage('${widget.matchImage}')))),
            Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${widget.matchName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: MediaQuery.of(context).size.height / 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 30,
                          ),
                          Text('${widget.startTime} - ${widget.endTime}   '),
                          Text('${widget.date}')
                        ],
                      ),
                      Row(
                        children: [
                          Text('\$${widget.matchFee}.00',
                              style:
                                  TextStyle(fontSize: 20, color: kGreenColor)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.timer_outlined, size: 30),
                          Text('${widget.matchDuration}')
                        ],
                      ),
                      Visibility(
                        visible: widget.dateStamp <
                                DateTime.now().millisecondsSinceEpoch
                            ? true
                            : false,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red)),
                          child: Text('EXPIRED',
                              style: TextStyle(
                                  color: Colors.red, letterSpacing: 2)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  //TODO Set Proper Organizer Button
                  TextButton(
                    child: Text(
                        'Want to become a Soccer Life Host? Click here:shorturl.at/ufxyz',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade500)),
                    onPressed: () {
                      if (Profile.profileEmail != 'soccerlifea37@gmail.com') {
                        //TODO Show Proper Alert Dialog Like Settings
                        AlertDialog alert = AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: kBorderRadius),
                          title: Text('Request Admin',
                              style: TextStyle(color: Colors.black)),
                          content: Text(
                              'Do You Want To Send Request To Admin To Become Organizer?'),
                          actions: [
                            CustomButton(
                                buttonText: 'Cancel',
                                textColor: kGreenColor,
                                buttonColor: Colors.white,
                                outlineColor: kGreenColor,
                                onPressed: () => Get.back()),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 50),
                            CustomButton(
                                buttonText: 'Continue',
                                textColor: Colors.white,
                                buttonColor: kGreenColor,
                                outlineColor: Colors.transparent,
                                onPressed: () => {
                                      Get.back(),
                                      Fluttertoast.showToast(
                                          msg: 'Request Sent')
                                    }),
                          ],
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            });
                      } else {
                        Get.toNamed('/BecomeOrganizer');
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  //TODO Sometimes Organizer Is Not Added AS Players Need To Add Separate Data Addings
                  Container(
                    child: widget.dateStamp <
                            DateTime.now().millisecondsSinceEpoch
                        ? CustomButton(
                            buttonText: 'Match Expired',
                            textColor: Colors.red,
                            buttonColor: Colors.white,
                            outlineColor: Colors.red,
                            onPressed: () => Fluttertoast.showToast(
                                msg: 'Match Has Expired'))
                        : StreamBuilder<DocumentSnapshot>(
                            stream: firestore
                                .collection('Matches')
                                .doc(widget.matchName)
                                .collection('Players')
                                .doc(Profile.profileEmail)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  if (totalPlayers == widget.players) {
                                    return CustomButton(
                                        buttonText: 'Match Full',
                                        textColor: kGreenColor,
                                        buttonColor: Colors.white,
                                        outlineColor: kGreenColor,
                                        onPressed: () => Fluttertoast.showToast(
                                            msg:
                                            'Match Is Full!'));
                                  }
                                  else if (!snapshot.data!.exists) {
                                    //if Player is not part of the game so show join now button
                                    return CustomButton(
                                        buttonText: 'Join Game',
                                        textColor: Colors.white,
                                        buttonColor: kGreenColor,
                                        outlineColor: Colors.transparent,
                                        onPressed: () async {
                                          if (GameDetails.joinGameText ==
                                              'Join Game') {
                                            await getUserData();
                                            Get.to(() => JoinGame(
                                              // matchName: widget.matchName,
                                              // matchFee: widget.matchFee,
                                              // matchImage: widget.matchImage,
                                              // time: widget.startTime,
                                              // date: widget.date,
                                              // profileName: profileName,
                                              // profilePhoto: profilePhoto,
                                            ));
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                'You Are Already In The Game');
                                          }
                                          // checkPlayers();
                                        });

                                  } else {
                                    return CustomButton(
                                        buttonText: 'Joined',
                                        textColor: kGreenColor,
                                        buttonColor: Colors.white,
                                        outlineColor: kGreenColor,
                                        onPressed: () => Fluttertoast.showToast(
                                            msg:
                                                'You Are Already In The Game!'));
                                  }
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                  ),
                  Divider(
                    thickness: 2,
                    height: 25,
                  ),
                  TextButton(
                    child: Text(
                      'Share Game',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kGreenColor),
                    ),
                    onPressed: () async {
                      await Share.share(
                          'Soccer Life Is An Amazing App Promoting And Conducting Soccer Around The World');
                    },
                  ),
                  Divider(thickness: 2, height: 15),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Who\'s Playing:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14))),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('Matches')
                            .doc(widget.matchName)
                            .collection('Players')
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<PlayerCard> playersList = [];
                          if (snapshot.hasData) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ));
                            } else {
                              int index = 0;
                              print('object');

                              totalPlayers = snapshot.data?.size.toString();
                              dynamic data = snapshot.data?.docs;
                              for (var dataOfSnapshots in data) {
                                print(dataOfSnapshots.data()['Player Name']);
                                //TODO Player Image Should Change When Ever Someone Changes Their Photo
                                index++;
                                playerName =
                                    dataOfSnapshots.data()['Player Name'];
                                playerPhoto =
                                    dataOfSnapshots.data()['Player Photo'];

                                playersList.add(PlayerCard(
                                  playerName: playerName!,
                                  playerImage: playerPhoto!,
                                  playerCount: index,
                                ));
                              }
                            }
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ));
                          }
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      '$totalPlayers/${widget.players} Players',
                                      style: TextStyle(
                                          color: Colors.grey.shade500)),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GridView.count(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                crossAxisCount: 2,
                                children: playersList,
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Where You Will Play:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      MapUtils.openMap(widget.matchCoordinates!.latitude,
                          widget.matchCoordinates!.longitude);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.6,
                      decoration: BoxDecoration(
                        borderRadius: kBorderRadius,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage('${widget.mapImage}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${widget.matchLocation}'),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(height: 20),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Your Hosts:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.matchHostName}',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height / 3.0,
                    decoration: BoxDecoration(
                        borderRadius: kBorderRadius,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('images/HostPic.jpg'))),
                  ),
                  SizedBox(height: 10),
                  Text('${widget.matchDescription}'),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      //TODO implement In Person Chat.
                      print('Contact Host');
                      if (Profile.profileEmail != widget.matchHostEmail) {
                        currentUserName = Profile.profileName;
                        currentUserEmail = Profile.profileEmail;
                        roomId =
                            chatRoomId(currentUserName!, widget.matchHostName!);

                        Get.to(() => MessageScreen(
                              matchHostName: widget.matchHostName,
                              matchHostEmail: widget.matchHostEmail,
                              matchHostPhoto: widget.matchHostPhoto,
                              chatRoom: roomId,
                              chatterEmail: widget.matchHostEmail,
                            ));
                      } else {
                        Fluttertoast.showToast(
                            msg: 'You Cannot Send Message To Your Own Self!');
                      }
                    },
                    child: Text(
                      'Contact Host',
                      style: TextStyle(
                          color: kGreenColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Messages
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chat With Players',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: StreamBuilder(
                          stream: firestore
                              .collection('Matches')
                              .doc(widget.matchName)
                              .collection('Match Chat')
                              .orderBy('Time Stamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<MessageBubble> messageBubbles = [];
                            if (snapshot.hasData) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                    'Be The First One To Send Message!');
                              } else {
                                dynamic data = snapshot.data?.docs;
                                for (var dataOfSnapshots in data) {
                                  messageBubbles.add(MessageBubble(
                                    sentBy: dataOfSnapshots.data()['Sent By'],
                                    message: dataOfSnapshots.data()['Message'],
                                    email: dataOfSnapshots.data()['Email'],
                                  ));
                                }
                              }
                            } else {
                              return Text('Be The First One To Send Message!');
                            }
                            return ListView(
                              reverse: true,
                              children: messageBubbles,
                            );
                          })),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: CustomTextField(
                              hinText: 'Type a Message!',
                              controller: messageController)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2.5,
                            backgroundColor: kGreenColor,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.transparent, width: 1.5),
                                borderRadius: kBorderRadius)),
                        onPressed: () {
                          if (globalKey.currentState!.validate()) {
                            addGroupMessage();
                          }
                        },
                        child: Text('Send'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How It Works:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.only(right: 0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 15,
                          child: Image.asset(
                            'images/Meter.png',
                          ),
                        ),
                        title: Text(
                          'You Show Up In The Field On Time!',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.only(right: 0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 15,
                          child: Image.asset(
                            'images/Meter.png',
                          ),
                        ),
                        title: Text(
                          'Your host will split you into teams!',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.only(right: 0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 15,
                          child: Image.asset(
                            'images/Meter.png',
                          ),
                        ),
                        title: Text(
                          'Everyone plays goalkeeper once.!',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.only(right: 0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 15,
                          child: Image.asset(
                            'images/Meter.png',
                          ),
                        ),
                        title: Text(
                          'Teams ill be changed if it’s uneven!',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Why Choose Soccer Life:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Soccer Life is your ultimate companion for an unparalleled soccer experience in our vibrant city. We've designed our app with a singular focus – to enhance your passion for the beautiful game. With Soccer Life, you gain access to a seamless platform that organizes, schedules, and elevates your soccer matches. Whether you're a seasoned player or just kicking off your soccer journey, our app offers an unrivaled combination of convenience and community. Join us to forge new connections, challenge your skills, and revel in the thrill of the game. Soccer Life isn't just an app; it's your gateway to a richer, more exciting soccer life in our city."),
                      SizedBox(height: 10),
                      Text(
                        '+Read More',
                        style: TextStyle(color: kGreenColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Things To Note Before Joining',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'To prepare for a soccer match, focus on physical readiness, proper attire, field and weather conditions, understanding the game\'s rules, and communicating with your teammates. Respect match officials, prioritize safety and sportsmanship, stay hydrated, be aware of substitution rules, and perform a warm-up. Mentally prepare and show respect for opponents while playing with integrity. After the game, display etiquette, be prepared for injuries, and follow COVID-19 guidelines if necessary. Most importantly, enjoy the game and have fun.'),
                      SizedBox(height: 10),
                      Text(
                        '+Read More',
                        style: TextStyle(color: kGreenColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    super.key,
    this.sentBy,
    required this.message,
    this.email,
  });

  final String? sentBy;
  final String message;
  final String? email;

  final receiverDecoration = BoxDecoration(
    color: Color(0XFFFFE1CD),
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(25),
      bottomRight: Radius.circular(20),
      bottomLeft: Radius.circular(10),
    ),
  );
  final SenderDecoration = BoxDecoration(
    color: Color(0XFFC9F5B5),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      bottomRight: Radius.circular(10),
      bottomLeft: Radius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: email == Profile.profileEmail
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: email == Profile.profileEmail
            ? SenderDecoration
            : receiverDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$sentBy',
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(color: kNumberColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '$message',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  PlayerCard({
    super.key,
    required this.playerCount,
    required this.playerName,
    required this.playerImage,
  });

  final int playerCount;
  final String playerName;
  final String playerImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(alignment: Alignment.centerLeft, child: Text('$playerCount)')),
          CircleAvatar(
            backgroundImage: NetworkImage('$playerImage'),
            radius: MediaQuery.of(context).size.height / 20,
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                  child: Text(
                '$playerName',
                overflow: TextOverflow.ellipsis,
              )))
        ],
      ),
    );
  }
}
