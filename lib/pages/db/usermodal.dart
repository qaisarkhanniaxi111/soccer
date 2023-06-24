import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserModal
{
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('Users');

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument(phoneNumber) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      // Return an empty DocumentSnapshot
      return FirebaseFirestore.instance.doc('users/nonexistent').get();
    }
  }

  Future<void> createDocument(firstname, lastname, phone) async {
    try {
      await usersCollection.add({
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
      });
      print('Document created successfully!');
    } catch (e) {
      print('Error creating document: $e');
    }
  }


}