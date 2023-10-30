import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:soccer_life/modals/constants.dart';
import 'package:soccer_life/modals/global_widgets.dart';
import 'package:email_otp/email_otp.dart';

import '../../OTP Screen/view/otp_screen.dart';
import '../../Profile/view/profile.dart';

class SignIn extends StatefulWidget {
  static bool signInType = false;
  static TextEditingController phoneEmailController = TextEditingController();
  static TextEditingController fullNameController = TextEditingController();

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Variables For Firebase User Data
  String? name;
  String? email;
  String photoUrl =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fdefault-profile-picture&psig=AOvVaw3SwbxBIpBdumikA7Vq1y2c&ust=1694572398295000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwjksIWghKSBAxWq7LsIHWMUDIIQjRx6BAgAEAw';
  String? phone;
  String? provider;

  //Instance For Email OTP
  EmailOTP myAuth = EmailOTP();

  //Loading Indicator
  bool isLoading = false;

  //Globar Key For Form Text Fields
  GlobalKey<FormState> globalKey = GlobalKey();

  //Firebase Authentication Instance
  FirebaseAuth auth = FirebaseAuth.instance;

  //Firebase User Data Instance
  final firestore = FirebaseFirestore.instance.collection('Users');

  //Add Data To Firebase
  Future<void> addData() async {
    print('Adding Data To Firebase');
    Fluttertoast.showToast(msg: 'Firebase');
    await firestore.doc(email?.trim().toLowerCase()).set({
      'Name': name?.trim(),
      'PhotoURL': photoUrl.trim(),
      'Email': email?.trim().toLowerCase(),
      'Provider': provider?.trim(),
    });
  }

