import 'package:flutter/material.dart';

class StandingsPage extends StatelessWidget {
  final List<Team> teams = [
    Team(name: 'Team A', wins: 10, losses: 2),
    Team(name: 'Team B', wins: 8, losses: 4),
    Team(name: 'Team C', wins: 6, losses: 6),
    Team(name: 'Team D', wins: 4, losses: 8),
    Team(name: 'Team E', wins: 2, losses: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Standings'),
      ),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return ListTile(
            title: Text('${index + 1}. ${team.name}'),
            subtitle: Text('Wins: ${team.wins} | Losses: ${team.losses}'),
          );
        },
      ),
    );
  }
}

class Team {
  final String name;
  final int wins;
  final int losses;

  Team({required this.name, required this.wins, required this.losses});
}
