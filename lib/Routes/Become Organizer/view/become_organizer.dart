import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/widget/search_widget.dart';
import 'package:soccer_life/Routes/Profile/view/profile.dart';
import 'package:soccer_life/Routes/Settings/view/settings.dart';
import 'package:soccer_life/modals/constants.dart';
import 'package:soccer_life/modals/global_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Onboarding/view/onboarding.dart';

class GoogleMaps1 extends StatefulWidget {
  GoogleMaps1({
    super.key,
    required this.currentPosition,
  });

  LatLng currentPosition;
  String? selectedLocation;
  Uint8List? mapImage = Uint8List(1);

  @override
  State<GoogleMaps1> createState() => _GoogleMaps1State();
}

class _GoogleMaps1State extends State<GoogleMaps1> {
  @override

  Completer<GoogleMapController> _controller = Completer();

  mapAddress(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

    widget.selectedLocation = '${placemarks[0].street.toString()}, ' +
        '${placemarks[0].thoroughfare.toString()}, ' +
        '${placemarks[0].subLocality.toString()}, ' +
        '${placemarks[0].locality.toString()}, ' +
        '${placemarks[0].subAdministrativeArea.toString()} ' +
        '${placemarks[0].administrativeArea.toString()}, ' +
        '${placemarks[0].country.toString()}.';
  }

  GoogleMapController? controller;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GoogleMap(
          onTap: (latLong) {
            mapAddress(latLong.latitude, latLong.longitude);

            widget.currentPosition = latLong;

            setState(() {});
          },
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            setState(() {});
          },
          initialCameraPosition:
              CameraPosition(target: widget.currentPosition, zoom: 14.0),
          markers: {
            //TODO Change Marker Icon To SoccerLife Football
            Marker(
                markerId: MarkerId('currentLocation'),
                position: widget.currentPosition,
                infoWindow: InfoWindow(title: 'SoccerLife'),
                icon: BitmapDescriptor.defaultMarker),
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 65, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchLocation(
              apiKey: 'AIzaSyANgTBPJjQopd8YQhA5_HV2uxLBFVY0NgE',
              onSelected: (Place place) async {
                final geolocation = await place.geolocation;
                final lat =
                    geolocation?.fullJSON['geometry']['location']['lat'];
                final lon =
                    geolocation?.fullJSON['geometry']['location']['lng'];

                mapAddress(lat, lon);

                widget.currentPosition = LatLng(lat, lon);

                controller = await _controller.future;

                print('SS Taking');
                print('SS Taking DONE');
                controller?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: widget.currentPosition, zoom: 14)));

                setState(() {});
              },
            ),
            ElevatedButton(
                child: Text('Select Location'),
                onPressed: () async {
                  if (widget.selectedLocation != null) {
                    controller = await _controller.future;
                    widget.mapImage = await controller?.takeSnapshot();
                    AlertDialog alert = AlertDialog(
                      backgroundColor: Colors.white,
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      shape:
                          RoundedRectangleBorder(borderRadius: kBorderRadius),
                      title: Text(
                        'Select This Location?',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue)),
                            child: Image.memory(widget.mapImage!),
                          ),
                          Text(
                            '${widget.selectedLocation}',
                            maxLines: 2,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () => Get.back(), child: Text('Cancel')),
                        ElevatedButton(
                            child: Text('Yes'),
                            onPressed: () {
                              BecomeOrganizer.matchLocationController.text =
                                  widget.selectedLocation!;
                              BecomeOrganizer.mapImage = widget.mapImage!;
                              BecomeOrganizer.matchCoordinates =
                                  widget.currentPosition;
                              Get.back();
                              Get.back();
                            })
                      ],
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => alert);
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            'Please Tap Somewhere On Screen To Select Location!');
                  }
                })
          ],
        ),
      ),
    );
  }
}

class BecomeOrganizer extends StatefulWidget {
  BecomeOrganizer({this.cityName});

  final String? cityName;
  int? timeStamp2;
  static TextEditingController matchLocationController =
      TextEditingController();
  static Uint8List mapImage = Uint8List(1);
  static LatLng? matchCoordinates;

  @override
  State<BecomeOrganizer> createState() => _BecomeOrganizerState();
}

class _BecomeOrganizerState extends State<BecomeOrganizer> {
  //Global Key For Text Fields
  GlobalKey<FormState> globalKey = GlobalKey();

  //Firebase Instance
  final firestore = FirebaseFirestore.instance;

  //Text Field Controllers
  TextEditingController matchImageController = TextEditingController();

