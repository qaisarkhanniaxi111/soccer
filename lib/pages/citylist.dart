import 'package:flutter/material.dart';
import 'package:soccer/pages/drawer.dart';

class City {
  final String cityPicture;
  final String cityName;
  final String countryName;

  City({required this.cityPicture, required this.cityName, required this.countryName});
}

class CityListPage extends StatelessWidget {
  final List<City> cities = [
    City(cityPicture: 'assets/cities/newjersey.jpg', cityName: 'New Jersey', countryName: 'United States'),
    City(cityPicture: 'assets/cities/newyork.jpg', cityName: 'New York', countryName: 'United States'),
    City(cityPicture: 'assets/cities/washington.jpg', cityName: 'Washington', countryName: 'United States'),
    City(cityPicture: 'assets/cities/washington.jpg', cityName: 'Washington', countryName: 'United States'),
    City(cityPicture: 'assets/cities/washington.jpg', cityName: 'Washington', countryName: 'United States'),
    City(cityPicture: 'assets/cities/washington.jpg', cityName: 'Washington', countryName: 'United States'),
    City(cityPicture: 'assets/cities/washington.jpg', cityName: 'Washington', countryName: 'United States'),
    // Add more cities as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a City'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          childAspectRatio: 1.0, // Aspect ratio of each grid item
        ),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle item tap
            },
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                        image: DecorationImage(
                          image: AssetImage(cities[index].cityPicture),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cities[index].cityName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          cities[index].countryName,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer:new Drawer()
    );
  }
}

