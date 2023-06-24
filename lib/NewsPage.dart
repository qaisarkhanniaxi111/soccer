import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  final List<Article> articles = [
    Article(
      title: 'Breaking News',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      imagePath: '',
    ),
    Article(
      title: 'Sports Update',
      description:
          'Nulla facilisi. In ac pretium velit. Curabitur finibus enim sed.',
      imagePath: '',
    ),
    Article(
      title: 'Technology Trends',
      description:
          'Sed tincidunt turpis a bibendum gravida. Donec malesuada eleifend diam.',
      imagePath: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            leading: Image.asset(
              article.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text(article.title),
            subtitle: Text(article.description),
            onTap: () {
              // Handle tapping on the article
            },
          );
        },
      ),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String imagePath;

  Article(
      {required this.title,
      required this.description,
      required this.imagePath});
}
