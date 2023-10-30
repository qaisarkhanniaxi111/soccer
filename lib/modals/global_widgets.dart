import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:soccer_life/Routes/Sign%20In/view/sign_in.dart';
import 'package:soccer_life/modals/constants.dart';

//Custom Button
class CustomButton extends StatelessWidget {
  final String? buttonIcon;
  final Color textColor;
  final String buttonText;
  final Color buttonColor;
  final Color outlineColor;
  final Function()? onPressed;

  const CustomButton({
    required this.buttonText,
    super.key,
    required this.textColor,
    required this.buttonColor,
    required this.outlineColor,
    required this.onPressed,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 2.5,
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: outlineColor, width: 1.5),
                borderRadius: OtpBorderRadius)),
        onPressed: onPressed,
        child: Stack(
          children: [
            buttonIcon != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset('$buttonIcon', height: 30))
                : Container(),
            Align(
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 18,
                    textBaseline: TextBaseline.alphabetic),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Custom TextField
class CustomTextField extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String hinText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextAlign textAlign;
  final FormFieldValidator? validator;
  final EdgeInsetsGeometry contentPadding;
  final TextInputType? keyboardType;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final double? textFieldSize;
  final void Function()? onTap;

  CustomTextField(
      {super.key,
      required this.hinText,
      required this.controller,
      this.suffixIcon,
      this.validator,
      this.contentPadding = const EdgeInsets.only(left: 15),
      this.keyboardType,
      this.maxLines,
      this.textOverflow,
      this.textFieldSize,
      this.onTap,
      this.prefixIcon,
      this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: textFieldSize,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 85),
        child: TextFormField(
            textAlign: textAlign,
            onTap: onTap,
            maxLines: maxLines,
            validator: validator,
            autofocus: false,
            keyboardType: keyboardType,
            controller: controller,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                errorBorder: CustomBorder,
                focusedErrorBorder: CustomBorder,
                focusedBorder: CustomBorder,
                enabledBorder: CustomBorder,
                contentPadding: contentPadding,
                hintText: hinText,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon)),
      ),
    );
  }
}

//OTP Number Box
class OTPBox extends StatelessWidget {
  const OTPBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextFormField(
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kGreenColor),
              borderRadius: OtpBorderRadius),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: OtpBorderRadius),
        ),
        onChanged: (value) {
          value.length == 1
              ? FocusScope.of(context).nextFocus()
              : FocusScope.of(context).previousFocus();
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}

//EXIT ARROW Appbar Icon
class ExitArrow extends StatelessWidget {
  const ExitArrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Center(
        child: Container(
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
              Icons.arrow_back,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

//Select City Cards
class CityCard extends StatelessWidget {
  final String cityName;
  final String cityImage;
  final String cityDescription;
  final Function()? onTap;

  const CityCard({
    super.key,
    required this.cityName,
    required this.cityImage,
    required this.cityDescription,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        elevation: 1,
        child: Container(
          height: 115,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: kBorderRadius,
              border: Border.all(color: Colors.grey.shade300)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 23.0, right: 23.0, top: 10, bottom: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 25),
                  width: 90,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage('$cityImage')),
                      borderRadius: kBorderRadius),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      child: Text(
                        '$cityName',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: 140,
                      child: Text(
                        '$cityDescription',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SportsCard extends StatelessWidget {
  const SportsCard({
    super.key,
    required this.matchImage,
    required this.matchName,
    required this.matchDescription,
    required this.date,
    required this.players,
    required this.onTap,
    this.dateStamp = 999999999999999999,
    this.totalPLayers = 0,
  });

  final void Function() onTap;
  final String matchImage;
  final String matchName;
  final String matchDescription;
  final String date;
  final int dateStamp;
  final int totalPLayers;
  final String players;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 11,
                width: MediaQuery.of(context).size.width / 5.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage('$matchImage')
                        // AssetImage('$matchImage'):
                        ),
                    borderRadius: kBorderRadius),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          '$matchName',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          '$matchDescription',
                          style: TextStyle(color: Colors.grey.shade500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$date',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '$totalPLayers/$players Players',
                        style: TextStyle(color: Colors.grey.shade500)),
                    WidgetSpan(
                        alignment: PlaceholderAlignment.bottom,
                        child: Icon(FontAwesomeIcons.user,
                            size: 15, color: Colors.grey.shade500))
                  ])),
                  Visibility(
                    visible: dateStamp < DateTime.now().millisecondsSinceEpoch
                        ? true
                        : false,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.red)),
                      child: Text('EXPIRED',
                          style:
                              TextStyle(color: Colors.red, letterSpacing: 2)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 25,
          thickness: 1.0,
        )
      ],
    );
  }
}

class CustomTypeAhead extends StatelessWidget {
  const CustomTypeAhead({
    super.key,
    required this.cityNameController,
    required this.firestore,
    this.topPadding = 0.0,
    this.validator,
  });

  final TextEditingController cityNameController;
  final FirebaseFirestore firestore;
  final double topPadding;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ButtonTheme(
        alignedDropdown: true,
        child: TypeAheadFormField(
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                color: Colors.white, borderRadius: kBorderRadius),
            validator: validator,
            textFieldConfiguration: TextFieldConfiguration(
                controller: cityNameController,
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.arrow_drop_down_outlined,
                        color: kGreenColor, size: 30),
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: 'Select City',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    errorBorder: CustomBorder,
                    enabledBorder: CustomBorder,
                    disabledBorder: CustomBorder,
                    focusedBorder: CustomBorder,
                    focusedErrorBorder: CustomBorder)),
            onSuggestionSelected: (val) {
              cityNameController.text = val;
            },
            itemBuilder: (context, String? suggestion) {
              return ListTile(title: Text(' $suggestion '));
            },
            suggestionsCallback: (val) async {
              List<String> cities = [];
              await firestore
                  .collection('Cities')
                  .get()
                  .then((QuerySnapshot snapshot) => {
                        snapshot.docs.forEach((doc) {
                          cities.add(doc['City Name']);
                        })
                      });
              return cities;
            }),
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    super.key,
    this.dropDownSize,
    required this.dropDownMenuItems,
    required this.onChanged,
    required this.hintText,
    this.validator,
  });

  final double? dropDownSize;
  List<DropdownMenuItem> dropDownMenuItems;
  final void Function(dynamic) onChanged;
  final String hintText;
  final String? Function(dynamic)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 85,
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: SizedBox(
          width: dropDownSize,
          child: DropdownButtonFormField(
              validator: validator,
              borderRadius: kBorderRadius,
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                color: kGreenColor,
                size: 30,
              ),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: CustomBorder,
                  errorBorder: CustomBorder,
                  focusedBorder: CustomBorder,
                  disabledBorder: CustomBorder,
                  enabledBorder: CustomBorder,
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey.shade500)),
              dropdownColor: Colors.white,
              items: dropDownMenuItems,
              onChanged: onChanged),
        ),
      ),
    );
  }
}