  TextEditingController matchNameController = TextEditingController();

  TextEditingController matchDescriptionController = TextEditingController();

  TextEditingController cityNameController = TextEditingController();

  TextEditingController matchFeeController = TextEditingController();
  TextEditingController noOfPlayersController = TextEditingController();

  TextEditingController matchStartTimeController = TextEditingController();
  TextEditingController matchEndTimeController = TextEditingController();

  TextEditingController matchDateController = TextEditingController();

  //Variable To Store Image
  XFile? matchImage;

  //Pick Image From Mobile Storage
  void getImage() async {
    ImagePicker imagePicker = ImagePicker();

    matchImage = await imagePicker.pickImage(source: ImageSource.gallery);
    matchImageController.text = matchImage!.path;
    Fluttertoast.showToast(msg: 'Image Selected');
  }

  bool isLoading = false;

  //Add Data To Firebase
  void addData() async {
    if (matchImage == null) return;
    if (await doesDataAlreadyExists()) {
      Fluttertoast.showToast(msg: 'Match Already Exists Please Change Name');
    }
    //Adding Data to Firebase
    else {
      isLoading = true;
      setState(() {});
      // //Image Variables
      // String uniqueNameMatchImage = DateTime
      //     .now()
      //     .microsecondsSinceEpoch
      //     .toString();
      // String uniqueNameMapImage = DateTime
      //     .now()
      //     .microsecondsSinceEpoch
      //     .toString();
      //
      // final storageRef = FirebaseStorage.instance.ref();
      // final imagesRef = storageRef.child('images');
      //
      // final matchImageUpload = imagesRef.child(uniqueNameMatchImage);
      // final mapImageUpload = imagesRef.child(uniqueNameMapImage);

      try {
        // //Uploading Image To Firebase
        // String? mapImage;
        //   Fluttertoast.showToast(msg: 'Registering Match Please Wait!');
        //
        // await matchImageUpload.putFile(File(matchImage!.path));
        // matchImageController.text = await matchImageUpload.getDownloadURL();
        //
        // await mapImageUpload.putData(BecomeOrganizer.mapImage);
        //  mapImage = await mapImageUpload.getDownloadURL();

        print('Adding Player Data');
        // //Adding Match Data
        // await firestore.collection('Matches').doc(
        //     matchNameController.text.toUpperCase()).set({
        //   'Match Image': matchImageController.text.trim(),
        //   'Match Name': matchNameController.text.trim().toUpperCase(),
        //   'City Name': cityNameController.text.trim(),
        //   'Match Description': matchDescriptionController.text.trim(),
        //   'Time': matchTimeController.text.trim(),
        //   'Date': matchDateController.text.trim(),
        //   'Match Duration': matchDurationController.text.trim(),
        //   'No of Players': noOfPlayersController.text.trim(),
        //   'Match Fee': matchFeeController.text.trim(),
        //   'Match Location': BecomeOrganizer.matchLocationController.text.trim(),
        //   'Match Coordinates': GeoPoint(BecomeOrganizer.matchCoordinates!.latitude,BecomeOrganizer.matchCoordinates!.longitude),
        //   'Map Image': mapImage,
        //   'Added By': Profile.profileName,
        //   'Email': Profile.profileEmail,
        //   'Photo': Profile.profilePhoto,
        //   'Time Stamp': FieldValue.serverTimestamp(),
        //   'Time Stamp2': widget.timeStamp2,
        //   'Total Players': FieldValue.increment(1)
        // });

        //Adding Organizer As a Player In The Match
        print('ORGANIZER player');
        await firestore
            .collection('Matches')
            .doc(matchNameController.text.toUpperCase())
            .collection('Players')
            .doc(Profile.profileEmail)
            .set({
          'Player Name': Profile.profileName,
          'Player Photo': Profile.profilePhoto,
          'Email': Profile.profileEmail,
          'Goals': 0,
          'Assist': 0
        });

        print('Adding player profile stats');
        // Adding Player Profile Statistics
        await firestore
            .collection('Users')
            .doc(Profile.profileEmail)
            .collection('Games')
            .doc(matchNameController.text.toUpperCase())
            .set({
          'Game Name': matchNameController.text.toUpperCase().trim(),
          'Goals': 0,
          'Assist': 0,
          'Time Stamp': FieldValue.serverTimestamp()
        });

        //Adding Organizer Into Organizer List
        print('Increment');
        await firestore
            .collection('Organizers List')
            .where('Email', isEqualTo: Profile.profileEmail)
            .get()
            .then((value) async {
          if (value.docs.length == 0) {
            print('object');
            await firestore
                .collection('Organizers List')
                .doc(Profile.profileEmail)
                .set({
              'Player Name': Profile.profileName,
              'Player Photo': Profile.profilePhoto,
              'Email': Profile.profileEmail,
              'Organized Games': FieldValue.increment(1)
            });
          } else {
            print('object1');
            await firestore
                .collection('Organizers List')
                .doc(Profile.profileEmail)
                .update({'Organized Games': FieldValue.increment(1)});
          }
        });
        Fluttertoast.showToast(msg: 'Match Registered Successfully!');
        isLoading = false;
        // clearFields();
        // Get.back();
      } catch (e) {
        isLoading = false;
        print(e);
        Fluttertoast.showToast(
            msg: 'Please Check Your Internet And Try Again!.');
      }
    }
    setState(() {});
  }

