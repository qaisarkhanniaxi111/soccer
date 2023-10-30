import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_life/Routes/Game%20Details/view/game_details.dart';
import 'package:soccer_life/Routes/Profile/view/profile.dart';
import 'package:soccer_life/modals/constants.dart';
import 'dart:io' show Platform;

import '../../../modals/global_widgets.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({
    super.key,
    this.matchHostName,
    this.matchHostEmail,
    this.chatRoom,
    this.matchHostPhoto,
    this.chatterEmail,
  });

  final String? matchHostName;
  final String? matchHostEmail;
  final String? matchHostPhoto;
  final String? chatRoom;
  final String? chatterEmail;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  //TextField Controllers
  TextEditingController messageController = TextEditingController();

//Firebase Instance
  final firestore = FirebaseFirestore.instance;


  void addMessage() async {
    print('Firebase Begin');

    if (messageController.text != null) {
      //Send Message
      print('Sending Message');
      await firestore
          .collection('Chat')
          .doc(widget.chatRoom)
          .collection('Messages')
          .add({
        'Message': messageController.text.trim(),
        'Sent By': Profile.profileName,
        'Email': Profile.profileEmail,
        'Time Stamp': FieldValue.serverTimestamp()
      });

      //Create New Conversation
      if (!await doesChatRoomExists(widget.chatRoom)) {
        print('Creating New Conversations1');
        await firestore
            .collection('Users')
            .doc(Profile.profileEmail)
            .collection('Conversations')
            .doc(widget.chatRoom)
            .set({
          'Chatter Name': widget.matchHostName,
          'Chatter Photo': widget.matchHostPhoto,
          'Chatter Email': widget.matchHostEmail,
          'Room Id': widget.chatRoom,
          'Host Email': widget.matchHostEmail
        });
        await firestore
            .collection('Users')
            .doc(widget.matchHostEmail)
            .collection('Conversations')
            .doc(widget.chatRoom)
            .set({
          'Chatter Name': Profile.profileName,
          'Chatter Photo': Profile.profilePhoto,
          'Chatter Email': Profile.profileEmail,
          'Room Id': widget.chatRoom,
          'Host Email': widget.matchHostEmail
        });
      }
      //Last Message

      ///////////// CHECK LAST MESSAGE ///////////////
      print('Setting Last Message');
      await firestore
          .collection('Users')
          .doc(Profile.profileEmail)
          .collection('Conversations')
          .doc(widget.chatRoom)
          .update({'Last Message': messageController.text.trim()});

      await firestore
          .collection('Users')
          .doc(widget.matchHostEmail)
          .collection('Conversations')
          .doc(widget.chatRoom)
          .update({'Last Message': messageController.text.trim()});
      messageController.clear();
    }
  }

  Future<bool> doesChatRoomExists(String? chatRoom) async {
    final QuerySnapshot result = await firestore
        .collection('Users')
        .doc(Profile.profileEmail)
        .collection('Conversations')
        .where(
          'Room Id',
          isEqualTo: chatRoom,
        )
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        onClosing: (){},
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height / 11,
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.shade400)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    //WhatsApp Like Text Field
                    child: TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        hintText: 'Type Message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  VerticalDivider(thickness: 2, indent: 10, endIndent: 10,color: Colors.grey,),
                  CircleAvatar(
                    backgroundColor: kGreenColor,
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowRight),
                      color: Colors.white,
                      onPressed: () {
                        addMessage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 00, top: 0, bottom: 00, right: 10),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.aspectRatio * 65.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage('${widget.matchHostPhoto}'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text('${widget.matchHostName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: firestore.collection('Users').doc(widget.chatterEmail).snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            print('Has Data');
                            if(snapshot.connectionState == ConnectionState.waiting){
                              print('Waiting');
                              return Row(
                                children: [
                                  Text(
                                    'Offline',
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                      Icons.fiber_manual_record,
                                      size: 18,
                                      color: Colors.grey.shade400
                                  )
                                ],
                              );
                            }else{
                              print('Has Data Not Waiting');
                              return Row(
                                children: [
                                  Text(
                                    snapshot.data!['Status'],
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                      Icons.fiber_manual_record,
                                      color: snapshot.data!['Status'] == 'Online'
                                          ? kGreenColor
                                          : Colors.grey.shade400,
                                      size: 18
                                  )
                                ],
                              );
                            }
                          }else{
                            print('Has No Data');
                            return Row(
                              children: [
                                Text(
                                  'Offline',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 15),
                                ),
                                Icon(
                                    Icons.fiber_manual_record,
                                    size: 18,
                                  color: Colors.grey.shade400
                                )
                              ],
                            );
                          }
                        })
                  ),
                ],
              ),
            ],
          ),
          leadingWidth: Platform.isIOS ? 40 : 0,
          leading: Platform.isIOS
              ? InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.black,
                    ),
                  ),
                )
              : null,
          toolbarHeight: 100,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 00),
        child: StreamBuilder(
            stream: firestore
                .collection('Chat')
                .doc(widget.chatRoom)
                .collection('Messages')
                .orderBy('Time Stamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {

              List<MessageBubble> messageBubbles = [];

              if (snapshot.hasData) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                      child: Text('Start A New Chat',
                          style: TextStyle(color: Colors.grey.shade500)));
                }else{
                  //Working
                  dynamic data = snapshot.data?.docs;
                  for (var dataOfSnapshots in data) {
                    messageBubbles.add(MessageBubble(
                      sentBy: dataOfSnapshots.data()['Sent By'],
                      message: dataOfSnapshots.data()['Message'],
                      email: dataOfSnapshots.data()['Email'],
                    ));

                  }
                }
                print('Has No Data');
              } else {
                return Center(
                    child: Text('Start A New Chat',
                        style: TextStyle(color: Colors.grey.shade500)));
              }
              return ListView(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  children: messageBubbles);
            }),
      ),
    );
  }
}
