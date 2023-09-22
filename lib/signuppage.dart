

// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ostawat/loading.dart';
import 'package:ostawat/privacypolicy.dart';

import 'mylocale.dart';









class PhoneInputPage extends StatefulWidget {

  const PhoneInputPage({super.key});

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  bool _isAgreedToTerms = false;
  void agree (newValue) {
                  setState(() {
                    _isAgreedToTerms = newValue!;
                  });
                }
  @override
  Widget build(BuildContext context) {

    
  
    GlobalKey<FormState> formkeystate = GlobalKey<FormState>();
FirebaseAuth auth = FirebaseAuth.instance;

  void signUpWithPhoneNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+964${phoneNumberController.text}',
      verificationCompleted: (credential) async {
        await auth.signInWithCredential(credential);
        // Handle successful sign-up
      },
      verificationFailed: (exception) {
        // Handle verification failure
       
  final errorCode = exception.code;
  print("Error code: $errorCode");
 
  if (errorCode == 'network-request-failed' || errorCode == 'internal-error' ){
    
        showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('weak networks'.tr)),
        );
      },
    );
    }
      },
      codeSent: (verificationId, forceResendingToken) {
        
       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
            VerificationPage(phoneNumber: phoneNumberController.text, verificationId: verificationId,),
                          ),
                        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

Mylocalecontroller localecont = Get.find();
    return WillPopScope(onWillPop: () async {
        // Prevent back navigation from this page
        return false;
      },
      child: GestureDetector(
         onTap: () {
        // FocusScope.of(context).unfocus() will hide the keyboard.
        FocusScope.of(context).unfocus();},
        child: Scaffold(
          appBar: AppBar( automaticallyImplyLeading: false,
          actions: [ PopupMenuButton(
                    icon: const Icon(Icons.language),
                      itemBuilder: (context) => [
                       PopupMenuItem(
                        onTap: () {
                          localecont.changelang('ar');
                        },
                      child:  Text('Arabic'.tr),
                          ),
                           PopupMenuItem(onTap: () {
                             localecont.changelang('en');
                           },
                      child: Text('English'.tr),
                          ),
                          ],
        )],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
          
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Ostawat'.tr , style: const TextStyle( 
                      color: Color.fromRGBO(46,204,113,1),
                      fontSize: 70,
                      fontFamily: 'lato'
                    ),)),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Enter Phone Number'.tr,
                     style: const TextStyle( 
                      color: Color.fromRGBO(46,204,113,1),
                    ),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formkeystate,
                      child: Column(
                      children: [
                           TextFormField(
                      validator: (text){
                    
                       if ( text!.isEmpty   ){
                          return 'should not be empty'.tr ;
                       } 
                        if ( text.length != 10  ){
                          return 'should equal 10'.tr ;
                       } 
                        return null;
                           },
                      maxLines: 1,
                      maxLength: 10,
                      controller: phoneNumberController,
                      
                      keyboardType: TextInputType.phone,
                      decoration:  InputDecoration( prefixText: '+964',
                        labelText: 'Phone Number'.tr),
                      
                    ),
                      ],
                   
                    ))
              
                   ),
                  
                  const SizedBox(height: 10,),
      
            Row(
                  children: [
                    Checkbox(
                      value: _isAgreedToTerms,
                      onChanged: agree, 
                    ),
                    Text("I agree to ".tr),
                    TextButton(
                      onPressed: (){ 
                         Navigator.push(context,
                     MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),);
                      },
                      child: Text('Privacy Policy'.tr),
                    ),
                    Text(" and ".tr),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context,
                     MaterialPageRoute(builder: (context) => const Termsofuse()),);
                      },
                      child: Text('Terms'.tr),
                    ),
                  ],
                ),
            const SizedBox(height: 10,),
                  Container(
                     padding: const EdgeInsets.all(10),
                     margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
      
                        ElevatedButton(
                          onPressed: !_isAgreedToTerms? 
                          (){
                    showDialog(context: context, 
                      builder: (context){
                    return  AlertDialog(
                     title: Center(child: Text('you should agree to privacy'.tr)),
                      );
                      });
                      } 
                          :() {
                             var formdata = formkeystate.currentState;
                             if (formdata!.validate()){
                              
                              showloading(context);
                              signUpWithPhoneNumber();
                              print('+964${phoneNumberController.text}');
                              }
                          } ,
                          child:  Text('Next'.tr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  
  final String verificationId;
  const VerificationPage({super.key,  required this.phoneNumber,  required this.verificationId});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  final TextEditingController _smsCodeController = TextEditingController();
  
  
  Future<void> _verifyCodeAndSignIn() async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsCodeController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
         if (value.user != null){
           CollectionReference users =  FirebaseFirestore.instance.collection('service');
           await users.doc(FirebaseAuth.instance.currentUser!.uid).get().then((userDoc) async {
  if (!userDoc.exists) {
    await users.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'username': '+964${widget.phoneNumber}', 
      'free': false,
    }).then((value) {
      print("User Added");
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  } else {
    print("User document already exists");
    Navigator.of(context).pushReplacementNamed('/homepage');
  }
});
         }}
     
      );
      // Handle successful verification and sign-in
    } catch (e) {
      
      if (e is FirebaseException) {
    final errorCode = e.code;
    print("Error code: $errorCode");
 if (errorCode == 'invalid-verification-code'){
          showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('wrong code'.tr)),
          );
        },
      );
      }

  }
      // Handle verification failure
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        // FocusScope.of(context).unfocus() will hide the keyboard.
        FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('Verify Phone Number'.tr,style: const TextStyle( 
                    color: Color.fromRGBO(46,204,113,1),
                  ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                       Text('Enter the SMS code sent to '.tr),
                      Text('964${widget.phoneNumber}+'.tr),
                    ],
                  ),
                ),
                TextFormField(
                   validator: (text){
                  
                     if ( text!.isEmpty   ){
                        return 'should not be empty'.tr ;
                     } 
                      return null;
                         },
                  controller: _smsCodeController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(labelText: 'SMS Code'.tr),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _verifyCodeAndSignIn,
                        child:  Text('Verify'.tr),
                      ),
                    Text('* if code'.tr),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}