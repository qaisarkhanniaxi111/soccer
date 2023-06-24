import 'package:flutter/material.dart';

class PlayersPage extends StatefulWidget {
  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  List<Player> players = [
    Player(
      name: 'Lionel Messi',
      age: 34,
      position: 'Forward',
      image: 'assets/images/lionel_messi.jpg',
    ),
    Player(
      name: 'Cristiano Ronaldo',
      age: 36,
      position: 'Forward',
      image: 'assets/images/cristiano_ronaldo.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(player.image),
            ),
            title: Text(player.name),
            subtitle: Text('Age: ${player.age} | Position: ${player.position}'),
            onTap: () {
              _editPlayer(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPlayer();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editPlayer(int index) async {
    final editedPlayer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlayerPage(player: players[index]),
      ),
    );

    if (editedPlayer != null) {
      setState(() {
        players[index] = editedPlayer;
      });
    }
  }

  void _addPlayer() async {
    final newPlayer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlayerPage(),
      ),
    );

    if (newPlayer != null) {
      setState(() {
        players.add(newPlayer);
      });
    }
  }
}

class Player {
  final String name;
  final int age;
  final String position;
  final String image;

  Player({
    required this.name,
    required this.age,
    required this.position,
    required this.image,
  });
}

class EditPlayerPage extends StatefulWidget {
  final Player? player;

  EditPlayerPage({this.player});

  @override
  _EditPlayerPageState createState() => _EditPlayerPageState();
}

class _EditPlayerPageState extends State<EditPlayerPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _positionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.player != null) {
      _nameController.text = widget.player!.name;
      _ageController.text = widget.player!.age.toString();
      _positionController.text = widget.player!.position;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player != null ? 'Edit Player' : 'Add Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Player Name',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _positionController,
              decoration: InputDecoration(
                labelText: 'Position',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final editedPlayer = Player(
                  name: _nameController.text,
                  age: int.parse(_ageController.text),
                  position: _positionController.text,
                  image: '',
                );

                Navigator.pop(context, editedPlayer);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
