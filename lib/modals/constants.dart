import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


String google_api_key = 'AIzaSyANgTBPJjQopd8YQhA5_HV2uxLBFVY0NgE';

//Colors
const kGreenColor = Color(0XFF0C5B3B);

const kOldGreenColor = Color(0XFF44DE00);

const kTextColor = Color(0XFF228D57);

const kNumberColor = Color(0XFF2A4989);

const kBlackColor = Colors.black;

const kWhiteColor = Color(0XFFFAFAFA);

Color kDefaultTextColor = kBlackColor;

Color kDefaultBackgroundColor = kWhiteColor;


//Padding
const kPadding = EdgeInsets.only(left: 22,right: 22,bottom: 20, top: 30,);


//Border Radius
const kBorderRadius = BorderRadius.all(Radius.circular(23));

const OtpBorderRadius = BorderRadius.all(Radius.circular(13));

const CustomBorder = OutlineInputBorder(
    borderSide: BorderSide(color: kGreenColor),
    borderRadius: kBorderRadius);
