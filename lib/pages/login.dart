import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Testing');

  FirebaseAuth _auth = FirebaseAuth.instance;

  static String verifyid = "";
  static String phoneNumber = "";
  static String firstName = "";
  static String lastName = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image or Color
          Container(
            decoration: BoxDecoration(),
          ),
          // Login Form
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or App Name
                // Add your logo or app name widget here

                SizedBox(height: 20.0),

                // Email Login Button
                Container(
                  width: double.infinity,
                  // Set button width to fill available space
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle email login
                    },
                    icon: Image.asset(
                      'assets/phone.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    label: Text('Login with Phone Number'),
                  ),
                ),

                SizedBox(height: 10.0),

                Container(
                  width: double.infinity,
                  // Set button width to fill available space
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle email login
                      _showPopup(context);
                      //signInWithEmailAndPassword();
                    },
                    icon: Image.asset(
                      'assets/gmail_logo.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    label: Text('Login with Email'),
                  ),
                ),

                SizedBox(height: 10.0),

                // Facebook Login Button
                Container(
                  width: double.infinity,
                  // Set button width to fill available space
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Facebook login
                    },
                    icon: Image.asset(
                      'assets/facebook_logo.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    label: Text('Login with Facebook'),
                  ),
                ),

                SizedBox(height: 10.0),

                // Apple Login Button
                Container(
                  width: double.infinity,
                  // Set button width to fill available space
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Apple login
                    },
                    icon: Image.asset(
                      'assets/apple_logo.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    label: Text('Login with Apple'),
                  ),
                ),

                SizedBox(height: 10.0),

                // "Or" Text
                Column(
                  children: [
                    SizedBox(height: 10.0),
                    Text(
                      'or',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.0),

                // Manual Login Form
                TextFormField(
                  onChanged: (value) => {LoginPage.firstName = value},
                  decoration: InputDecoration(hintText: 'First Name'),
                ),

                SizedBox(height: 10.0),

                TextFormField(
                  onChanged: (value) => {LoginPage.lastName = value},
                  decoration: InputDecoration(hintText: 'Last Name'),
                ),

                SizedBox(height: 10.0),

                TextFormField(
                  onChanged: (value) => {LoginPage.phoneNumber = value},
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    // Apply phone number formatter

                    LengthLimitingTextInputFormatter(14),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                ),
                SizedBox(height: 10.0),

                ElevatedButton(
                  onPressed: () async => {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: LoginPage.phoneNumber,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.pushNamed(context, "/otp");
                        LoginPage.verifyid = verificationId;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    ),
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createDocument() async {
    try {
      await usersCollection.add({
        'name': 'Qaisar Khan',
        'email': 'qaisar@gu-wi.com',
        'age': 30,
      });
      print('Document created successfully!');
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(myemail, mypasswrod) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: myemail, password: mypasswrod);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        createUserWithEmailAndPassword();
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'mbilal2292@gmail.com',
        password: '123456789',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Add your logic to handle the submission here
                String email = _emailController.text;
                String password = _passwordController.text;
                signInWithEmailAndPassword(email, password);
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
