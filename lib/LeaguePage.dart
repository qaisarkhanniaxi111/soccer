import 'package:flutter/material.dart';

class LeaguePage extends StatefulWidget {
  @override
  _LeaguePageState createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage> {
  List<League> leagues = [
    League(
      name: 'Premier League',
      country: 'England',
      logoPath: 'assets/images/premier_league_logo.png',
    ),
    League(
      name: 'La Liga',
      country: 'Spain',
      logoPath: 'assets/images/la_liga_logo.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leagues'),
      ),
      body: ListView.builder(
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          final league = leagues[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(league.logoPath),
            ),
            title: Text(league.name),
            subtitle: Text(league.country),
            onTap: () {
              _editLeague(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addLeague();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editLeague(int index) async {
    final editedLeague = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLeaguePage(league: leagues[index]),
      ),
    );

    if (editedLeague != null) {
      setState(() {
        leagues[index] = editedLeague;
      });
    }
  }

  void _addLeague() async {
    final newLeague = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLeaguePage(),
      ),
    );

    if (newLeague != null) {
      setState(() {
        leagues.add(newLeague);
      });
    }
  }
}

class League {
  final String name;
  final String country;
  final String logoPath;

  League({
    required this.name,
    required this.country,
    required this.logoPath,
  });
}

class EditLeaguePage extends StatefulWidget {
  final League? league;

  EditLeaguePage({this.league});

  @override
  _EditLeaguePageState createState() => _EditLeaguePageState();
}

class _EditLeaguePageState extends State<EditLeaguePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.league != null) {
      _nameController.text = widget.league!.name;
      _countryController.text = widget.league!.country;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league != null ? 'Edit League' : 'Add League'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'League Name',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final editedLeague = League(
                  name: _nameController.text,
                  country: _countryController.text,
                  logoPath: '',
                );

                Navigator.pop(context, editedLeague);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