  //Sign Up Using Phone
  void phoneSignUp() async {
    try {

      isLoading = true;
      setState(() {});
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${SignIn.phoneEmailController.text}',
        verificationCompleted: (PhoneAuthCredential credential) {
        },
        verificationFailed: (FirebaseAuthException e) {
        },
        codeSent: (String verificationId, int? resendToken) {
          Fluttertoast.showToast(msg: 'OTP Sent! Please Check Your Phone');
          OTPScreen.verificationId = verificationId;
          isLoading = false;
          Get.toNamed('/OTPScreen');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        },
      );
      isLoading = false;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.code);
      isLoading = false;
    }
    setState(() {});
  }

  //Sign Up Using Email
  void emailSignUp() async {

    var isValid =
        EmailValidator.validate(SignIn.phoneEmailController.text.trim());

    if (isValid) {
      try {

        print('EMAIL');
        isLoading = true;
        setState(() {});

        myAuth.setConfig(
            otpLength: 6,
            otpType: OTPType.digitsOnly,
            appEmail: 'Admin@SoccerLife.com',
            appName: 'Soccer Life',
            userEmail: SignIn.phoneEmailController.text);

        if (await myAuth.sendOTP() == true) {
          Fluttertoast.showToast(msg: 'OTP Sent Please Check Your Email');
          Get.to(() => OTPScreen(myAuth: myAuth,));
          isLoading = false;
        }
      } on FirebaseAuthException catch (e) {
        print('ERROR');
        print(e);
        Fluttertoast.showToast(msg: e.code);
        isLoading = false;
      }
    } else {
      isLoading = false;
      Fluttertoast.showToast(msg: 'Invalid Email');
    }
    isLoading = false;
    setState(() {});
  }

  //Sign In With Google
  void signInWithGoogle() async {
    print('Google Sign In');
    UserCredential? userCredentials;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      try {
        userCredentials = await auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        print('Auth Exception');
        print(e.code);
      }

      auth.authStateChanges().listen((User? user) async {
        if (user != null) {
          name = userCredentials!.user!.displayName;
          email = userCredentials.user!.email;
          photoUrl = userCredentials.user!.photoURL!;
          provider = 'Google';
          Profile.profileName = auth.currentUser!.displayName;
          Profile.profileEmail = auth.currentUser!.email;
          Profile.profilePhoto = auth.currentUser!.photoURL;
          checkData();
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      Fluttertoast.showToast(
          msg: 'Please Check Your Internet Connection And Try Again!');
    }
  }

  Future<void> checkData() async {
    print('Check Data1');
    Profile.profileName = auth.currentUser!.displayName;
    Profile.profileEmail = auth.currentUser!.email;
    Profile.profilePhoto = auth.currentUser!.photoURL;
    try {
      await firestore.where('Email', isEqualTo: Profile.profileEmail)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          print('Length 0');
          Get.offNamed('/SelectCity');
          addData();
        } else {
          print('Length Not 0');
          Get.offNamed('/CustomNavigationBar');
        }
      });
      print('Welcone ' + name!);

    } catch (e) {
      print('Error');
      print(e);
    }

  }

  //Sign In With Facebook
  // void signInWithFacebook() async {
  //   try {
  //     UserCredential userCredentials;
  //     final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //     try {
  //       userCredentials =
  //           await auth.signInWithCredential(facebookAuthCredential);
  //       auth.authStateChanges().listen((User? user) async {
  //         if (user != null) {
  //           name = userCredentials.user!.displayName;
  //           email = userCredentials.user!.email;
  //           photoUrl = userCredentials.user!.photoURL!;
  //           provider = 'Facebook';
  //
  //           checkData();
  //           Fluttertoast.showToast(msg: '${'Welcome ' + name!}');
  //         }
  //       });
  //     } on FirebaseAuthException catch (e) {}
  //   } on FirebaseAuthException catch (e) {
  //     print(e.code);
  //     Fluttertoast.showToast(
  //         msg: 'Please Check Your Internet Connection And Try Again!');
  //   }
  // }


  // Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: globalKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 22, right: 22, top: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Sign In Text
                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Add your details to Sign In',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    //Apple Sign In Button
                    CustomButton(
                        buttonIcon: 'images/apple.png',
                        buttonText: 'Sign in with Apple',
                        textColor: Colors.black,
                        buttonColor: Colors.white,
                        outlineColor: Colors.white,
                        onPressed: () =>
                            Fluttertoast.showToast(msg: 'Coming Soon!')),
                    //Google Sign In Button
                    CustomButton(
                        buttonIcon: 'images/google.png',
                        buttonText: 'Sign in with Google',
                        textColor: kGreenColor,
                        buttonColor: Colors.white,
                        outlineColor: Colors.white,
                        onPressed: () {
                          signInWithGoogle();
                        }),
                    //Facebook Sign In Button
                    CustomButton(
                        buttonIcon: 'images/facebook.png',
                        buttonText: 'Sign in with Facebook',
                        textColor: kGreenColor,
                        buttonColor: Colors.white,
                        outlineColor: Colors.white,
                        onPressed: () {
                          AlertDialog alert = AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: kBorderRadius
                            ),
                            title: Text('Warning!',style: TextStyle(color: Colors.black)),
                            content: Text(
                                'You Can Only Sign In Using Facebook Email. If Your Facebook Uses Phone Number Only, You Won\'t Be Able To Sign In!'),
                            actions: [
                              CustomButton(
                                  buttonText: 'Cancel',
                                  textColor: kGreenColor,
                                  buttonColor: Colors.white,
                                  outlineColor: kGreenColor,
                                  onPressed: () => Get.back()
                                  ),
                              SizedBox(height: MediaQuery.of(context).size.height / 50),
                              CustomButton(
                                  buttonText: 'Continue',
                                  textColor: Colors.white,
                                  buttonColor: kGreenColor,
                                  outlineColor: Colors.transparent,
                                  onPressed: () => {
                                    Get.back(),
                                     // signInWithFacebook()
                                  }
                              ),
                            ],
                          );

                          showDialog(context: context, builder: (BuildContext context){
                            return alert;
                          });
                        }),
                    //Register Text
                    Text(
                      'Or register with your email and \n phone number.',
                      style: TextStyle(color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                    //Full Name Text Field
                    CustomTextField(
                      contentPadding: EdgeInsets.all(
                          MediaQuery.of(context).size.height / 45),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Name!';
                        } else {
                          return null;
                        }
                      },
                      controller: SignIn.fullNameController,
                      hinText: 'Full Name ex: John Wick',
                    ),
                    //Phone/Email Text Field
                    CustomTextField(
                        contentPadding: EdgeInsets.all(
                            MediaQuery.of(context).size.height / 45),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Email/Phone!';
                          } else {
                            return null;
                          }
                        },
                        controller: SignIn.phoneEmailController,
                        keyboardType: SignIn.signInType
                            ? TextInputType.phone
                            : TextInputType.text,
                        hinText: SignIn.signInType ? 'Number ex: +923112233445' : 'Email ex: user@email.com',
                        suffixIcon: Icon(
                          SignIn.signInType ? Icons.phone : Icons.email,
                          color: kGreenColor
                        )),
                    //Sign In Button
                    SizedBox(
                      child: isLoading == true
                          ? CircularProgressIndicator()
                          : CustomButton(
                              buttonText: 'Sign In',
                              textColor: Colors.white,
                              buttonColor: kGreenColor,
                              outlineColor: Colors.transparent,
                              onPressed: () async {
                                if (globalKey.currentState!.validate()) {
                                  await SignIn.signInType == false
                                      ? emailSignUp()
                                      : phoneSignUp();
                                }
                              }),
                    ),
                    SizedBox(height: 10),
                    //Sign In Type Text
                    InkWell(
                      onTap: () {
                        SignIn.phoneEmailController.clear();
                        setState(() => SignIn.signInType = !SignIn.signInType);
                      },
                      child: Column(
                          children: [
                        Text(SignIn.signInType? 'Sign In With Email? \n': 'Sign In With Phone? \n'),
                            Text('Click Here',style: TextStyle(color: kGreenColor))
                      ],)
                    ),
                    //Terms And Conditions Text
                    SizedBox(height: 10),
                    Text('You Are Completely Safe'),
                    InkWell(child: Text('Read our Terms & Conditions',style: TextStyle(color: kGreenColor),),
                    onTap: (){
                      AlertDialog alert = AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: kBorderRadius
                        ),
                        title: Text('SoccerLife Terms And Conditions',style: TextStyle(color: Colors.black),),
                        content: Text("Using Soccer Life is simple and fun. Create an account for special features, respect the rules, and trust us with your data. Please ask before using or changing our content. We aim to provide a great experience but can't be responsible for any unexpected issues. These terms are guided by local laws, and we'll notify you of any updates. If you have questions, reach out. Enjoy Soccer Life!"),
                        actions: [
                          TextButton(onPressed: ()=> Get.back(), child: Text('OK'))
                        ],
                      );
                      showDialog(context: context, builder: (BuildContext context){
                        return alert;
                      });
                    },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
