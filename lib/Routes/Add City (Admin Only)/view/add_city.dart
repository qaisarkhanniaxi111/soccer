
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:soccer_life/modals/constants.dart';
import 'package:soccer_life/modals/global_widgets.dart';
import 'package:image_picker/image_picker.dart';


class AddCity extends StatelessWidget {
   AddCity({super.key});

   //Global Key For Text Fields
   GlobalKey<FormState> globalKey = GlobalKey();

   //Firebase Instance
   final firestore = FirebaseFirestore.instance.collection('Cities');

   //Text Field Controllers
   TextEditingController cityImageController = TextEditingController();
   TextEditingController cityNameController = TextEditingController();
   TextEditingController cityDescriptionController = TextEditingController();

   //Variable To Store Image
   XFile? cityImage;

   //Pick Image From Mobile Storage
  void getImage() async {
    ImagePicker imagePicker = ImagePicker();

    cityImage = await imagePicker.pickImage(source: ImageSource.gallery);

    cityImageController.text = cityImage!.path;
  }

  //Add Data To Firebase
   void addData() async {
     if(await doesDataAlreadyExists()) {
       Fluttertoast.showToast(msg: 'City Already Exists!');
     }else {
       //Image Variables
       String uniqueFileName = DateTime
           .now()
           .microsecondsSinceEpoch
           .toString();
       final storageRef = FirebaseStorage.instance.ref();
       final imagesRef = storageRef.child('images');
       final imageToUpload = imagesRef.child(uniqueFileName);

       try {
         //Uploading Image To Firebase
         Fluttertoast.showToast(msg: 'Registering City Please Wait!');
         await imageToUpload.putFile(File(cityImage!.path));
         cityImageController.text = await imageToUpload.getDownloadURL();

         await firestore.doc(cityNameController.text).set({
           'City Name': cityNameController.text
               .trim()
               .capitalizeFirst,
           'City Description': cityDescriptionController.text
               .trim(),
           'City Image': cityImageController.text.trim()});
         Fluttertoast.showToast(msg: 'Data Saved Successfully!');
         clearFields();
       }
       catch (e){
         Fluttertoast.showToast(msg: 'Please Check Your Internet And Try Again!.');
       }
     }
   }

   // Function To Avoid Adding Duplicate Data.
   Future<bool> doesDataAlreadyExists() async {
     final QuerySnapshot result = await firestore
         .where('City Name',
         isEqualTo: cityNameController.text.trim().capitalizeFirst,)
         .limit(1)
         .get();
     final List<DocumentSnapshot> documents = result.docs;
     return documents.length == 1;
   }

   //Clear Text Fields
   void clearFields(){
     cityNameController.clear();
     cityImageController.clear();
     cityDescriptionController.clear();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Divider(
              indent: 16,
              endIndent: 16,
              thickness: 1.5,
            )), title: Text('Add City')),
      body: Form(
        key: globalKey,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16.0, top: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    //Add City Text
                    Text('Add Your Match City',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    //City Photo
                    CustomTextField(
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please Select Photo';
                        }else{
                          return null;
                        }

                      },
                      maxLines: 1,
                      keyboardType: TextInputType.none,
                      suffixIcon: InkWell(
                        onTap: (){
                          getImage();
                          cityImageController.clear();
                        },
                        child: Container(
                          margin: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kGreenColor
                          ),
                          child: Icon(Icons.add,color: Colors.white,size: 25,),
                        ),
                      ),
                        hinText: 'Add Photo',
                        controller: cityImageController),
                    //City Name
                    CustomTextField(
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please Add City Name';
                          }else{
                            return null;
                          }

                        },
                        hinText: 'City Name',
                        controller: cityNameController),
                    //City Description
                    CustomTextField(
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please Add City Description';
                          }else{
                            return null;
                          }

                        },
                        maxLines: 4,
                      contentPadding: EdgeInsets.only(left: 18,right: 18,top: 20,bottom: 20),
                        hinText: 'City Description',
                        controller: cityDescriptionController),
                  ],
                ),
              ),
              CustomButton(
                  buttonText: 'Add City',
                  textColor: Colors.white,
                  buttonColor: kGreenColor,
                  outlineColor: Colors.transparent,
                  onPressed: (){
                    if(globalKey.currentState!.validate()){
                      //Add Data To Firebase
                      addData();
                    }

                  }),
            ],
          ),
        ),
      ),
    );
  }
}
