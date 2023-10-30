import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soccer_life/Routes/Become%20Organizer/view/become_organizer.dart';
import 'package:soccer_life/Routes/Chat%20Screen/view/chat_screen.dart';
import 'package:soccer_life/Routes/Completed%20Games/view/completed_games.dart';
import 'package:soccer_life/Routes/Game%20Statistics/view/game_statistics.dart';
import 'package:soccer_life/Routes/OTP%20Screen/view/otp_screen.dart';
import 'package:soccer_life/Routes/Organizer%20List/view/organizer_list.dart';
import 'package:soccer_life/Routes/Profile/view/profile.dart';
import 'package:soccer_life/Routes/Settings/view/settings.dart';
import 'package:soccer_life/Routes/Add%20Card/view/add_card.dart';
import 'package:soccer_life/Routes/Payment%20Method/view/payment_method.dart';
import 'package:soccer_life/Routes/Player%20Profile/view/player_profile.dart';
import 'package:soccer_life/Routes/View%20Game%20Requests/view/view_game_requests.dart';
import 'package:soccer_life/Routes/main_page.dart';
import 'package:soccer_life/modals/bottom_navigation_bar.dart';

import 'Routes/Add City (Admin Only)/view/add_city.dart';
import 'Routes/Game Details/view/game_details.dart';
import 'Routes/Game Requests/view/game_requests.dart';
import 'Routes/Message Screen/view/message_screen.dart';
import 'Routes/Onboarding/view/onboarding.dart';
import 'Routes/Select City/view/select_city.dart';
import 'Routes/Select Soccer/view/select_soccer.dart';
import 'Routes/Sign In/view/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Routes/Join Game/view/join_game.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;


Future<void> main() async {
  // HttpOverrides.global = MyHttpOverrides();
  // Stripe.publishableKey =
  //     'pk_test_51NqrX9JjeJk2uCD4HAZRNlycwulX0aKajZ9AhPDhE9jqDruFQez8cva2iAGLNvSEMCU5sjfsIUoTSiSasOpDWbH100SColdb3n';

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({super.key});


  //TODO Implement Divder Theme in Both Color Modes
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

  //TODO Add The Logo Splash Screen
  //TODO Last Message Issues In Other Gmail Profiles.
  //TODO Players Are Automatically Online After Other Player Log In
  //TODO LOGO in email otp
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/Onboarding',
      getPages: [
        GetPage(name: '/MainPage', page: () => MainPage()),
        GetPage(name: '/Onboarding', page: () => Onboarding()),
        GetPage(name: '/SignIn', page: () => SignIn()),
        GetPage(name: '/OTPScreen', page: () => OTPScreen()),
        GetPage(name: '/SelectCity', page: () => SelectCity()),
        GetPage(name: '/SelectSoccer', page: () => SelectSoccer()),
        GetPage(name: '/ChatScreen', page: () => ChatScreen()),
        GetPage(name: '/Profile', page: () => Profile()),
        GetPage(name: '/Settings', page: () => Settings2()),
        GetPage(name: '/CustomNavigationBar', page: () => CustomNavigationBar()),
        GetPage(name: '/GameDetails', page: () => GameDetails()),
        GetPage(name: '/MessageScreen', page: () => MessageScreen()),
        GetPage(name: '/PaymentMethod', page: () => PayNow()),
        GetPage(name: '/AddCard', page: () => AddCard()),
        GetPage(name: '/JoinGame', page: () => JoinGame()),
        GetPage(name: '/PlayerProfile', page: () => PlayerProfile()),
        GetPage(name: '/AddCity', page: () => AddCity()),
        GetPage(name: '/BecomeOrganizer', page: () => BecomeOrganizer()),
        GetPage(name: '/GameRequests', page: () => GameRequests()),
        GetPage(name: '/GameStatistics', page: () => GameStatistics()),
        GetPage(name: '/OrganizerList', page: () => OrganizerList()),
        GetPage(name: '/CompletedGames', page: () => CompletedGames()),
        GetPage(name: '/ViewGameRequests', page: () => ViewGameRequests()),
      ],
    );
  }
}

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }