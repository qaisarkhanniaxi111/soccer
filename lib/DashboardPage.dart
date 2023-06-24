import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soccer/CityPage.dart';
import 'package:soccer/GameCompletion.dart';
import 'package:soccer/GamePage.dart';
import 'package:soccer/LeaguePage.dart';
import 'package:soccer/ManagingOrganizerPager.dart';
import 'package:soccer/MatchesPage.dart';
import 'package:soccer/OrganizerAccessScreen.dart';
import 'package:soccer/pages/login.dart';

import 'PlayerForm.dart';

class DashboardPage extends StatelessWidget {
  final List<IconData> elevatorIcons = [
    Icons.people_sharp,
    Icons.flag,
    Icons.add_chart,
    Icons.book,
    Icons.sports_rounded,
    Icons.add_location,
    Icons.sports_motorsports_rounded,
    Icons.local_offer,
    Icons.logout,
  ];

  final List<String> elevatorTexts = [
    'Teams',
    'Game',
    'Create Game',
    'Score Card',
    'Leagues',
    'Payments',
    'Player',
    'Organizer',
    'Logout',
  ];

  get game => null;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/cities/newjersey.jpg'),
                      radius: 30,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Muhammad Bilal",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Project Director",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),

              /* Text(
                'JUST PALY',
                style: TextStyle(
                    fontSize: _getResponsiveFontSize(constraints.maxWidth, 24)),
              ),*/
              SizedBox(height: 16.0),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(9, (index) {
                  return _buildCircularElevator(context, index + 1);
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  double _getResponsiveFontSize(double screenWidth, double baseFontSize) {
    // Adjust the responsive scaling factor according to your needs
    const double scalingFactor = 0.03;

    return (screenWidth * scalingFactor) + baseFontSize;
  }

  Widget _buildCircularElevator(BuildContext context, int elevatorNumber) {
    final int index = elevatorNumber - 1;

    return Padding(
      padding: EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          // Handle tap event here
          _handleElevatorTap(context, elevatorNumber);
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                elevatorIcons[index],
                color: Colors.white,
                size: 30.0,
              ),
              SizedBox(height: 8.0),
              Text(
                elevatorTexts[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleElevatorTap(
      BuildContext context, int elevatorNumber) async {
    // Handle the tap event here
    //print('Elevator $elevatorNumber old tapped!');
    // You can add your custom logic for handling the tap event
    if (elevatorNumber == 1) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrganizerAccessScreen()),
      );
    } else if (elevatorNumber == 2) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchesPage()),
      );
    } else if (elevatorNumber == 3) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateGamesScreen()),
      );
    } else if (elevatorNumber == 4) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrganizerPage()),
      );
    } else if (elevatorNumber == 5) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeaguePage()),
      );
    } else if (elevatorNumber == 6) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CityPage()),
      );
    } else if (elevatorNumber == 7) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlayersPage()),
      );
    } else if (elevatorNumber == 8) {
      print('Elevator $elevatorNumber tapped!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrganizerRequestsPage()),
      );
    } else if (elevatorNumber == 9) {
      print('Elevator $elevatorNumber tapped!');
      await FirebaseAuth.instance.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}
