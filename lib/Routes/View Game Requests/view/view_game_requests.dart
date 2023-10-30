import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soccer_life/Routes/Profile/view/profile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../modals/constants.dart';
import '../../../modals/global_widgets.dart';
import '../../Game Details/view/game_details.dart';

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

class ViewGameRequests extends StatefulWidget {
  ViewGameRequests(
      {super.key,
      this.dateStamp = 999999999999999999,
      this.matchImage,
      this.matchName,
      this.startTime,
      this.endTime,
      this.date,
      this.matchFee,
      this.duration,
      this.status,
      this.mapImage,
      this.mapLocation,
      this.matchCoordinates,
      this.email,
      this.noOfPlayers,
      this.totalPlayers,
      this.matchDescription,
      this.organizerPhoto,
      this.cityName,
      this.addedBy});

  final String? matchImage;
  final String? matchName;
  final String? addedBy;
  final String? noOfPlayers;
  final int? totalPlayers;
  final String? matchDescription;
  final String? organizerPhoto;
  final String? cityName;
  final String? startTime;
  final String? endTime;
  final String? date;
  final String? matchFee;
  final String? duration;
  final String? status;
  final String? mapImage;
  final String? mapLocation;
  final String? email;
  final GeoPoint? matchCoordinates;
  final int dateStamp;

  @override
  State<ViewGameRequests> createState() => _ViewGameRequestsState();
}

class _ViewGameRequestsState extends State<ViewGameRequests> {
  //Firebase Instance
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  void addData()async{
    try {

      Fluttertoast.showToast(msg: 'Registering Match Please Wait!');
      Get.back();
      isLoading = true;
      setState(() {});

      print('Match Data');
      //Adding Data To Organizer Requests
      await firestore
          .collection('Matches')
          .doc(widget.matchName?.toUpperCase())
          .set({
        'Match Image': widget.matchImage,
        'Match Name': widget.matchName,
        'City Name': widget.cityName,
        'Match Description':
        widget.matchDescription,
        'Start Time': widget.startTime,
        'End Time': widget.endTime,
        'Date': widget.date,
        'Match Duration': widget.duration,
        'No of Players': widget.noOfPlayers,
        'Match Fee': widget.matchFee,
        'Match Location': widget.mapLocation,
        'Match Coordinates':
        widget.matchCoordinates,
        'Map Image': widget.mapImage,
        'Added By': widget.addedBy,
        'Email': widget.email,
        'Photo': widget.organizerPhoto,
        'Time Stamp2': widget.dateStamp,
        'Total Players': widget.totalPlayers,
      });

      //Adding Organizer As a Player In The Match
      print('ORGANIZER DATA');
      await firestore
          .collection('Matches')
          .doc(widget.matchName?.toUpperCase())
          .collection('Players')
          .doc(widget.email)
          .set({
        'Player Name': widget.addedBy,
        'Player Photo': widget.organizerPhoto,
        'Email': widget.email,
        'Goals': 0,
        'Assist': 0
      });

      print('Profile Data');
      // Adding Player Profile Statistics
      await firestore
          .collection('Users')
          .doc(widget.email)
          .collection('Games')
          .doc(widget.matchName)
          .set({
        'Game Name': widget.matchName,
        'Goals': 0,
        'Assist': 0,
      });

      print('Request Status Data');
      //Approving Request Status
      await firestore
          .collection('Organizer Requests')
          .doc(widget.matchName?.toUpperCase())
          .update({'Status': 'APPROVED'});

      Fluttertoast.showToast(msg: 'Match Registered Successfully!');
      Get.back();

      isLoading = false;
    } catch (e) {
      isLoading = false;
      print(e);
      Fluttertoast.showToast(
          msg:
          'Please Check Your Internet Connection & Try Again');
    }
    setState(() {});
  }

