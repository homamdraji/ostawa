
// ignore_for_file: prefer_typing_uninitialized_variables, empty_catches, avoid_print, use_build_context_synchronously, depend_on_referenced_packages




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostawat/hbody.dart';
import 'package:ostawat/loading.dart';




  List gover = [
'بغداد',
'واسط',
'نينوى ',
'النجف',
'ميسان',
'المثنى',
'كربلاء',
'أربيل',
'الأنبار',
'بابل',
'دهوك',
'البصرة',
'الديوانيّة',
'ديالى',
'كركوك',
'السليمانيّة',
'صلاح الدّين',
'ذي قار',
];






class Addservice extends StatefulWidget {
  const Addservice({Key? key}) : super(key: key);

  @override
  State<Addservice> createState() => _AddserviceState();
}

class _AddserviceState extends State<Addservice> {
        var servicetitle, name, describtion, location , firservice;
         bool _isServiceFree = false;
  final GlobalKey<FormState> formke = GlobalKey<FormState>();
  Map<String, dynamic>? data;
  bool isLoading = true; 

  
//  final ImagePicker _imagePicker = ImagePicker();
//   File? _pickedImage;
//   String? imageUrl;
//   Future<void> uploadAndDeleteImage(String userId) async {
//     if (_pickedImage != null) {
//       final storage = FirebaseStorage.instance;
//       final ref = storage.ref().child('$userId.jpg');
      
//       try {
//         final appCheckToken = await FirebaseAppCheck.instance.getToken(true);
//          if (appCheckToken != null) {
//         await ref.putFile(_pickedImage!, SettableMetadata(
//           customMetadata: {
//             'app_check_token': appCheckToken,
//           },
//         ) );
        
//          showDialog(context: context, 
//                     builder: (context){
//                   return  const AlertDialog(
//                    title: Center(child: Text('app check is here')),
//                  );
//                });
//         await ref.putFile(_pickedImage!,  );
//     } else {
//          showDialog(context: context, 
//                     builder: (context){
//                   return  AlertDialog(
//                    title: Center(child: Text(appCheckToken!)),
//                  );
//                });
//     }
       
        
      //      final metadata = SettableMetadata(
      //   customMetadata: {'app_check_token': '$appCheckToken'},
      // );

       
               
              
      
        
   
  
//   setState(() async {
//     imageUrl = await ref.getDownloadURL();
//   });
 
    
//         // Delete old image if it exists
//         try {
//           String oldImageUrl = await ref.getDownloadURL();
//           if (oldImageUrl.isNotEmpty) {
//             await ref.delete();
//             print('Old image deleted.');
//           }
//         } on FirebaseException {
//   // Caught an exception from Firebase.
 
// }

//         print('Image uploaded successfully.');
//       } on FirebaseException {
//   // Caught an exception from Firebase.
 
  
// }
//     } else {
//       print('No image picked.');
//     }
//   }
//  Future<void> pickImage() async {
//   try{  final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _pickedImage = pickedImage != null ? File(pickedImage.path) : null;
//     });} catch (e) {
//       print(e);
//     }
    
//   }


