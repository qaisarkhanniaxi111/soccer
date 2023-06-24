import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizerAccessScreen extends StatefulWidget {
  @override
  _OrganizerAccessScreenState createState() => _OrganizerAccessScreenState();
}

class _OrganizerAccessScreenState extends State<OrganizerAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizer Access'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            'Organizers List',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: _buildOrganizersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('organizers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.docs.isEmpty) {
          return Text('No organizers available');
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return ListTile(
              title: Text(document['name']),
              subtitle: Text(document['email']),
              trailing: _buildAccessToggle(document),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAccessToggle(DocumentSnapshot document) {
    bool hasAccess = document['hasAccess'];

    return Switch(
      value: hasAccess,
      onChanged: (value) {
        _updateOrganizerAccess(document.id, value);
      },
    );
  }

  void _updateOrganizerAccess(String organizerId, bool hasAccess) async {
    await FirebaseFirestore.instance
        .collection('organizers')
        .doc(organizerId)
        .update({'hasAccess': hasAccess});
  }
}
