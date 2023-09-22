
// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostawat/drawer2.dart';
import 'package:ostawat/hbody.dart';
import 'package:ostawat/signuppage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'mylocale.dart';



SharedPreferences ? sharepref ;
bool islogin = true ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharepref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,  
  );
  await FirebaseAppCheck.instance.activate(
   
   appleProvider: AppleProvider.deviceCheck,
   
  );
  var user = FirebaseAuth.instance.currentUser ;
  if (user == null) {
    islogin = false ;
  } else {
    islogin = true ;
  }
  runApp( const Mainp());
}

class Mainp extends StatelessWidget {
 

   const Mainp({super.key});
   
  @override
  Widget build(BuildContext context) {
  
    Mylocalecontroller controller =  Get.put(Mylocalecontroller());
    return  GetMaterialApp(
      title: 'Ostawat',
      locale: controller.initialang,
      translations: Mylocale(),
     theme: ThemeData(
      brightness: Brightness.light ,
      textButtonTheme: const TextButtonThemeData
     (style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Color.fromRGBO(46,204,113,1)))),
     appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Color.fromRGBO(46,204,113,1),),
      backgroundColor: Colors.transparent, 
      surfaceTintColor:Colors.transparent, 
      shadowColor: Colors.transparent, 
      foregroundColor: Colors.transparent, 
      iconTheme: IconThemeData(color: Color.fromRGBO(46,204,113,1),) ),
      iconTheme: const IconThemeData(color: Color.fromRGBO(46,204,113,1),),
      primaryIconTheme: const IconThemeData(color: Color.fromRGBO(46,204,113,1),),
      inputDecorationTheme:
         InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromRGBO(46,204,113,1))),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromRGBO(46,204,113,1))),
        iconColor: const Color.fromRGBO(46,204,113,1),
        prefixIconColor: const Color.fromRGBO(46,204,113,1), 
        suffixIconColor: const Color.fromRGBO(46,204,113,1),),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(46,204,113,1),),
        surfaceTintColor: MaterialStatePropertyAll(Color.fromRGBO(46,204,113,1),),
        shadowColor: MaterialStatePropertyAll(Color.fromRGBO(46,204,113,1),)
        ))
     ),
     
      debugShowCheckedModeBanner: false,
      
      home: islogin == false ?  const PhoneInputPage() : const Homepage(),
      routes: {
        // '/signin' :(context) => const Signin(),
        '/signup' :(context) =>  const PhoneInputPage(),
        '/homepage' : (context) => const Homepage(),
        });}
        
      }

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
     Mylocalecontroller localecont = Get.find();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ostawat'.tr ,style: const TextStyle( 
            fontSize: 20,
                  fontFamily: 'lato'
                ),),
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
        
        drawer:  const Drawer(
          child: Drawer1(),),
        body:  const Math()
        ),
    );  
  }
}