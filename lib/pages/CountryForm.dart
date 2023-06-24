import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List<Country> countries = [
    Country(
      name: 'United States',
      capital: 'Washington, D.C.',
      flagPath: 'assets/images/usa_flag.png',
    ),
    Country(
      name: 'United Kingdom',
      capital: 'London',
      flagPath: 'assets/images/uk_flag.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries'),
      ),
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(country.flagPath),
            ),
            title: Text(country.name),
            subtitle: Text('Capital: ${country.capital}'),
            onTap: () {
              _editCountry(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCountry();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editCountry(int index) async {
    final editedCountry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCountryPage(country: countries[index]),
      ),
    );

    if (editedCountry != null) {
      setState(() {
        countries[index] = editedCountry;
      });
    }
  }

  void _addCountry() async {
    final newCountry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCountryPage(),
      ),
    );

    if (newCountry != null) {
      setState(() {
        countries.add(newCountry);
      });
    }
  }
}

class Country {
  final String name;
  final String capital;
  final String flagPath;

  Country({
    required this.name,
    required this.capital,
    required this.flagPath,
  });
}

class EditCountryPage extends StatefulWidget {
  final Country? country;

  EditCountryPage({this.country});

  @override
  _EditCountryPageState createState() => _EditCountryPageState();
}

class _EditCountryPageState extends State<EditCountryPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _capitalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.country != null) {
      _nameController.text = widget.country!.name;
      _capitalController.text = widget.country!.capital;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country != null ? 'Edit Country' : 'Add Country'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Country Name',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _capitalController,
              decoration: InputDecoration(
                labelText: 'Capital',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final editedCountry = Country(
                  name: _nameController.text,
                  capital: _capitalController.text,
                  flagPath: '',
                );

                Navigator.pop(context, editedCountry);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
