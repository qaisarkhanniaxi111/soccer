//import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soccer/pages/AuthProvider.dart';
import 'package:soccer/pages/citylist.dart';
import 'package:soccer/pages/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soccer/pages/login.dart';
import 'package:soccer/pages/otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soccer/pages/otp.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var auth=FirebaseAuth.instance;
  var checkLogin=false;

  checkIfLogin() async{
    auth.authStateChanges().listen((User? user)
    {
     if(user!=null && mounted)
       {
         setState(() {
           checkLogin=true;
         });

       }
    });
}
@override
void initState(){
    checkIfLogin();
    super.initState();
}
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play Soccer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
        //textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),

        home: checkLogin? CityListPage():LoginPage(),

        routes:{
          "/login": (context)=>LoginPage(),
          "/otp":(context)=>OtpScreen(),
          "/citylist":(context)=>CityListPage()
        },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),

    );
  }
}
