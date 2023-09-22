// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Aboutus extends StatelessWidget {
 const Aboutus({super.key});

 

  

  @override
  Widget build(BuildContext context) { 
    String aboutus = 'aboutus'.tr ;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Text(aboutus,style: const TextStyle(fontSize: 18),)
          ],
        ),
      )
    );
  }}