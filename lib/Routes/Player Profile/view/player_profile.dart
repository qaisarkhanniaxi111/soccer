import 'package:flutter/material.dart';
import 'package:soccer_life/modals/constants.dart';
import '../../../../../modals/global_widgets.dart';

class PlayerProfile extends StatelessWidget {
  const PlayerProfile({super.key});

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Player Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        toolbarHeight: 80,
        backgroundColor: Colors.grey.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0,bottom: 20),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 42),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('images/ProfileGreen.png')),
                    ),
                    child: Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Lionel Messi',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Kingston Soccer Time',
                            style: TextStyle(color: kTextColor,fontSize: 13),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CardText(text: '5', text2: 'Games'),
                              CardText(text: '17', text2: 'Wins'),
                              CardText(text: '5', text2: 'Pending'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    heightFactor: 0.0,
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                          Border.all(color: Colors.grey.shade50, width: 4)),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/messi.jpeg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Text('Games Played',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
            SizedBox(height: 10,),
            ProfileDetails(
                text0: 'This Week',
                number0: '5',
                text1: 'August',
                number1: '17',
                text2: '2023',
                number2: '7',
                text3: 'All Time',
                number3: '9'),
            SizedBox(height: 20,),
            Text('Previous Games',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
            SizedBox(height: 10,),
            ProfileDetails(
                text0: 'Last Week',
                number0: '5',
                text1: 'July',
                number1: '17',
                text2: '2022',
                number2: '7',
                text3: 'Win',
                number3: '3'),
            SizedBox(height: 20,),
            Text('Lionel Messi Games',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            Divider(indent: 100,endIndent: 100,color: kNumberColor,thickness: 2,height: 0,),
            SizedBox(height: 20),
            // SportsCard(),
            // SportsCard(),
            // SportsCard(),
          ],

        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final String text0;
  final String number0;
  final String text1;
  final String number1;
  final String text2;
  final String number2;
  final String text3;
  final String number3;

  const ProfileDetails({
    super.key,
    required this.text0,
    required this.number0,
    required this.text1,
    required this.number1,
    required this.text2,
    required this.number2,
    required this.text3,
    required this.number3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GameDetailText(text: number0, text2: text0),
        GameDetailText(text: number1, text2: text1),
        GameDetailText(text: number2, text2: text2),
        GameDetailText(text: number3, text2: text3)
      ],
    );
  }
}

class CardText extends StatelessWidget {
  final String text;
  final String text2;

  const CardText({
    super.key,
    required this.text,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$text', style: TextStyle(fontSize: 13, color: kNumberColor, fontWeight: FontWeight.bold),),
        Text('$text2', style: TextStyle(fontSize: 11, color: kTextColor))
      ],
    );
  }
}

class GameDetailText extends StatelessWidget {
  final String text;
  final String text2;

  const GameDetailText({
    super.key,
    required this.text,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$text',
          style: TextStyle(
              fontSize: 13, color: kNumberColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.2),
        Text('$text2',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500))
      ],
    );
  }
}
