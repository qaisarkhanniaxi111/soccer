import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizerPage extends StatefulWidget {
  @override
  _OrganizerPageState createState() => _OrganizerPageState();
}

class _OrganizerPageState extends State<OrganizerPage> {
  String? selectedGame;
  String? selectedPlayer;
  TextEditingController scoreController = TextEditingController();
  TextEditingController assistsController = TextEditingController();

  List<String> availableGames = [];
  List<String> availablePlayers = [];

  void initState() {
    super.initState();
    fetchGames();
  }

  void fetchGames() async {
    var gamesSnapshot =
        await FirebaseFirestore.instance.collection('games').get();
    setState(() {
      availableGames = gamesSnapshot.docs
          .map((doc) => doc['gameName'])
          .toList()
          .cast<String>();
    });
  }

  void fetchPlayers() async {
    var playersSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      availablePlayers = playersSnapshot.docs
          .map((doc) => doc['firstname'])
          .toList()
          .cast<String>();
      selectedPlayer = availablePlayers.isNotEmpty ? availablePlayers[0] : null;
    });
  }

  void submitScoreAndAssists() {
    // Implement your logic to submit the score and assists here
    String playerName = selectedPlayer ?? '';
    int score = int.tryParse(scoreController.text) ?? 0;
    String assists = assistsController.text;

    // Display a confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Score and Assists Submitted'),
          content:
              Text('Score: $score\nPlayer: $playerName\nAssists: $assists'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizer Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Game:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: selectedGame,
              hint: Text('Select Game'),
              items: availableGames.map((game) {
                return DropdownMenuItem<String>(
                  value: game,
                  child: Text(game),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedGame = value;
                  fetchPlayers(); // Fetch players when game is selected
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Select Player:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: selectedPlayer,
              hint: Text('Select Player'),
              items: availablePlayers.map((player) {
                return DropdownMenuItem<String>(
                  value: player,
                  child: Text(player),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedPlayer = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Score',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: assistsController,
              decoration: InputDecoration(
                labelText: 'Assists',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (selectedGame != null &&
                    selectedPlayer != null &&
                    scoreController.text.isNotEmpty) {
                  submitScoreAndAssists();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please fill all required fields.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Submit Score and Assists'),
            ),
          ],
        ),
      ),
    );
  }
}
