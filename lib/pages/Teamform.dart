import 'package:flutter/material.dart';

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  List<Team> teams = [
    Team(
      name: 'Team A',
      captain: 'John Doe',
      logoPath: 'assets/images/team_a_logo.png',
    ),
    Team(
      name: 'Team B',
      captain: 'Jane Smith',
      logoPath: 'assets/images/team_b_logo.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
      ),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(team.logoPath),
            ),
            title: Text(team.name),
            subtitle: Text('Captain: ${team.captain}'),
            onTap: () {
              _editTeam(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTeam();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editTeam(int index) async {
    final editedTeam = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTeamPage(team: teams[index]),
      ),
    );

    if (editedTeam != null) {
      setState(() {
        teams[index] = editedTeam;
      });
    }
  }

  void _addTeam() async {
    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTeamPage(),
      ),
    );

    if (newTeam != null) {
      setState(() {
        teams.add(newTeam);
      });
    }
  }
}

class Team {
  final String name;
  final String captain;
  final String logoPath;

  Team({
    required this.name,
    required this.captain,
    required this.logoPath,
  });
}

class EditTeamPage extends StatefulWidget {
  final Team? team;

  EditTeamPage({this.team});

  @override
  _EditTeamPageState createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _captainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.team != null) {
      _nameController.text = widget.team!.name;
      _captainController.text = widget.team!.captain;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _captainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team != null ? 'Edit Team' : 'Add Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Team Name',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _captainController,
              decoration: InputDecoration(
                labelText: 'Captain',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final editedTeam = Team(
                  name: _nameController.text,
                  captain: _captainController.text,
                  logoPath: '',
                );

                Navigator.pop(context, editedTeam);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
