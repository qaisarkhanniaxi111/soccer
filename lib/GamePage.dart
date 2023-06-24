import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateGamesScreen extends StatefulWidget {
  @override
  _CreateGamesScreenState createState() => _CreateGamesScreenState();
}

class _CreateGamesScreenState extends State<CreateGamesScreen> {
  TextEditingController _gameNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _gameNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _gameNameController,
                      decoration: InputDecoration(labelText: 'Game Name'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _showCreateGameDialog();
                      },
                      child: Text('Create'),
                    ),
                    SizedBox(height: 16.0),
                    _buildGameList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateGameDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGameList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('games').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.docs.isEmpty) {
          return Text('No games available');
        }

        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return ListTile(
              title: Text(document['gameName']),
              subtitle: Text(document['location']),
              onTap: () {
                _showUpdateGameDialog(document);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showCreateGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Game'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _gameNameController,
                  decoration: InputDecoration(labelText: 'Game Name'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _createGame();
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateGameDialog(DocumentSnapshot document) {
    _gameNameController.text = document['gameName'];
    _locationController.text = document['location'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Game'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _gameNameController,
                  decoration: InputDecoration(labelText: 'Game Name'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateGame(document.id);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _createGame() async {
    String gameName = _gameNameController.text;
    String location = _locationController.text;

    // Save the game data to Firebase Firestore
    await FirebaseFirestore.instance.collection('games').add({
      'gameName': gameName,
      'location': location,
    });

    // Clear the input fields after creating the game
    _gameNameController.clear();
    _locationController.clear();
  }

  void _updateGame(String gameId) async {
    String gameName = _gameNameController.text;
    String location = _locationController.text;

    // Update the game data in Firebase Firestore
    await FirebaseFirestore.instance.collection('games').doc(gameId).update({
      'gameName': gameName,
      'location': location,
    });
  }
}
