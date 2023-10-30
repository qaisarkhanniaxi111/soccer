import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soccer_life/modals/constants.dart';

import '../../../modals/global_widgets.dart';

class PayNow extends StatelessWidget {
  const PayNow({super.key});

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
        elevation: 0,
        centerTitle: true,
        title: Text('Payment Method',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leadingWidth: 80,
        leading: const ExitArrow(),
        toolbarHeight: 90,
        backgroundColor: Colors.grey.shade50,
      ),
      body: InkWell(
        onTap: () => Get.toNamed('/AddCard'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20,top: 10),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  borderRadius: OtpBorderRadius,
                  color: Colors.transparent,
                  border: Border.all(color: kGreenColor, width: 2)),
              child: Icon(
                FontAwesomeIcons.plus,
                size: 16,
                color: kGreenColor,
              ),
            ),
            Text(
              'Add New Card',
              style: TextStyle(
                  color: kGreenColor, fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
