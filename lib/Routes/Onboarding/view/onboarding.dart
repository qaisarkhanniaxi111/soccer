import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:soccer_life/main.dart';
import 'package:soccer_life/modals/global_widgets.dart';
import '../../../modals/constants.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:search_map_location/search_map_location.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                child: Image.asset(
                  'images/greenShapeNew.png',
                  fit: BoxFit.fill,
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Center(
              child: Image.asset(
                'images/Logo (1).png',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.6 - 30,
                left: 22,
                right: 22,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    Text('Soccer Life',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40)),
                    //Football Matches Text
                    Text('Football Matches Organizer'),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    //Get Started Button
                    CustomButton(
                      buttonText: 'Get started',
                      textColor: Colors.white,
                      buttonColor: kGreenColor,
                      outlineColor: Colors.transparent,
                      onPressed: () {
                        Get.offNamed('/SignIn');
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1 - 60,
                    ),
                    //Login Button
                    CustomButton(
                      buttonText: 'Login',
                      textColor: kGreenColor,
                      buttonColor: Colors.white,
                      outlineColor: kGreenColor,
                      onPressed: () => Get.offNamed('/SignIn'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1 - 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}


