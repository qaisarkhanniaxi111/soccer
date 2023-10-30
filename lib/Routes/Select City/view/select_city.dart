import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soccer_life/Routes/Settings/view/settings.dart';
import 'package:soccer_life/modals/global_widgets.dart';

import '../../Profile/view/profile.dart';

class SelectCity extends StatelessWidget {
  SelectCity({super.key});

  //Variables For Cities Info
  String? cityName;
  String? cityDescription;
  String? cityImage;

  //Firebase Instances
  final firestore = FirebaseFirestore.instance;




  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select City',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        toolbarHeight: 80,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 00, bottom: 5),
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('Cities').snapshots(),
            builder: (context, snapshot) {
              List<CityCard> cities = [];
              if (snapshot.hasData) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ));
                }else{
                  dynamic data = snapshot.data?.docs;
                  for (var dataOfSnapshots in data) {

                    cityName = dataOfSnapshots.data()['City Name'];
                    cityDescription = dataOfSnapshots.data()['City Description'];
                    cityImage = dataOfSnapshots.data()['City Image'];

                    cities.add(
                        CityCard(
                          cityName: '$cityName',
                          cityImage: '$cityImage',
                          cityDescription: '$cityDescription',
                          onTap: () async {
                            Get.offAllNamed('/CustomNavigationBar');
                            await firestore.collection('Users').doc(Profile.profileEmail)
                                .update({'City': dataOfSnapshots.data()['City Name']});
                          },
                        ));
                  }
                }
              }else{
                return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ));
              }
              return ListView(
                    children: cities,
                  );
            })
      ),
    );
  }
}
