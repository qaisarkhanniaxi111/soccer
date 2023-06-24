import 'package:flutter/material.dart';

class ProcessingPaymentPage extends StatelessWidget {
  final Game game;

  ProcessingPaymentPage({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Processing Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              game.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Location: ${game.location}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Payment Amount: \$${game.paymentAmount}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform the actual payment processing logic
                // For example: integrate with a payment gateway or update the payment status in the database
                // Once the payment is processed, navigate back to the admin panel
                Navigator.pop(context);
              },
              child: Text('Process Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class Game {
  final int id;
  final String title;
  final String location;
  final List<String> attributes;

  Game({
    required this.id,
    required this.title,
    required this.location,
    required this.attributes,
  });

  get paymentAmount => null;
}
