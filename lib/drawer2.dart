
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostawat/about%20us.dart';
import 'package:ostawat/addservice.dart';
import 'package:ostawat/usersetting.dart';
import 'package:url_launcher/url_launcher.dart';


List<String> dcont = [
    'add service',
    'user settings',
    'about us',
    
  ];

  List pages = [
       const Addservice(),
       const Usersettings(),
        const Aboutus(),
    ];
class Drawer1 extends StatefulWidget {
  const Drawer1({super.key});

  @override
  State<Drawer1> createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {
    var user = FirebaseFirestore.instance.collection('service');
     Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }}catch (e) {
      print(e.hashCode);
    }
  }


  @override
  Widget build(BuildContext context) {
    
    return  FutureBuilder(
      future: user.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
    
        if (snapshot.connectionState == ConnectionState.none){
          return Text('weak networks'.tr);
        }
         if (snapshot.connectionState == ConnectionState.done){ 
          try{ 
            
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
      return ListView(
        children: [ 
          



           const SizedBox(
          height: 30,
           ),
          Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              
              data['free'] == true ? Text('sub'.tr) : Text('nosub'.tr) ,


             
              
            const SizedBox(height: 10,),
               Text('${data['username']}'),
              
            const SizedBox(height: 20,),
            SizedBox(
              height: 150,
              child: ListView.builder(itemCount: dcont.length,
                itemBuilder: (context , i) {return
                  TextButton(onPressed: (){
                     Navigator.of(context).push( MaterialPageRoute(builder: (context) => pages[i] 
            ));
                  }, child: Text(dcont[i].tr));
                }),
            ),
          
            TextButton(onPressed: () async {
              Navigator.of(context).pushReplacementNamed('/signup');
              await FirebaseAuth.instance.signOut();
            }, child:  Text('sign out'.tr)),
           const SizedBox(height: 30,),
           
           Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('contact us'.tr),
            ),
            TextButton(onPressed: () => _launchURL("https://instagram.com/ostawat.iq?igshid=MzRlODBiNWFlZA=="),
             child: Text('facebook'.tr)),
            
              
            TextButton(onPressed: () => _launchURL("https://api.whatsapp.com/send?phone=009647803784984"),
             child: Text('whatsapp'.tr)),
           
          ],
        ),
          const SizedBox(height: 30,),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('version : 1.0.1'.tr),
            )
            ],
          ),
          
        ),
        ]
      );} catch (e) {
        print(e);
       return Column(
         children: [
           Center(child: Text('weak networks'.tr)),
            Center(child: Text(e.toString())),
         ],
       );

      }} 
       return const Center(child: CircularProgressIndicator(),);
       },
    );
  }
}


