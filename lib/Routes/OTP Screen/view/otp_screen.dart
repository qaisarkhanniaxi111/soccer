import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:soccer_life/Routes/Sign%20In/view/sign_in.dart';
import 'package:soccer_life/modals/constants.dart';
import '../../../modals/global_widgets.dart';
import '../../Profile/view/profile.dart';

class OTPScreen extends StatefulWidget {
  EmailOTP? myAuth = EmailOTP();

  OTPScreen({super.key, this.myAuth});

  static String verificationId = '';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  //Variables For Firebase User Data
  String? name;
  String? email;
  String? phone;
  String? provider;

  //Loading Indicator
  var isLoading = false;

  //Firebase Authentication Instance
  FirebaseAuth auth = FirebaseAuth.instance;

  //Firebase Database Storage Instance
  final firestore = FirebaseFirestore.instance.collection('Users');

  //OTP Code
  String? code;

  Future<void> checkData() async {
    print('Check Data');
    Profile.profileEmail = SignIn.phoneEmailController.text;
    try {
      await firestore
          .where('Email', isEqualTo: Profile.profileEmail)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          print('Length 0');
          Get.offAllNamed('/SelectCity');
          addData();
        } else {
          print('Length Not 01');
          Get.offAllNamed('/CustomNavigationBar');
        }
      });
      print('name');
    } catch (e) {
      print('Error');
      print(e);
    }
  }

  void verifyEmailOTP() async {
    if (await widget.myAuth?.verifyOTP(otp: code) == true) {
      Fluttertoast.showToast(msg: 'OTP Verified');
      try {
        await auth.createUserWithEmailAndPassword(
            email: SignIn.phoneEmailController.text.trim(),
            password: SignIn.phoneEmailController.text.trim());
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'email-already-in-use') {
          await auth.signInWithEmailAndPassword(
              email: SignIn.phoneEmailController.text.trim(),
              password: SignIn.phoneEmailController.text.trim());
        }
      }
      auth.authStateChanges().listen((User? user) {
        if (user != null) {
          name = SignIn.fullNameController.text;
          email = Profile.profileEmail;
          provider = 'Email';
          Profile.profileEmail = SignIn.phoneEmailController.text;
          checkData();
        } else {
          Fluttertoast.showToast(
              msg: 'Please Check Your Internet And Try Again');
        }
      });
      isLoading = false;
    } else {
      await Fluttertoast.showToast(msg: 'Wrong OTP');
      new Timer(const Duration(seconds: 2), () {
        isLoading = false;
        setState(() {});
      });
    }
    setState(() {});
  }

  //Verify Phone OTP
  void verifyPhoneOTP() async {
    try {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: OTPScreen.verificationId, smsCode: code!);
        print('Trying');
        await auth.signInWithCredential(credential);
        Fluttertoast.showToast(msg: 'Register New Number');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-verifaction-code') {
          await auth.signInWithPhoneNumber(SignIn.phoneEmailController.text);
          Fluttertoast.showToast(msg: 'Sign In Number');
        }
      }
      auth.authStateChanges().listen((User? user) async {
        if (user == null) {
          Fluttertoast.showToast(
              msg: 'Please Check Your Internet And Try Again');
          Timer(const Duration(seconds: 2), () {
            isLoading = false;
            setState(() {});
          });
        } else {
          name = SignIn.fullNameController.text;
          email = SignIn.phoneEmailController.text;
          provider = 'Phone';
          checkData();

          Fluttertoast.showToast(msg: 'OTP Verified');
          Get.offNamed('/SelectCity');
        }
      });
    } catch (e) {
      print('Trying Failed');
      print(e);
      Fluttertoast.showToast(msg: 'Wrong OTP');
      Timer(const Duration(seconds: 2), () {
        isLoading = false;
        setState(() {});
      });
    }
  }

  //Add Data To Firebase.
  void addData() {
    print('Firebase');
    Fluttertoast.showToast(msg: 'Firebase');
    firestore.doc(email?.trim()).set({
      'Name': name?.trim(),
      'Email': email?.trim(),
      'Provider': provider?.trim(),
      'PhotoURL':
          'https://firebasestorage.googleapis.com/v0/b/soccerapp-1b46a.appspot.com/o/images%2Fmessi.jpeg?alt=media&token=5a4c29fb-f1fa-4c9c-ad54-78cb0afdda0f',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: kPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //OTP Inform Text
              Text(
                SignIn.signInType
                    ? 'We have sent an \nOTP to Your Email'
                    : 'We have sent an \nOTP to Your Mobile',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              //Check Phone Text
              Text(
                SignIn.signInType
                    ? '${'Please check your Mobile Number ' + SignIn.phoneEmailController.text.trim() + ' continue to complete your profile.'}'
                    : '${'Please check your Email ' + SignIn.phoneEmailController.text.trim() + ' continue to complete your profile.'}',
                textAlign: TextAlign.center,
              ),
              //OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Pinput(
                      onChanged: (value) {
                        code = value;
                      },
                      length: 6,
                      //TODO Pin Color Change In Dark Mode
                      focusedPinTheme: PinTheme(
                        textStyle: TextStyle(color: Colors.black),
                          height: 52,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(color: kGreenColor),
                              borderRadius: OtpBorderRadius)),
                      defaultPinTheme: PinTheme(
                        textStyle: TextStyle(color: Colors.black),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: OtpBorderRadius),
                        height: 52,
                      ),
                    ),
                  )
                ],
              ),
              //Next Button
              SizedBox(
                child: isLoading == true
                    ? CircularProgressIndicator()
                    : CustomButton(
                        buttonText: 'Next',
                        textColor: Colors.white,
                        buttonColor: kGreenColor,
                        outlineColor: Colors.transparent,
                        onPressed: () {
                          isLoading = true;
                          setState(() {});
                          print(isLoading);
                          // Fluttertoast.showToast(msg: 'Verifying OTP');
                          SignIn.signInType == false
                              ? verifyEmailOTP()
                              : verifyPhoneOTP();
                          setState(() {});
                        }),
              ),
              // Didn't Receive Text
              InkWell(
                onTap: () => Get.offNamed('/SignIn'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Didn\'t Receive? '),
                    Text('Click Here',style: TextStyle(color: kGreenColor),)
                  ],
                ),
              ),
              //Terms & Conditions Text
              SizedBox(height: MediaQuery.of(context).size.height * 0.3 - 50,),
              Column(
                children: [
                  Text('You are completey Safe.'),
                  Text('Read out Terms & Conditions',style: TextStyle(color: kGreenColor),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
