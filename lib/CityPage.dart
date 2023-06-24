import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CityPage extends StatefulWidget {
  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  CollectionReference citiesCollection =
      FirebaseFirestore.instance.collection('cities');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cities'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: citiesCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<City> cities = snapshot.data!.docs.map((doc) {
              return City(
                id: doc.id,
                name: doc['name'] as String,
                country: doc['country'] as String,
                cityImage: doc['cityImage'] as String,
              );
            }).toList();

            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(city.cityImage),
                      ),
                      title: Text(
                        city.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(city.country),
                      onTap: () {
                        _editCity(index, city);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCity();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editCity(int index, City city) async {
    final editedCity = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCityPage(city: city),
      ),
    );

    if (editedCity != null) {
      citiesCollection.doc(city.id).update({
        'name': editedCity.name,
        'country': editedCity.country,
        'cityImage': editedCity.cityImage,
      });
    }
  }

  void _addCity() async {
    final newCity = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCityPage(city: null),
      ),
    );

    if (newCity != null) {
      DocumentReference docRef = await citiesCollection.add({
        'name': newCity.name,
        'country': newCity.country,
        'cityImage': '',
      });

      if (newCity.cityImage.isNotEmpty) {
        String imageUrl = await _uploadImage(newCity.cityImage, docRef.id);
        await docRef.update({'cityImage': imageUrl});
      }
    }
  }

  Future<String> _uploadImage(String imagePath, String fileName) async {
    File file = File(imagePath);
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/$fileName');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(file);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}

class City {
  final String id;
  final String name;
  final String country;
  final String cityImage;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.cityImage,
  });
}

class EditCityPage extends StatefulWidget {
  final City? city;

  EditCityPage({this.city});

  @override
  _EditCityPageState createState() => _EditCityPageState();
}

class _EditCityPageState extends State<EditCityPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.city != null) {
      _nameController.text = widget.city!.name;
      _countryController.text = widget.city!.country;
      _selectedImage = widget.city!.cityImage;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city != null ? 'Edit City' : 'Add City'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'City Name',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'Country',
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Select Picture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _selectImage();
                },
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    width: double.infinity,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _selectedImage != null
                            ? Image.file(
                                File(_selectedImage!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Icon(Icons.image),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final editedCity = City(
                      id: widget.city != null ? widget.city!.id : '',
                      name: _nameController.text,
                      country: _countryController.text,
                      cityImage: _selectedImage ?? '',
                    );

                    Navigator.pop(context, editedCity);
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
