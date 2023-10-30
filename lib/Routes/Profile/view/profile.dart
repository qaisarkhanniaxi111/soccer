import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soccer_life/Routes/Game%20Statistics/view/game_statistics.dart';
import 'package:soccer_life/Routes/Sign%20In/view/sign_in.dart';
import 'package:soccer_life/modals/constants.dart';
import '../../../modals/global_widgets.dart';
import '../../Settings/view/settings.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  static String? profileName;
  static String? profilePhoto = '';
  static String? profileEmail;

  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final firestore = FirebaseFirestore.instance;

  Future<void> setStatus(String status) async {
    await firestore
        .collection('Users')
        .doc(Profile.profileEmail)
        .update({'Status': status});
  }

  //User Profile Data

  //Variable To Store Image
  XFile? matchImage;

  //Pick Image From Mobile Storage
  void getImage() async {
    ImagePicker imagePicker = ImagePicker();

    matchImage = await imagePicker.pickImage(source: ImageSource.gallery);

    Profile.profilePhoto = matchImage!.path;

    //Image Variables
    String uniqueFileName = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child('images');
    final imageToUpload = imagesRef.child(uniqueFileName);

    //Uploading Image To Firebase
    try {
      Fluttertoast.showToast(msg: 'Updating Profile Please Wait!');
      await imageToUpload.putFile(File(matchImage!.path));
      Profile.profilePhoto = await imageToUpload.getDownloadURL();
      if (matchImage != null)
        await firestore
            .collection('Users')
            .doc(Profile.profileEmail)
            .update({'PhotoURL': Profile.profilePhoto});
      Fluttertoast.showToast(msg: 'Profile Photo Updated!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Please Check Your Internet And Try Again!.');
    }
  }

  List<String> statistics = [];

  getProfileStatistics() async {
    await firestore
        .collection('Matches')
        .get()
        .then((QuerySnapshot snapshot) =>
    {
      snapshot.docs.forEach((doc) {
        statistics.add(doc.id);
      })
    });
  }

  addData() async {
    print('Organizer Request');

    try {
      await firestore
          .collection('Organizer Requests')
          .doc('${Profile.profileEmail}' + '${Settings2.cityName}')
          .set({
        'Player Name': Profile.profileName,
        'Player Photo': Profile.profilePhoto,
        'Email': Profile.profileEmail,
        'Status': 'Pending',
        'City': Settings2.cityName,
        'Time Stamp': FieldValue.serverTimestamp()
      });
      Fluttertoast.showToast(msg: 'Request Sent');
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.power_settings_new_outlined, size: 30),
              color: Colors.red,
              onPressed: () async {
                await GoogleSignIn().signOut();
                // await FacebookAuth.instance.logOut();
                await FirebaseAuth.instance.signOut();
                setStatus('Offline');

                Get.offNamed('/SignIn');
              },
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
          toolbarHeight: 80),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding:
          const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 42),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.27,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('images/ProfileGreen.png')),
                      ),
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.6,
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: firestore
                                    .collection('Users')
                                    .doc(Profile.profileEmail)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Player Name',
                                          style:
                                          TextStyle(color: Colors.black));
                                    } else {
                                      Profile.profileName =
                                      snapshot.data!['Name'];
                                      Fluttertoast.showToast(
                                          msg: '${Profile.profileName}');
                                      return Text(
                                        '${snapshot.data!['Name']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  } else
                                    return Text('Player Name',
                                        style: TextStyle(color: Colors.black));
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: firestore
                                    .collection('Users')
                                    .doc(Profile.profileEmail)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text(
                                        '${Settings2.cityName} Soccer Life',
                                        style: TextStyle(color: kGreenColor),
                                      );
                                    } else {
                                      return Text(
                                        '${Settings2.cityName} Soccer Life',
                                        style: TextStyle(color: kGreenColor),
                                      );
                                    }
                                  } else {
                                    return Text(
                                      '${Settings2.cityName} Soccer Life',
                                      style: TextStyle(color: kGreenColor),
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder(
                                  stream: firestore
                                      .collection('Users')
                                      .doc(Profile.profileEmail)
                                      .collection('Games')
                                      .snapshots(),
                                  builder: (context, snapshot) {

                                    String? games;
                                    num goals = 0;
                                    num assists = 0;

                                    if (snapshot.hasData) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {

                                        return Text('0');

                                      } else {
                                        print(snapshot.data?.docs.length);
                                        games = snapshot.data?.docs.length
                                            .toString();

                                        dynamic data = snapshot.data?.docs;
                                          for (var dataOfSnapshots in data) {
                                            print('Data');

                                            goals += dataOfSnapshots.data()['Goals'];

                                            assists += dataOfSnapshots.data()['Assist'];
                                          }
                                      }
                                    } else {
                                      return Text('0');
                                    }
                                    return Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CardText(
                                            text: '$games', text2: 'Games'),
                                        CardText(
                                            text: '$goals', text2: 'Goals'),
                                        CardText(
                                            text: '$assists', text2: 'Assists'),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ////Profile Image
                    Align(
                      heightFactor: 0.1,
                      child: Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Colors.grey.shade50, width: 4)),
                        child: GestureDetector(
                          onTap: () {
                            print('Object');
                            getImage();
                          },
                          child: Container(
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: firestore
                                  .collection('Users')
                                  .doc(Profile.profileEmail)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('Images');
                                  } else {
                                    if (snapshot.data!['PhotoURL'] != '') {
                                      Profile.profilePhoto =
                                      snapshot.data!['PhotoURL'];
                                      Profile.profileName =
                                      snapshot.data!['Name'];
                                      print('empty1');
                                      return CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${Profile.profilePhoto}'));
                                    } else {
                                      print('Not empty');
                                      return CircleAvatar(
                                          backgroundImage: AssetImage(
                                            'images/messi.jpeg',
                                          ));
                                    }
                                  }
                                } else {
                                  print('No Data');
                                  return Text('Images');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height / 50),
              Text(
                'Become Organizer And Earn Upto 20\$ Reward For Each Game You Organize!',
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: Text(
                  'Become Organizer',
                  style: TextStyle(
                      fontSize: 18,
                      color: kGreenColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (Profile.profileEmail != 'soccerlifea37@gmail.com') {
                    print('True');
                    AlertDialog alert = AlertDialog(
                      backgroundColor: Colors.white,
                      shape:
                      RoundedRectangleBorder(borderRadius: kBorderRadius),
                      title: Text('Request Admin',style: TextStyle(color: Colors.black),),
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
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 50),
                        CustomButton(
                            buttonText: 'Continue',
                            textColor: Colors.white,
                            buttonColor: kGreenColor,
                            outlineColor: Colors.transparent,
                            onPressed: () async {
                              Get.back();
                              await firestore
                                  .collection('Organizer Requests')
                                  .where('Email',
                                  isEqualTo: Profile.profileEmail)
                                  .where('City', isEqualTo: Settings2.cityName)
                                  .get()
                                  .then((value) {
                                if (value.docs.length != 0) {
                                  AlertDialog alert = AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: kBorderRadius),
                                    title: Text('Warning',style: TextStyle(color: Colors.black)),
                                    content: Text(
                                        'You Can Not Send Multiple Organizer Requests For Same City Please Change City And Try Again.'),
                                    actions: [
                                      CustomButton(
                                          buttonText: 'OK',
                                          textColor: kGreenColor,
                                          buttonColor: Colors.white,
                                          outlineColor: kGreenColor,
                                          onPressed: () => Get.back()),
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      });
                                } else {
                                  addData();
                                }
                              });
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
              Divider(
                  indent: 100,
                  endIndent: 100,
                  color: kGreenColor,
                  thickness: 2,
                  height: 0),
              SizedBox(height: MediaQuery
                  .sizeOf(context)
                  .height / 35),
              Container(
                child: StreamBuilder(
                    stream: firestore
                        .collection('Matches')
                        .where('Email', isEqualTo: Profile.profileEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<SportsCard> organizedMatches = [];

                      dynamic data = snapshot.data?.docs;
                      for (var dataOfSnapshots in data) {
                        if (dataOfSnapshots.data()['Date'] !=
                            DateFormat.yMd().format(DateTime.now()) &&
                            dataOfSnapshots.data()['Time Stamp2'] < DateTime.now().millisecondsSinceEpoch)
                          organizedMatches.add(
                              SportsCard(
                                  matchImage: dataOfSnapshots
                                      .data()['Match Image'],
                                  matchName: dataOfSnapshots
                                      .data()['Match Name'],
                                  matchDescription:
                                  dataOfSnapshots.data()['Match Description'],
                                  dateStamp: dataOfSnapshots.data()['Time Stamp2'],
                                  date: dataOfSnapshots.data()['Date'],
                                  totalPLayers: dataOfSnapshots.data()['Total Players'],
                                  players: dataOfSnapshots
                                      .data()['No of Players'],
                                  onTap: () {
                                    Get.to(() =>
                                        GameStatistics(
                                          matchName: dataOfSnapshots.data()['Match Name'],
                                          matchImage: dataOfSnapshots.data()['Match Image'],
                                          matchFee: dataOfSnapshots.data()['Match Fee'],
                                          date: dataOfSnapshots.data()['Date'],
                                          addedBy: dataOfSnapshots.data()['Added By'],
                                        ));
                                  }));
                      }
                      return Column(
                        children: organizedMatches,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final String text0;
  final String number0;
  final String text1;
  final String number1;
  final String text2;
  final String number2;
  final String text3;
  final String number3;

  const ProfileDetails({
    super.key,
    required this.text0,
    required this.number0,
    required this.text1,
    required this.number1,
    required this.text2,
    required this.number2,
    required this.text3,
    required this.number3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GameDetailText(text: number0, text2: text0),
        GameDetailText(text: number1, text2: text1),
        GameDetailText(text: number2, text2: text2),
        GameDetailText(text: number3, text2: text3)
      ],
    );
  }
}

class CardText extends StatelessWidget {
  final String text;
  final String text2;

  const CardText({
    super.key,
    required this.text,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$text',
          style: TextStyle(
              fontSize: 13, color: kNumberColor, fontWeight: FontWeight.bold),
        ),
        Text('$text2', style: TextStyle(fontSize: 11, color: kTextColor))
      ],
    );
  }
}

class GameDetailText extends StatelessWidget {
  final String text;
  final String text2;

  const GameDetailText({
    super.key,
    required this.text,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$text',
          style: TextStyle(
              fontSize: 13, color: kNumberColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: MediaQuery
            .of(context)
            .size
            .width * 0.2),
        Text('$text2',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500))
      ],
    );
  }
}
