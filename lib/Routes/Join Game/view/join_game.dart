import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soccer_life/Routes/Game%20Details/view/game_details.dart';
import 'package:soccer_life/modals/constants.dart';
import 'package:http/http.dart' as http;

import '../../../modals/global_widgets.dart';
import '../../Profile/view/profile.dart';

class JoinGame extends StatelessWidget {
  JoinGame({super.key,
    this.matchName,
    this.matchImage,
    this.time,
    this.date,
    this.matchFee,
    this.profilePhoto,
    this.profileName});

  final String? matchName;
  final String? matchImage;
  final String? time;
  final String? date;
  final String? matchFee;
  final String? profilePhoto;
  final String? profileName;

  //Firebase Instance
  final firestore = FirebaseFirestore.instance;

  //Adding Data To Firebase
  addPlayerData() async {
    try {
      await firestore
          .collection('Matches')
          .doc(matchName)
          .collection('Players')
          .doc(Profile.profileEmail)
          .set({
        'Player Name': profileName,
        'Player Photo': profilePhoto,
        'Email': Profile.profileEmail,
        'Goals': 0,
        'Assist': 0
      });
      //Incrementing Total Players Count
      await firestore.collection('Matches').doc(matchName).update({
        'Total Players': FieldValue.increment(1)
      });

      // Adding Player Profile Statistics
      print('Adding player profile stats');
      // Adding Player Profile Statistics
      await firestore.collection('Users').doc(Profile.profileEmail)
          .collection('Games').doc(matchName?.toUpperCase())
          .set({
        'Game Name': matchName?.toUpperCase().trim(),
        'Goals': 0,
        'Assist': 0,
        'Time Stamp': FieldValue.serverTimestamp()
      });
      Fluttertoast.showToast(msg: 'Congratulations You\'re In The Game!');
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Please Check Your Internet');
    }
  }


  // Method to create customer Id:
  void createCustomer() async {
    final url = Uri.parse('https://api.stripe.com/v1/customers');
    final apiKey =
        'sk_test_51NqrX9JjeJk2uCD416zlHJ4iqRgiduyMNzbbKJUr9tCyEPurI8GIdcBPLfdK8za4iskvtHhCvDYc8cu7NGo4m2mb00XH1vceLZ';

    final response = await http.post(url, headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}'
    });
    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  // Method to fetch Ephemeral Key against customer Id:
  void createEnumeralKey() async {
    final url = Uri.parse('https://api.stripe.com/v1/ephemeral_keys');
    final apiKey =
        'sk_test_51NqrX9JjeJk2uCD416zlHJ4iqRgiduyMNzbbKJUr9tCyEPurI8GIdcBPLfdK8za4iskvtHhCvDYc8cu7NGo4m2mb00XH1vceLZ';
    final stripeVersion = '2023-10-16';

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
        'Stripe-Version': stripeVersion,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': 'cus_OsEts9mqtLH7WY',
      },
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  stripePayment() async {
    print('Payment');

    await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails:
            BillingDetails(name: 'cardHolderName'), // it didn't work
          ),
        ),
        options: const PaymentMethodOptions(
            setupFutureUsage: PaymentIntentsFutureUsage.OnSession));



    await Stripe.instance
        .createToken(const CreateTokenParams.card(
        params: CardTokenParams(
          type: TokenType.Card,

        ))).then((value) async {

      print('Token Received');

      // Calling API

    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }
  // Function To Avoid Adding Duplicate Data.
  Future<bool> duplicateData() async {
    bool dataMatch = false;
    print('getData Called');
    await firestore
        .collection('Matches')
        .doc(matchName)
        .collection('Players')
        .where('Email', isEqualTo: Profile.profileEmail)
        .get()
        .then((value) =>
    {
      value.docs.forEach((doc) {
        if (doc['Email'] == Profile.profileEmail) {
          dataMatch = true;
        } else {
          dataMatch = false;
        }
      })
    });
    return dataMatch;
  }

  //Strip Payments
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent('20', 'USD');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          currencyCode: 'Us',
          testEnv: true
      );

      Map<String, dynamic> body = {
        'amount': '${matchFee}00',
        'currency': 'USD',
        'payment_method_types[]': 'card'
      };


      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              customerEphemeralKeySecret: 'client_secret',
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              merchantDisplayName: 'Sameer',
              googlePay: gpay));

      displayPaymentSheet();
    } catch (e) {
      print('Exception' + e.toString());
    }
  }

//TODO IF internet cuts out while processing Show Error

  // Future<String> createCustomer() async {
  //   try {
  //     final customer = await Stripe.instance.createCustomer();
  //     print('Customer ID: ${customer.id}');
  //     return customer.id;
  //   } catch (error) {
  //     print('Error creating customer: $error');
  //     throw error;
  //   }
  // }

  displayPaymentSheet() async {
    print('PAYING');
    try {
      // await Stripe.instance.presentPaymentSheet();


      Stripe stripe = Stripe.instance;




      try{


        print('Card Saved Succesfully!');
      } on StripeException catch (e){
        print('ERROR');
        print(e);
      }


      print('Done');
      Fluttertoast.showToast(msg: 'Paid Successfully');
      // addPlayerData();
    } on StripeException catch (e) {
      print('Failed');
      print('exception ' + e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': '${matchFee}00',
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'authorization':
            'Bearer sk_test_51NqrX9JjeJk2uCD416zlHJ4iqRgiduyMNzbbKJUr9tCyEPurI8GIdcBPLfdK8za4iskvtHhCvDYc8cu7NGo4m2mb00XH1vceLZ',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body.toString());
    } catch (e) {
      print('Exception' + e.toString());
    }
  }

  final controller = CardFormEditController();

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Divider(
              indent: 16,
              endIndent: 16,
              thickness: 2,
            )),
        title: Text('Join Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 11,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$matchName',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            '$time - ',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          Text(
                            '$date',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 11,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 5.5,
                  decoration: BoxDecoration(
                      borderRadius: kBorderRadius,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage('$matchImage'))),
                )
              ],
            ),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height / 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundImage: NetworkImage('$profilePhoto'),
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.42,
                        child: Text(
                          '$profileName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '\$$matchFee.00',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kGreenColor),
                      ),
                      SizedBox(height: 13),
                      Text(
                        'Total: \$$matchFee.00',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              height: 50,
            ),
            CustomButton(
                buttonText: 'Pay Now',
                textColor: Colors.white,
                buttonColor: kGreenColor,
                outlineColor: Colors.transparent,
                onPressed: () async {
                  // makePayment();
                  stripePayment();
                  // Get.toNamed('/AddCard');
                })
          ],
        ),
      ),
    );
  }
}