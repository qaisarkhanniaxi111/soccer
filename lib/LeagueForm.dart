import 'package:flutter/material.dart';

class InputFields extends StatefulWidget {
  @override
  _InputFieldsState createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _leagueNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _seasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Fields'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _leagueNameController,
                  decoration: InputDecoration(
                    labelText: 'League Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a league name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'Country',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a country';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _seasonController,
                  decoration: InputDecoration(
                    labelText: 'Season',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a season';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String leagueName = _leagueNameController.text;
                      String country = _countryController.text;
                      String season = _seasonController.text;

                      // Process the input data as needed
                      print('League Name: $leagueName');
                      print('Country: $country');
                      print('Season: $season');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InputFields(),
  ));
}
