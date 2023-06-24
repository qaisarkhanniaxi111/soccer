import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizerRequestsPage extends StatefulWidget {
  @override
  _OrganizerRequestsPageState createState() => _OrganizerRequestsPageState();
}

class _OrganizerRequestsPageState extends State<OrganizerRequestsPage> {
  late Stream<QuerySnapshot> _requestsStream;

  @override
  void initState() {
    super.initState();
    _requestsStream = FirebaseFirestore.instance
        .collection('Users')
        .where('isOrganizerRequest', isEqualTo: true)
        .snapshots();
  }

  void _approveOrganizerRequest(String userId) async {
    // Mark the user as an organizer in the 'Users' collection
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({'isOrganizer': true, 'isOrganizerRequest': false});

    // Show a success message or update the UI to reflect the change
    // ...
  }

  void _denyOrganizerRequest(String userId) async {
    // Remove the organizer request field from the user's data
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({'isOrganizerRequest': false});

    // Show a success message or update the UI to reflect the change
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizer Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _requestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final requests = snapshot.data!.docs;
            if (requests.isEmpty) {
              return Center(
                child: Text('No organizer requests'),
              );
            }
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final userId = request.id;
                final userName = request[
                    'firstname']; // Change this to the field that holds the user's name
                return ListTile(
                  title: Text(userName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () => _approveOrganizerRequest(userId),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => _denyOrganizerRequest(userId),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
