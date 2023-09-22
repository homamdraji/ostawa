
// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ostawat/loading.dart';
import 'package:ostawat/report.dart';


class Idpage extends StatefulWidget {
  final  docsnap;

  const Idpage({super.key, required this.docsnap});

  @override
  State<Idpage> createState() => _IdpageState();
}

class _IdpageState extends State<Idpage> {
  
  String  ruse = '' ;
  @override
  Widget build(BuildContext context) {
    
    GlobalKey<FormState> formke = GlobalKey<FormState>();
   int firedate = DateTime.now().millisecondsSinceEpoch;
   
  
          CollectionReference service =  FirebaseFirestore.instance.collection('reports');
          
    return Scaffold(
      appBar: AppBar( actions: [
        PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                   PopupMenuItem(
                    onTap: () {
                      
                      Future.delayed(
                  const Duration(seconds: 0),
                     () => 
                      showDialog(context: context, builder: (context) {
          return   AlertDialog(actions:[ StatefulBuilder(builder: (ctx , setState){
          return 
          Column(
          children: [
          Form(key: formke,
          child: Column(
          children: menu().reports.map((ele ) => RadioListTile(
          title: Text(ele),
          value: ele , groupValue: ruse , onChanged: (valu){
          setState(() {
          ruse = valu ;
          }); 
          })).toList(),),),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          ElevatedButton(onPressed: (){
          Navigator.of(context).pop();
          }, child:  Text('cancel'.tr)),
          ElevatedButton(onPressed: () async{
          List res = [] ;
          QuerySnapshot reportdaras = await service.where('from user', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('time', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch - 86400000 ).
          get();
          // ignore: avoid_function_literals_in_foreach_calls, unused_local_variable
          var temp = reportdaras.docs.forEach((element) {
          res.add(element.data());
          });
          if (res.isEmpty){
            showloading(context);
          var formdata = formke.currentState;
          formdata!.save();
           await service.add(
           {
           'report' : ruse ,
          'time' : firedate ,
          'report on user' : ' ${widget.docsnap['userid']} ',
          'from user' : FirebaseAuth.instance.currentUser?.uid 
           }).whenComplete((){
           Navigator.of(context).pop();
           })
          // ignore: avoid_print, invalid_return_type_for_catch_error
          .catchError((error) => print("Failed to add user: $error"));
          } else {
          Navigator.of(context).pop();
           
          showDialog(context: context, builder: (context) {
           return  AlertDialog(content: Text('try next day'.tr),);
          });
          }
          }
          ,child:  Text('send report'.tr)),
           ],
          ) ],
           ); 
          })
          ]
           )
         ;})
                     );
                    },
                  child:  Text('report'.tr),
                      ),
                     
                      ],
        ),
       
   ]
      ),
      body: Container(width: double.infinity,
      padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
          
              SizedBox(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.docsnap['servicetitle']}',style: const TextStyle(fontSize: 20),),
              ),),
             Container(height: 1,
            color: const Color.fromARGB(255, 129, 126, 126),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(height: 20,
                  child: Text('${widget.docsnap['name']}',style: const TextStyle(fontSize: 20),),),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children:  [Text('place'.tr),
                  Text(': ${widget.docsnap['location']}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [Text('phonenumber'.tr),
                  Text(': ${widget.docsnap['username']}'),
                ],
              ),
            ),
            Container(height: 1,
            color: const Color.fromARGB(255, 129, 126, 126),),
             SizedBox(child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text('the service include'.tr,style: const TextStyle(fontSize: 20),),
             ),),
            
             SizedBox(
              width: double.infinity,
              
              
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(' ${widget.docsnap['describtion']}'),
              ),
            ),
            

          
            
          ],
        )),
    );
  }
}