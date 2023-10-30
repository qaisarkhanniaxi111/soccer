import 'package:flutter/material.dart';

import '../../../modals/global_widgets.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

class AddCard extends StatelessWidget {
  const AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Divider(
              indent: 16,
              endIndent: 16,
              thickness: 0.5,
              color: Colors.grey.shade400,
            )),
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 51,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    )),
                onPressed: () {},
                child: Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
        centerTitle: true,
        title: Text('Add Card',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leadingWidth: 80,
        leading: const ExitArrow(),
        toolbarHeight: 90,
        backgroundColor: Colors.grey.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    children: [
                      Text(
                        'Card Number',
                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                      ),
                      Image.asset('images/Visa1.png',scale: 4.2,)
                    ],
                  ),
                ),
                hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 20),
                hintText: '1234 1234 1234 1234',
                contentPadding: EdgeInsets.only(top: 15,),

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DebitCardTextField(hintText: 'Expiry',),
                DebitCardTextField(hintText: 'CVC',),
                DebitCardTextField(hintText: 'Postal',),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DebitCardTextField extends StatelessWidget {
  final String hintText;
  const DebitCardTextField({
    super.key, required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 0),
      width: 80,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey.shade500),
            hintText: '$hintText',
          contentPadding: EdgeInsets.only(top: 10)
        ),
      ),
    );
  }
}
