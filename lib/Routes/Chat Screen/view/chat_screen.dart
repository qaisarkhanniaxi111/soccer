import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soccer_life/Routes/Message%20Screen/view/message_screen.dart';
import 'package:soccer_life/modals/constants.dart';

import '../../../modals/global_widgets.dart';
import '../../Profile/view/profile.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestore = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();

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
          title: Text('Messages')
        ),
        body: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 10, bottom: 10),
            child: StreamBuilder(
                stream: firestore
                    .collection('Users')
                    .doc(Profile.profileEmail)
                    .collection('Conversations')
                    .snapshots(),
                builder: (context, snapshot) {
                  List<MessageCard> conversationsList = [];

                  if (snapshot.hasData) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }else{
                      print('Conversations');
                      dynamic data = snapshot.data?.docs;

                      for (var dataOfSnapshots in data) {
                        print('Creating Message Card');

                        print(dataOfSnapshots.data()['Room Id']);

                        conversationsList.add(MessageCard(
                            name: dataOfSnapshots.data()['Chatter Name'],
                            chatRoom: dataOfSnapshots.data()['Room Id'],
                            hostPhoto: dataOfSnapshots.data()['Chatter Photo'],
                            hostEmail: dataOfSnapshots.data()['Host Email'],
                            lastMessage: dataOfSnapshots.data()['Last Message'],
                            chatterEmail:
                            dataOfSnapshots.data()['Chatter Email']));
                      }
                    }
                  } else {
                    return Center(child: Text('No Messages'));
                  }


                  return  conversationsList.isEmpty ? Text("No New Messages"):ListView(
                    physics: BouncingScrollPhysics(),
                    children: conversationsList,
                  );
                })));
  }
}

class MessageCard extends StatelessWidget {
  MessageCard(
      {super.key,
      required this.name,
      this.chatRoom,
      required this.hostPhoto,
      this.lastMessage,
      required this.hostEmail,
      this.chatterEmail});

  final String name;
  final String? chatRoom;
  final String hostPhoto;
  final String? lastMessage;
  final String hostEmail;
  final String? chatterEmail;

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => MessageScreen(
            matchHostName: name,
            chatRoom: chatRoom,
            matchHostPhoto: hostPhoto,
            matchHostEmail: hostEmail,
            chatterEmail: chatterEmail,
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage('${hostPhoto}'),
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      '$name',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      '$lastMessage',
                      style: TextStyle(color: Colors.grey.shade500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 35,
                width: MediaQuery.of(context).size.width / 15,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: firestore
                        .collection('Users')
                        .doc(chatterEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Icon(Icons.fiber_manual_record,
                              color: Colors.grey.shade400, size: 18);
                        }else{
                          print('Chat Online');
                          return Icon(Icons.fiber_manual_record,
                              color: snapshot.data!['Status'] == 'Online'
                                  ? kGreenColor
                                  : Colors.grey.shade400,
                              size: 18);
                        }
                      } else {
                        print('Chat Offline');
                        return Icon(Icons.fiber_manual_record,
                            color: Colors.grey.shade400, size: 18);
                      }
                    }),
              )
            ],
          ),
          Divider(
            height: 40,
            thickness: 2,
          )
        ],
      ),
    );
  }
}