     save () async {
        
      var formdata = formke.currentState;
        formdata!.save();
         if (formdata.validate() && location != null && firservice !=null ){ 
          showloading(context); 
           try {
  
    if (_isServiceFree) {
     
       CollectionReference service =  FirebaseFirestore.instance.collection('service');
         return await service.doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'servicetitle': servicetitle,
            'name': name ,
            'describtion': describtion,
            'location': location,
            'fireservice': firservice,
            //  'imageUrl': imageUrl,
          })
          // .whenComplete(() => Navigator.of(context).pushReplacementNamed('/homepage'))
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      Navigator.of(context).pop();
       showDialog(context: context, 
                    builder: (context){
                  return  AlertDialog(
                   title: Center(child: Text('you are not subbed'.tr)),
                      
                 );
               });
            print('you are not subbed');
    }
  } catch (e) {
    print('Error getting data from Firestore: $e');
   
  }  
         } else if(location == null) {
           showDialog(context: context, 
                    builder: (context){
                  return  AlertDialog(
                   title: Center(child: Text('select location'.tr)),
                 );
               });

         } else if (firservice == null) {
           showDialog(context: context, 
                    builder: (context){
                  return  AlertDialog(
                   title: Center(child: Text('select catagory'.tr)),
                 );
               });
         }
         
     }
      Future<void> fetchData() async {
    try {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('service')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (docSnapshot.exists) {
      data = docSnapshot.data() as Map<String, dynamic>;
              bool isFree = docSnapshot['free'];
      setState(() {
        _isServiceFree = isFree; 
//         // Update the state to trigger a UI update

      });
    } else {
      print('Document does not exist.');
    }}catch (e){
        print('Error fetching data: $e');
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        // FocusScope.of(context).unfocus() will hide the keyboard.
        FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: AppBar(
          title: Text('add service'.tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formke,
            autovalidateMode: AutovalidateMode.always,
            child: ListView.builder(
              itemCount: 1 + (data != null ? 1 : 0), // Data form + Submit button
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Data form
                  if (data != null) {
                    return buildit(data!);
                  }  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                } else {
                  // Submit button
                  return Column(
                    children: [
                      //  Center(
                      //   child: ElevatedButton(
                      //     onPressed: pickImage,
                      //     child: Text("add image".tr),
                      //   ),
                      // ),
    
                      Center(
                        child: ElevatedButton(
                          onPressed: (){
                            //  if (_pickedImage != null) {
                            //   uploadAndDeleteImage(FirebaseAuth.instance.currentUser!.uid); // Replace with the actual user ID
                            //   save();
                            // } else {
                              save();
                            //  }
                          } ,
                          child: Text("save".tr),
                        ),
                      ),
                    ],
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildit(Map<String, dynamic> data) {
    // Build your form using the 'data'
    return Column(
      children: [
                       Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Center(child: Text(_isServiceFree ? 'Service is free.'.tr : 'Service is not free.'.tr)),
               ),
                TextFormField(
                                 onSaved: (newValue) {
                       name = newValue ;
                      } ,
            
                       controller: data['name'] == null ? null :  TextEditingController( text:  '${data['name']}'),
                      
                       validator:(text){
                         if ( text!.isEmpty ){
                            return 'should not be empty'.tr ;
                         } 
                          return null;
                             },
                       
                              maxLines: 1 ,
                              maxLength: 50,
                              decoration:  InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blue
                                  )
                                ),
                                
                                hintText:  'name'.tr ,
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                              TextFormField(
                   onSaved: (newValue) {
                       servicetitle = newValue ;
                      } ,
                      controller: TextEditingController( text: data['servicetitle'] == null ?  null : '${data['servicetitle']}' ) ,
                       validator:(text){
                         if ( text!.isEmpty   ){
                            return 'should not be empty'.tr ;
                         } 
                          return null;
                             },
                       
                              maxLines: 1 ,
                              maxLength: 20,
                              decoration:  InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.orange
                                  )
                                ),

                                
                                hintText: 'title'.tr,
                                prefixIcon: const Icon(Icons.home_repair_service),
                              ),
                            ),
                
                const SizedBox(height: 10,),
                TextFormField(
                   onSaved: (newValue) {
                       describtion = newValue ;
                      } ,
                      
                       validator:(text){
                         if ( text!.isEmpty){
                            return 'should not be empty'.tr ;
                         } 
                          return null;
                             },
                              maxLines: 3 ,
                              maxLength: 300,
                              decoration:  InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blue
                                  )
                                ),
                                hintText:  'describtion'.tr,
                              ),
                            ),
                Center(
                child: DropdownMenu(hintText: 'select location'.tr,
                leadingIcon: const Icon(Icons.location_on,) ,
                  onSelected: (value) {
                          location = value ;
                          print(location);
                        },
                          menuHeight: double.infinity-400,
                          
                          dropdownMenuEntries: gover.map((e) => DropdownMenuEntry(value: e  , label: '$e'.tr)).toList()
                          ),
                            ),
                            const SizedBox(
                height: 10,
              ),
                            Center(
                child: DropdownMenu(hintText: 'select catagory'.tr ,
                leadingIcon: const Icon(Icons.category_sharp, ) ,
                  onSelected: (value) {
                          firservice = value ;
                          print(firservice);
                        },
                          menuHeight: double.infinity-400,
                          dropdownMenuEntries: service.map((e) => DropdownMenuEntry(value: e , label: '$e'.tr)).toList()
                          ),
                            ),
              const SizedBox(
                height: 10,
              ),
            
                
      ],
    );
  }
}