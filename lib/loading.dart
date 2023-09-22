
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showloading(context){
  return showDialog(context: context, 
  builder: (context){
   return  AlertDialog(
  title: Center(child: Text('please wait'.tr)),
  content: const SizedBox(
    height: 50,
    child: Center(child: CircularProgressIndicator(),),
  ),
   );
  });
}

