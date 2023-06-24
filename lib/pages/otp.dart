import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soccer/pages/db/usermodal.dart';
import 'package:soccer/pages/login.dart';
import 'package:provider/provider.dart';

import 'AuthProvider.dart';


class OtpScreen extends StatefulWidget {



  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  TextEditingController _otpController=new TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId="";


  @override
  Widget build(BuildContext context) {
    PhoneAuthCredential credential;
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async
              {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: LoginPage.verifyid,
                      smsCode: _otpController.text);
                  await auth.signInWithCredential(credential);

                  UserModal uModal=new UserModal();
                  var userDocument = await uModal.getUserDocument(LoginPage.phoneNumber);
                  if (userDocument.id != 'nonexistent') {
                    // Document found, you can access its data using userDocument.data()
                    //Map<String, dynamic> userData = userDocument.data();
                    // Do something with the user data
                  } else {
                    uModal.createDocument(LoginPage.firstName, LoginPage.lastName, LoginPage.phoneNumber);
                  }
                  auth.signInWithPhoneNumber(LoginPage.phoneNumber);

                //  Provider.of<AuthProvider>(context, listen: false).login();
                  Navigator.pushNamedAndRemoveUntil(context, "/citylist",(route)=>false);
                }
                catch(e)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter correct otp'),
                        duration: Duration(seconds: 2),
                      ));
                }
              },
              child: Text('Verify OTP'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () async => {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: LoginPage.phoneNumber,
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {
                    LoginPage.verifyid=verificationId;
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                ),
              },
              child: Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }

}
