import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../modals/constants.dart';

class CompletedGames extends StatelessWidget {
  CompletedGames({super.key});

  //Firebase Instance
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Divider(
                indent: 16,
                endIndent: 16,
                thickness: 2,
              )),
          title: Text('Completed Games')),
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: StreamBuilder(
            stream: firestore.collection('Completed Games').snapshots(),
            builder: (context, snapshot) {
              List<CompletedGamesCard> completedGamesList = [];
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(child: CircularProgressIndicator());
                } else {
                  dynamic data = snapshot.data?.docs;
                  for (var dataOfSnapshots in data) {
                    completedGamesList.add(
                        CompletedGamesCard(
                        photo: dataOfSnapshots.data()['Match Image'],
                        name: dataOfSnapshots.data()['Match Name'],
                        date: dataOfSnapshots.data()['Date'],
                        matchFee: dataOfSnapshots.data()['Match Fee'],
                        organizedBy: dataOfSnapshots.data()['Added By']));
                  }
                }
              } else {
                Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: completedGamesList,
              );
            }),
      ),
    );
  }
}

class CompletedGamesCard extends StatelessWidget {
  const CompletedGamesCard({
    super.key,
    required this.photo,
    required this.name,
    required this.date,
    required this.matchFee,
    required this.organizedBy,
  });

  final String photo;
  final String name;
  final String date;
  final String matchFee;
  final String organizedBy;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      elevation: 1,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.15,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: kBorderRadius,
            border: Border.all(color: Colors.grey.shade300)),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 23.0, top: 10, bottom: 10),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 25),
                width: MediaQuery.sizeOf(context).width * 0.25,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage('$photo')),
                    borderRadius: kBorderRadius),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    child: Text(
                      '$name',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: 140,
                    child: Text(
                      'Date: $date',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: kNumberColor),
                    ),
                  ),
                  Container(
                    width: 140,
                    child: Text(
                      'Match Fee: \$$matchFee.00',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: kNumberColor),
                    ),
                  ),
                  Container(
                    width: 140,
                    child: Text(
                      'Organized By: $organizedBy',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: kNumberColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
