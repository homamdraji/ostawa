
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostawat/signuppage.dart';

class Usersettings extends StatefulWidget {
  const Usersettings({super.key});

  @override
  State<Usersettings> createState() => _UsersettingsState();
}

class _UsersettingsState extends State<Usersettings> {


Future<void> deleteUserAccount() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Delete the user's data (optional)
    // Implement data deletion from your Firebase services (e.g., Firestore, Realtime Database) before deleting the account.
   
    // Delete the user's account
    await user!.delete().whenComplete(() async => await FirebaseFirestore.instance.collection('service')
    .doc(user.uid).delete().whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PhoneInputPage())) )
    
     );
    
    print("User account deleted successfully");
  } catch (error) {
    print("Error deleting user account: $error");
  }
}



  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
      appBar: AppBar(
        title:  Text('user settings'.tr),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
          children: [
            ElevatedButton(onPressed: (){
               showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(child: Text('do delete'.tr)),
                content: Text('delete all'.tr),
                actions: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     ElevatedButton(onPressed: deleteUserAccount, child: Text('delete'.tr)),
                   ElevatedButton(onPressed: (){
                    Navigator.of(context).pop();
                   }, child: Text('cancel'.tr))
                  ],
                  
                  ),
                 
                ],
              );
            },
          );
            }, child: Text('delete account'.tr))
          ],
          ),
        ),
      )
      );
    
  }
}
