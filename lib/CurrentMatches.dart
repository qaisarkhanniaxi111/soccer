import 'package:flutter/material.dart';

class CurrentMatchesPage extends StatelessWidget {
  final List<Match> matches = [
    Match(
      teamA: 'Team A',
      teamB: 'Team B',
      startTime: DateTime.now(),
      location: 'Stadium X',
    ),
    Match(
      teamA: 'Team C',
      teamB: 'Team D',
      startTime: DateTime.now(),
      location: 'Stadium Y',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Matches'),
      ),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return ListTile(
            title: Text('${match.teamA} vs ${match.teamB}'),
            subtitle: Text(
                'Start Time: ${match.startTime} | Location: ${match.location}'),
            onTap: () {
              _showMatchDetails(context, match);
            },
          );
        },
      ),
    );
  }

  void _showMatchDetails(BuildContext context, Match match) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${match.teamA} vs ${match.teamB}'),
          content: Text(
              'Start Time: ${match.startTime}\nLocation: ${match.location}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class Match {
  final String teamA;
  final String teamB;
  final DateTime startTime;
  final String location;

  Match(
      {required this.teamA,
      required this.teamB,
      required this.startTime,
      required this.location});
}
