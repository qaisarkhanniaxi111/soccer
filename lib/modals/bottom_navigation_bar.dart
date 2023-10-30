import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_life/Routes/Select%20Soccer/view/select_soccer.dart';

import '../Routes/Chat Screen/view/chat_screen.dart';
import '../Routes/Profile/view/profile.dart';
import '../Routes/Settings/view/settings.dart';
import 'constants.dart';


class CustomNavigationBar extends StatefulWidget {
  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}
class _CustomNavigationBarState extends State<CustomNavigationBar> with WidgetsBindingObserver {

  final firestore = FirebaseFirestore.instance.collection('Users');




  @override
    initState() {
    print('BottoamNavigation Bar Init');

    setCity();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      setStatus('Online');
    });
  }

  Future<void> setStatus(String status) async {
    await firestore.doc(Profile.profileEmail).update({
      'Status': status
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.resumed){
        setStatus('Online');
      print('Online');
    }else{
      print('Offline');
        setStatus('Offline');
    }
  }



  List<Widget> _screensList = <Widget>[
    SelectSoccer(),
    ChatScreen(),
    Profile(),
    Settings2(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Future<void> setCity() async {

    DocumentReference documentReference = firestore.doc(Profile.profileEmail);
    await  documentReference.get().then((snapshot) => {Settings2.cityName = snapshot.get('City'),});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height / 10 - 5 ,
        child: BottomNavigationBar(
          selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            iconSize: 20,
            unselectedFontSize: 0,
            selectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: kGreenColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  activeIcon: ActiveIcon(icon: Icons.sports_baseball_outlined,),
                  icon: Icon(Icons.sports_baseball_outlined),
                  label: 'PickUp'),
              BottomNavigationBarItem(
                  activeIcon: ActiveIcon(icon: FontAwesomeIcons.commentDots),
                  icon: Icon(FontAwesomeIcons.commentDots),
                  label: 'Messages'),
              BottomNavigationBarItem(
                  activeIcon: ActiveIcon(icon: FontAwesomeIcons.user),
                  icon: Icon(FontAwesomeIcons.user),
                  label: 'Profile'),
              BottomNavigationBarItem(
                  activeIcon: ActiveIcon(icon: Icons.settings),
                  icon: Icon(Icons.settings),
                  label: 'Settings'),
            ]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screensList,
      ),
    );
  }
}

class ActiveIcon extends StatelessWidget {
  IconData icon;
   ActiveIcon({
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3)),
      child: Icon(icon),
    );
  }
}