  // Function To Avoid Adding Duplicate Data.
  Future<bool> doesDataAlreadyExists() async {
    final QuerySnapshot result = await firestore
        .collection('Organizer Requests')
        .where(
          'Match Name',
          isEqualTo: matchNameController.text.trim().toUpperCase(),
        )
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Clear Text Fields
  void clearFields() {
    matchNameController.clear();
    matchImageController.clear();
    matchDescriptionController.clear();
    cityNameController.clear();
    matchFeeController.clear();
    noOfPlayersController.clear();
    matchStartTimeController.clear();
    matchEndTimeController.clear();
    matchDateController.clear();
    BecomeOrganizer.matchLocationController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    // Profile.profileEmail != 'soccerlifea37@gmail.com' ? cityNameController.text = widget.cityName! : null;
    super.initState();
  }

  Position? position;
  LatLng? myLocation;

  Future<Object> _determinePosition() async {

    print('Google Maps');

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Fluttertoast.showToast(msg: 'Please Enable Location');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng sourceLocation = LatLng(position!.latitude, position!.longitude);

    Get.to(() => GoogleMaps1(currentPosition: sourceLocation));

    return await Geolocator.getCurrentPosition();
  }

  void sendRequest() async {
    if (matchImage == null) return;
    if (await doesDataAlreadyExists()) {
      Fluttertoast.showToast(msg: 'Match Already Exists Please Change Name');
    } else {
      isLoading = true;
      setState(() {});

      //Image Variables
      String uniqueNameMatchImage =
          DateTime.now().microsecondsSinceEpoch.toString();
      String uniqueNameMapImage =
          DateTime.now().microsecondsSinceEpoch.toString();

      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child('images');

      final matchImageUpload = imagesRef.child(uniqueNameMatchImage);
      final mapImageUpload = imagesRef.child(uniqueNameMapImage);

      try {
        //Uploading Image To Firebase
        String? mapImage;
        Fluttertoast.showToast(msg: 'Sending Request To Admin Please Wait!');

        await matchImageUpload.putFile(File(matchImage!.path));
        matchImageController.text = await matchImageUpload.getDownloadURL();

        await mapImageUpload.putData(BecomeOrganizer.mapImage);
        mapImage = await mapImageUpload.getDownloadURL();

        //Adding Data To Organizer Requests
        await firestore
            .collection('Organizer Requests')
            .doc(matchNameController.text.toUpperCase())
            .set({
          'Match Image': matchImageController.text.trim(),
          'Match Name': matchNameController.text.trim().toUpperCase(),
          'City Name': cityNameController.text.trim(),
          'Match Description': matchDescriptionController.text.trim(),
          'Start Time': matchStartTimeController.text.trim(),
          'End Time': matchEndTimeController.text.trim(),
          'Date': matchDateController.text.trim(),
          'Match Duration': matchDuration,
          'No of Players': noOfPlayersController.text.trim(),
          'Match Fee': matchFeeController.text.trim(),
          'Match Location': BecomeOrganizer.matchLocationController.text.trim(),
          'Match Coordinates': GeoPoint(
              BecomeOrganizer.matchCoordinates!.latitude,
              BecomeOrganizer.matchCoordinates!.longitude),
          'Map Image': mapImage,
          'Added By': Profile.profileName,
          'Email': Profile.profileEmail,
          'Photo': Profile.profilePhoto,
          'Time Stamp2': widget.timeStamp2,
          'Total Players': FieldValue.increment(1),
          'Status': 'PENDING'
        });
        Fluttertoast.showToast(
            msg:
                'Request Sent Please Check Game Requests For Approved Requests');
        isLoading = false;
        // clearFields();
        // Get.back();
      } catch (e) {
        print(e);
        Fluttertoast.showToast(msg: 'Please Check Your Internet Connection!');
        isLoading = false;
      }
    }
    setState(() {});
  }

   TimeOfDay? startTimePicker;
  String? matchDuration;

  int getMatchDuration(TimeOfDay tod1, TimeOfDay tod2) {
    return  (tod2.hour * 60 + tod2.minute) - (tod1.hour * 60 + tod1.minute);
  }

  String getTimeOfDayDiff(TimeOfDay tod1, TimeOfDay tod2) {
    var minutes = (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);

    return matchDuration = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60).toString();
  }


  int players = 0;
  bool playersFocus = false;
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
        title: Text('Become Organizer'),
      ),
      body: Form(
        key: globalKey,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 0, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Data Text Fields
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 55),
                  child: Column(
                    children: [
                      //Add City Text
                      Text(
                        'Organize a Soccer Match In Your City',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      //Match Photo
                      CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Select Photo';
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.none,
                          suffixIcon: InkWell(
                            onTap: () {
                              getImage();
                              matchImageController.clear();
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: kGreenColor),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                          hinText: 'Add Photo',
                          controller: matchImageController),
                      //Match Name
                      CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Add Match Name';
                            } else {
                              return null;
                            }
                          },
                          hinText: 'Match Name',
                          controller: matchNameController),
                      //Select City
                      // Profile.profileEmail == 'soccerlifea37@gmail.com'
                      //     ?
                      CustomTypeAhead(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select City';
                          } else {
                            return null;
                          }
                        },
                        topPadding: MediaQuery.of(context).size.height / 85,
                        cityNameController: cityNameController,
                        firestore: firestore,
                      ),
                      // CustomTextField(
                      //     onTap: () {
                      //       Fluttertoast.showToast(
                      //           msg: 'Please Request Admin For Different City');
                      //     },
                      //     keyboardType: TextInputType.none,
                      //     hinText: 'Select City',
                      //     controller: cityNameController),
                      //City Description
                      CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Add Match Description';
                            } else {
                              return null;
                            }
                          },
                          maxLines: 4,
                          contentPadding: EdgeInsets.only(left: 15, top: 15),
                          hinText: 'Match Description/Match Address',
                          controller: matchDescriptionController),
                      //Time And Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Start Time Of The Match
                          CustomTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Cannot Be Empty';
                              }
                            },
                            textFieldSize:
                                MediaQuery.of(context).size.width * 0.45,
                            hinText: 'Start Time',
                            controller: matchStartTimeController,
                            keyboardType: TextInputType.none,
                            onTap: () async {
                              startTimePicker = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              matchStartTimeController.text =
                                  startTimePicker!.format(context).toString();
                              
                              print('Start Time Is');
                              print(matchStartTimeController.text);
                            },
                          ),
                          //End Time Of The Match
                          CustomTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Cannot Be Empty';
                              }
                            },
                            textFieldSize:
                                MediaQuery.of(context).size.width * 0.45,
                            hinText: 'End Time',
                            controller: matchEndTimeController,
                            keyboardType: TextInputType.none,
                            onTap: () async {

                              if(matchStartTimeController.text.isEmpty){
                                Fluttertoast.showToast(msg: 'Please Select Start Time First!');
                              }else {
                                final TimeOfDay? picker = await showTimePicker(
                                    context: context,
                                    initialTime: startTimePicker!);
                                matchEndTimeController.text =
                                    picker!.format(context).toString();


                                getMatchDuration(startTimePicker!, picker);
                                matchDuration =
                                    getMatchDuration(startTimePicker!, picker)
                                        .toString() + ' Minutes';
                                Fluttertoast.showToast(msg: matchDuration!);
                              }
                            },
                          ),
                        ],
                      ),
                      //Date Of The Match
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Cannot Be Empty';
                          }
                        },
                        hinText: 'Date of the Match',
                        controller: matchDateController,
                        keyboardType: TextInputType.none,
                        onTap: () async {

                          final DateTime? picker = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                          print('DATE PICKER');
                          widget.timeStamp2 = picker?.millisecondsSinceEpoch;

                          print(widget.timeStamp2);
                          matchDateController.text =
                              DateFormat.yMd().format(picker!).toString();
                          print(matchDateController.text);
                        },
                      ),
                      //Match Duration
                      // CustomDropDown(
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Field Cannot Be Empty';
                      //     }
                      //   },
                      //   hintText: 'Match Duration',
                      //   dropDownMenuItems: [
                      //     DropdownMenuItem(
                      //       child: Text('30 Minutes'),
                      //       value: '30 Minutes',
                      //     ),
                      //     DropdownMenuItem(
                      //       child: Text('60 Minutes'),
                      //       value: '60 Minutes',
                      //     ),
                      //     DropdownMenuItem(
                      //       child: Text('90 Minutes'),
                      //       value: '90 Minutes',
                      //     ),
                      //     DropdownMenuItem(
                      //       child: Text('120 Minutes'),
                      //       value: '120 Minutes',
                      //     ),
                      //   ],
                      //   onChanged: (val) {
                      //     matchDurationController.text = val;
                      //   },
                      // ),
                      //Number of Players And Match Fee
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextField(
                            textAlign: TextAlign.center,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Cannot Be Empty';
                              }
                            },
                            keyboardType: TextInputType.none,
                            textFieldSize:
                            MediaQuery.of(context).size.width * 0.45,
                            hinText: 'Players',
                            controller: noOfPlayersController,
                            prefixIcon: IconButton(
                                padding: EdgeInsets.only(left: 20),
                                onPressed: (){
                              if(players != 0) players--;
                              noOfPlayersController.text = players.toString();
                              setState(() {});
                            }, icon: Icon(FontAwesomeIcons.minus,size: 15)),
                            suffixIcon: IconButton(
                                padding: EdgeInsets.only(right: 20),
                                onPressed: (){
                              players++;
                              noOfPlayersController.text = players.toString();
                              setState(() {});
                            }, icon: Icon(FontAwesomeIcons.plus,size: 15,)),
                          ),
                          // InkWell(
                          //   onTap: (){
                          //     playersFocus = true;
                          //         setState(() {});
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.only(top: 10),
                          //     height: MediaQuery.sizeOf(context).width / 7.5,
                          //     width: MediaQuery.sizeOf(context).width * 0.45,
                          //     decoration: BoxDecoration(
                          //       borderRadius: kBorderRadius,
                          //       border: Border.all(color: kGreenColor)
                          //     ),
                          //     child: Center(
                          //       child: playersFocus == true ? Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //         children: [
                          //           InkWell(
                          //               onTap: () {
                          //                 if (players != 0) players--;
                          //                 setState(() {});
                          //               },
                          //               child:
                          //               Icon(FontAwesomeIcons.minus, size: 12)),
                          //           Text('$players'),
                          //           InkWell(
                          //             onTap: () {
                          //
                          //               players++;
                          //               setState(() {});
                          //             },
                          //             child: Icon(FontAwesomeIcons.plus, size: 12),
                          //           )
                          //         ],
                          //       ):
                          //       Text('No of Players',style: TextStyle(color: Colors.grey.shade500),),
                          //     ),
                          //   ),
                          // ),
                          //// Number Of Players
                          // CustomDropDown(
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return 'Field Cannot Be Empty';
                          //       }
                          //     },
                          //     dropDownSize:
                          //         MediaQuery.of(context).size.width * 0.45,
                          //     dropDownMenuItems: [
                          //       DropdownMenuItem(
                          //           child: Text('6 Players'),
                          //           value: '6 Players'),
                          //       DropdownMenuItem(
                          //           child: Text('8 Players'),
                          //           value: '8 Players'),
                          //       DropdownMenuItem(
                          //           child: Text('10 Players'),
                          //           value: '10 Players'),
                          //       DropdownMenuItem(
                          //           child: Text('12 Players'),
                          //           value: '12 Players'),
                          //     ],
                          //     onChanged: (val) {
                          //       noOfPlayersController.text = val;
                          //     },
                          //     hintText: 'No of Players'),
                          //// Match Fee
                          CustomTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field Cannot Be Empty';
                              }
                            },
                            keyboardType: TextInputType.number,
                            textFieldSize:
                                MediaQuery.of(context).size.width * 0.45,
                            hinText: 'Fee (Per Player)',
                            controller: matchFeeController,
                          ),
                        ],
                      ),
                      //Location Of The Match
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select Match Location';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.none,
                        hinText: 'Select Match Location',
                        controller: BecomeOrganizer.matchLocationController,
                        suffixIcon: InkWell(
                          onTap: () {
                            _determinePosition();
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: kGreenColor),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                          buttonText: 'Add Match',
                          textColor: Colors.white,
                          buttonColor: kGreenColor,
                          outlineColor: Colors.transparent,
                          onPressed: () {
                            if (globalKey.currentState!.validate()) {
                              // Add Data To Firebase
                              // addData();
                              sendRequest();
                            }
                          }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
