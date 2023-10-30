import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soccer_life/modals/constants.dart';
import 'package:soccer_life/modals/global_widgets.dart';

class OrganizerList extends StatelessWidget {
  OrganizerList({super.key});

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
          title: Text('Organizers List')),
      body: Padding(
          padding: EdgeInsets.only(top: 10, left: 50, right: 50),
          child: StreamBuilder(
              stream: firestore.collection('Organizers List').snapshots(),
              builder: (context, snapshot) {
                List<OrganizerCard> organizerList = [];
                if(snapshot.hasData){
                  if(snapshot.connectionState == ConnectionState.waiting){
                   Center(child: CircularProgressIndicator(),);
                  }else{
                    dynamic data = snapshot.data?.docs;
                    for(var dataOfSnapshots in data){

                      organizerList.add(
                          OrganizerCard(
                            name: dataOfSnapshots.data()['Player Name'],
                            photo: dataOfSnapshots.data()['Player Photo'],
                            games: dataOfSnapshots.data()['Organized Games'],
                          )
                      );
                    }
                  }
                }else{
                  Center(child: CircularProgressIndicator(),);
                }

                return ListView(
                  children: organizerList,
                );
          })),
    );
  }
}

class OrganizerCard extends StatelessWidget {
  const OrganizerCard({
    super.key, required this.name, required this.photo, required this.games,
  });

  final String name;
  final String photo;
  final int games;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
                radius: 35, backgroundImage: NetworkImage('$photo')),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Text('$name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis))),
                SizedBox(height: MediaQuery.sizeOf(context).height / 55),
                Text('Total Games: $games'),
              ],
            ),
          ],
        ),
        Divider(
          thickness: 1.5,
          height: 30,
        ),
      ],
    );
  }
}
