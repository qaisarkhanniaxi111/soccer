import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {
  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String selectedCountry = 'Country';
  String selectedCity = 'City';
  String selectedLeague = 'League';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCountry,
              onChanged: (newValue) {
                setState(() {
                  selectedCountry = newValue!;
                });
              },
              items: <String>['Country', 'Country A', 'Country B', 'Country C']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCity,
              onChanged: (newValue) {
                setState(() {
                  selectedCity = newValue!;
                });
              },
              items: <String>['City', 'City X', 'City Y', 'City Z']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedLeague,
              onChanged: (newValue) {
                setState(() {
                  selectedLeague = newValue!;
                });
              },
              items: <String>['League', 'League 1', 'League 2', 'League 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Perform actions based on the selected values
                print('Selected Country: $selectedCountry');
                print('Selected City: $selectedCity');
                print('Selected League: $selectedLeague');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