  //TODO FIRST MATCH DOES NOT GET UPDATED
  void declineRequest()async{
    try{

      isLoading = true;
      setState(() {});

      print('UPDATING DATA');
      print(widget.matchName);

      String name = widget.matchName!;

      await firestore
          .collection('Organizer Requests')
          .doc(name)
          .update({'Status': 'DECLINED'});

      Fluttertoast.showToast(msg: 'Match Declined!');
      isLoading = false;
      Get.back();
      Get.back();

    }catch (e){
      isLoading = false;
      print('ERROR');
      print(e);
      Fluttertoast.showToast(msg: '$e');
      // Fluttertoast.showToast(msg: 'Please Check Your Internet Connection!');
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Game Request'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.4,
                  decoration: BoxDecoration(
                      borderRadius: kBorderRadius,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage('${widget.matchImage}')))),
              Text('${widget.matchName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 30,),
                      Text('${widget.startTime} - ${widget.endTime}   '),
                      Text('${widget.date}')
                    ],
                  ),
                  Row(
                    children: [
                      Text('\$${widget.matchFee}.00',
                          style: TextStyle(fontSize: 20, color: kGreenColor)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined, size: 30),
                      Text('${widget.duration}    ${widget.noOfPlayers} Players'),
                      Icon(FontAwesomeIcons.user,size: 15,),
                    ],
                  ),
                  InkWell(
                    onTap: () => Fluttertoast.showToast(
                        msg: 'Your Request Status Is ${widget.status}'),
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: widget.status == 'PENDING'
                                  ? kNumberColor
                                  : widget.status == 'APPROVED'
                                      ? kGreenColor
                                      : Colors.red)),
                      child: Text('${widget.status}',
                          style: TextStyle(
                              color: widget.status == 'PENDING'
                                  ? kNumberColor
                                  : widget.status == 'APPROVED'
                                      ? kGreenColor
                                      : Colors.red,
                              letterSpacing: 1.5)),
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              Visibility(
                visible: Profile.profileEmail == 'soccerlifea37@gmail.com'
                    ? true
                    : false,
                child: Visibility(
                  visible: widget.status != 'PENDING' ? true : false,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: widget.status == 'APPROVED'
                              ? kGreenColor
                              : Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: OtpBorderRadius)),
                      onPressed: () => Fluttertoast.showToast(
                          msg: 'Request Has Been ${widget.status}!'),
                      child: Text(
                        widget.status == 'APPROVED'
                            ? 'APPROVED'
                            : widget.status == 'DECLINED'
                                ? 'DECLINED'
                                : 'EXPIRED',
                      )),
                ),
              ),
              Visibility(
                visible: Profile.profileEmail == 'soccerlifea37@gmail.com'
                    ? true
                    : false,
                child: Visibility(
                  visible: widget.status == 'PENDING' ? true : false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: OtpBorderRadius)),
                          onPressed: () async {
                            AlertDialog alert = AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: kBorderRadius),
                              title: Text('Decline This Game?',
                                  style: TextStyle(color: Colors.black)),
                              content: Text(
                                  'This Game Will Not Show Up To Anyone!.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    )),
                                TextButton(
                                  onPressed: (){
                                    declineRequest();
                                  },
                                    child: Text(
                                      'Decline',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                });
                          },
                          child: Text(
                            'Decline',
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 50,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kGreenColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: OtpBorderRadius)),
                          onPressed: () async {

                            print('Approved');
                            AlertDialog alert = AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: kBorderRadius),
                              title: Text('Approve This Game?',
                                  style: TextStyle(color: Colors.black)),
                              content: Text(
                                  'This Game Will Show Up To All The Users.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      addData();
                                    },
                                    child: Text(
                                      'Approve',
                                      style: TextStyle(color: kGreenColor),
                                    ))
                              ],
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                });
                          },
                          child: Text(
                            'Approve',
                          )),
                    ],
                  ),
                ),
              ),
              isLoading == true ? LinearProgressIndicator() : SizedBox(),
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Match Location:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100),
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
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text('${widget.mapLocation}')),
            ],
          ),
        ),
      ),
    );
  }
}
