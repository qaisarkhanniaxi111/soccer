import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MatchesPage extends StatefulWidget {
  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  List<Match> matches = [];
  List<String> gameList = []; // List to store the game names

  @override
  void initState() {
    super.initState();
    // Load the games from Firebase when the page is initialized
    _loadGames();
  }

  // Function to load the games from Firebase
  Future<void> _loadGames() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('games').get();
      setState(() {
        gameList =
            snapshot.docs.map((doc) => doc['gameName'] as String).toList();
      });
    } catch (e) {
      print('Error loading games: $e');
    }
  }

  // Function to add a new match
  void addMatch(Match match) {
    setState(() {
      matches.add(match);
    });
  }

  // Function to open image picker dialog
  Future<void> _openImagePicker() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    // Process the selected image here
    // ...
  }

  // Function to save match data to Firebase
  void _addMatchToFirebase(Match match) async {
    try {
      await FirebaseFirestore.instance.collection('matches').add(match.toMap());
      // Show a success message or update the UI to reflect the change
      // ...
    } catch (e) {
      // Handle any errors that occurred during saving data to Firebase
      print('Error saving match data: $e');
      // Show an error message or handle the error
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return ListTile(
                title: Text('Match ${index + 1}'),
                subtitle: Text('Date: ${match.date}, Time: ${match.time}'),
                leading: CircleAvatar(
                  backgroundImage: match.image != null
                      ? AssetImage(match.image!)
                      : AssetImage('assets/default_image.png'),
                ),
                onTap: () {
                  // Open match details page
                  // ...
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddMatchDialog(
              onMatchAdded: addMatch,
              onMatchSubmitted: _addMatchToFirebase,
              gameList: gameList, // Pass the gameList to the dialog
            ),
          );
        },
      ),
    );
  }
}

class AddMatchDialog extends StatefulWidget {
  final Function(Match) onMatchAdded;
  final Function(Match) onMatchSubmitted;
  final List<String> gameList; // List of game names

  AddMatchDialog({
    required this.onMatchAdded,
    required this.onMatchSubmitted,
    required this.gameList,
  });

  @override
  _AddMatchDialogState createState() => _AddMatchDialogState();
}

class _AddMatchDialogState extends State<AddMatchDialog> {
  DateTime? selectedDate; // Updated to allow null values
  TimeOfDay? selectedTime; // Updated to allow null values
  String? selectedCity;
  String? selectedGender;
  String? selectedImage;
  String? selectedGame; // New property for the selected game
  int seatsOccupied = 0;
  int totalParticipants = 0;
  double fee = 0.0;
  String? place;
  String? title;

  // Function to open date picker
  Future<void> _openDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Function to open time picker
  Future<void> _openTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Function to open image picker dialog
  Future<void> _openImagePicker() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Match'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _openDatePicker,
              child: Text('Select Date'),
            ),
            SizedBox(height: 10),
            Text('Selected Date: ${selectedDate ?? "No date selected"}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openTimePicker,
              child: Text('Select Time'),
            ),
            SizedBox(height: 10),
            Text('Selected Time: ${selectedTime ?? "No time selected"}'),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'City'),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['Male', 'Female', 'Both'].map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                hintText: 'Select Gender',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openImagePicker,
              child: Text('Select Image'),
            ),
            SizedBox(height: 10),
            Text('Selected Image: ${selectedImage ?? "No image selected"}'),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedGame,
              items: widget.gameList.map((game) {
                return DropdownMenuItem<String>(
                  value: game,
                  child: Text(game),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGame = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Game',
                hintText: 'Select Game',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Seats Occupied'),
              onChanged: (value) {
                setState(() {
                  seatsOccupied = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Participants'),
              onChanged: (value) {
                setState(() {
                  totalParticipants = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Fee'),
              onChanged: (value) {
                setState(() {
                  fee = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Place'),
              onChanged: (value) {
                setState(() {
                  place = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final match = Match(
              date: selectedDate!,
              time: selectedTime!,
              city: selectedCity ?? '',
              gender: selectedGender ?? '',
              image: selectedImage,
              seatsOccupied: seatsOccupied,
              totalParticipants: totalParticipants,
              fee: fee,
              place: place ?? '',
              title: title ?? '',
              game: selectedGame ?? '', // Add the game property here
            );

            widget.onMatchAdded(match);
            widget.onMatchSubmitted(match); // Save data to Firebase
            Navigator.pop(context);
          },
          child: Text('Add Match'),
        ),
      ],
    );
  }
}

class Match {
  final DateTime date;
  final TimeOfDay time;
  final String city;
  final String gender;
  final String? image;
  final String game; // New property for the game name
  final int seatsOccupied;
  final int totalParticipants;
  final double fee;
  final String place;
  final String title;

  Match({
    required this.date,
    required this.time,
    required this.city,
    required this.gender,
    this.image,
    required this.game, // Include the game property in the constructor
    required this.seatsOccupied,
    required this.totalParticipants,
    required this.fee,
    required this.place,
    required this.title,
  });

  // Convert Match object to a Map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': '${time.hour}:${time.minute}',
      'city': city,
      'gender': gender,
      'image': image,
      'game': game, // Add the game property here
      'seatsOccupied': seatsOccupied,
      'totalParticipants': totalParticipants,
      'fee': fee,
      'place': place,
      'title': title,
    };
  }
}
