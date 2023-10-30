import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soccer_life/main.dart';
import 'package:soccer_life/modals/constants.dart';
import '../../../modals/global_widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../Profile/view/profile.dart';

class Settings2 extends StatefulWidget {
  static String cityName = 'City';


  Settings2({super.key});

  @override
  State<Settings2> createState() => _Settings2State();
}

class _Settings2State extends State<Settings2> {
  TextEditingController feedbackController = TextEditingController();

  final firestore = FirebaseFirestore.instance;

  addData() async {
    print('Organizer Request');


    try {
      await firestore.collection('Organizer Requests').doc(
          '${Profile.profileEmail}' + '${Settings2.cityName}').set({
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

  colorMode(){

  }

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Divider(
                indent: 16,
                endIndent: 16,
                thickness: 2,
              )),
          title: Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Game', style: TextStyle(fontSize: 20)),
                  IconButton(
                      icon: Icon(Icons.sunny),
                  onPressed: (){
                        setState(() {});
                        final lightMode = ThemeData.light().copyWith(bottomSheetTheme: BottomSheetThemeData(
                            backgroundColor: Colors.white
                        ), appBarTheme: AppBarTheme(
                            elevation: 0,
                            //TODO Check If The Appbar Back Icon Color Changes?

                            iconTheme: IconThemeData(color: Colors.black),
                            toolbarHeight: 75,
                            centerTitle: true,
                            color: Colors.white,
                            titleTextStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)
                        ), scaffoldBackgroundColor: Colors.white, textTheme: TextTheme(
                          //Normal Text Color
                            bodyMedium: TextStyle(color: Colors.black),
                            // TextField Text Color
                            titleMedium: TextStyle(color: Colors.black)
                        ), iconTheme: IconThemeData(color: Colors.black));
                        final darkMode = ThemeData.dark().copyWith(bottomSheetTheme: BottomSheetThemeData(
                            backgroundColor: Colors.black
                        ),appBarTheme: AppBarTheme(
                            elevation: 0,
                            toolbarHeight: 75,
                            centerTitle: true,
                            color: Colors.black),scaffoldBackgroundColor: Colors.black,textTheme: TextTheme(
                            bodyMedium: TextStyle(color: Colors.white),
                            titleMedium: TextStyle(color: Colors.black)), iconTheme: IconThemeData(color: Colors.white));

                        Get.changeTheme(Get.isDarkMode ? lightMode: darkMode);
                  }),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: kOldGreenColor),
                    color: Color(0XFFC9F5B5), borderRadius: OtpBorderRadius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO Extract Widget
                    //Feedback
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Contact Us',style: TextStyle(color: Colors.black)),
                          Icon(Icons.arrow_forward_ios_outlined, size: 20,color: Colors.black)
                        ],
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                            barrierColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: kPadding,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please Let Us Know Your Quary!',
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    CustomTextField(
                                        maxLines: 2,
                                        contentPadding: EdgeInsets.all(15),
                                        hinText: 'Feedback',
                                        controller: feedbackController),
                                    CustomButton(
                                        buttonText: 'Send Feedback',
                                        textColor: Colors.white,
                                        buttonColor: kGreenColor,
                                        outlineColor: Colors.transparent,
                                        onPressed: () {
                                          Get.back();
                                          Fluttertoast.showToast(
                                              msg: 'Feedback Sent Succefully');
                                          feedbackController.clear();
                                        })
                                  ],
                                ),
                              );
                            });
                      }
                    ),
                    Divider(
                        thickness: 1
                    ),
                    //Share App
                    InkWell(
                      onTap: () async {
                        await Share.share(
                            'Soccer Life Is An Amazing App Promoting And Conducting Soccer Around The World');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Share App',style: TextStyle(color: Colors.black)),
                          Icon(
                            Icons.arrow_forward_ios_outlined,color: Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    //Organizer Request
                    InkWell(
                      onTap: () {
                        Get.toNamed('/GameRequests');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Game Requests',style: TextStyle(color: Colors.black)),
                          Icon(
                            Icons.arrow_forward_ios_outlined,color: Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    //Completed Games
                    Visibility(
                      visible: Profile.profileEmail == 'soccerlifea37@gmail.com'
                          ? true
                          : false,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/CompletedGames');
                        },
                        child: Column(
                          children: [
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Completed Games',style: TextStyle(color: Colors.black)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(
                'My Account',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: kGreenColor
                    ),
                    color: Color(0XFFC9F5B5), borderRadius: OtpBorderRadius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Get.toNamed('/SelectCity'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: firestore.collection('Users').doc(
                                  Profile.profileEmail).snapshots(),
                              //TODO After Changing City Multiple Build Screens Are Called Previous Screens Are Running In Background
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                        '${'Change City (' + Settings2.cityName})',style: TextStyle(color: Colors.black)
                                    );
                                  } else {
                                    return Text(
                                        '${'Change City (' + Settings2.cityName})',style: TextStyle(color: Colors.black)
                                    );
                                  }
                                } else {
                                  return Text(
                                      '${'Change City (' + Settings2.cityName})',style: TextStyle(color: Colors.black)
                                  );
                                }
                              },
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_outlined, size: 20,color: Colors.black),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    InkWell(
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Credits In Developments');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Credits \$0.00',style: TextStyle(color: Colors.black)),
                          Icon(
                            Icons.arrow_forward_ios_outlined,color: Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: Profile.profileEmail == 'soccerlifea37@gmail.com'
                          ? true
                          : false,
                      child: InkWell(
                        onTap: ()=> Get.toNamed('/OrganizerList'),
                        child: Column(
                          children: [
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Organizers List',style: TextStyle(color: Colors.black)
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: Profile.profileEmail == 'soccerlifea37@gmail.com'
                          ? true
                          : false,
                      child: Column(
                        children: [
                          Divider(
                              thickness: 1
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed('AddCity');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Add City',style: TextStyle(color: Colors.black),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height / 60),
              Text(
                'Become Organizer And Earn Upto 20\$ Reward For Each Game You Organize!',
                textAlign: TextAlign.center,),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height / 60),
              CustomButton(
                  buttonText: 'Become Organizer',
                  textColor: Colors.white,
                  buttonColor: kGreenColor,
                  outlineColor: Colors.transparent,
                  onPressed: () {
                    Get.toNamed('/BecomeOrganizer');
                    // if (Profile.profileEmail != 'soccerlifea37@gmail.com') {
                    //   print('True');
                    //   AlertDialog alert = AlertDialog(
                    //     backgroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: kBorderRadius
                    //     ),
                    //     title: Text('Request Admin',style: TextStyle(color: Colors.black),),
                    //     content: Text(
                    //         'Do You Want To Send Request To Admin To Become Organizer?'),
                    //     actions: [
                    //       CustomButton(
                    //           buttonText: 'Cancel',
                    //           textColor: kGreenColor,
                    //           buttonColor: Colors.white,
                    //           outlineColor: kGreenColor,
                    //           onPressed: () => Get.back()
                    //       ),
                    //       SizedBox(height: MediaQuery
                    //           .of(context)
                    //           .size
                    //           .height / 50),
                    //       CustomButton(
                    //           buttonText: 'Continue',
                    //           textColor: Colors.white,
                    //           buttonColor: kGreenColor,
                    //           outlineColor: Colors.transparent,
                    //           onPressed: () async {
                    //             Get.back();
                    //             await firestore.collection('Organizer Requests')
                    //                 .where(
                    //                 'Email', isEqualTo: Profile.profileEmail)
                    //                 .where('City', isEqualTo: Settings2.cityName)
                    //                 .get()
                    //                 .then((value) {
                    //               if (value.docs.length != 0) {
                    //                 AlertDialog alert = AlertDialog(
                    //                   backgroundColor: Colors.white,
                    //                   shape: RoundedRectangleBorder(
                    //                       borderRadius: kBorderRadius
                    //                   ),
                    //                   title: Text('Warning',style: TextStyle(color: Colors.black),),
                    //                   content: Text(
                    //                       'You Can Not Send Multiple Organizer Requests For Same City Please Change City And Try Again.'),
                    //                   actions: [
                    //                     CustomButton(
                    //                         buttonText: 'OK',
                    //                         textColor: kGreenColor,
                    //                         buttonColor: Colors.white,
                    //                         outlineColor: kGreenColor,
                    //                         onPressed: () => Get.back()
                    //                     ),
                    //
                    //                   ],
                    //                 );
                    //                 showDialog(context: context,
                    //                     builder: (BuildContext context) {
                    //                       return alert;
                    //                     });
                    //               } else {
                    //                 addData();
                    //               }
                    //             });
                    //           }
                    //       ),
                    //     ],
                    //   );
                    //   showDialog(
                    //       context: context, builder: (BuildContext context) {
                    //     return alert;
                    //   });
                    // } else {
                    //   Get.toNamed('/BecomeOrganizer');
                    // }
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
