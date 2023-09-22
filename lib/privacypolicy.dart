import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen( {super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  static  String privacyPolicyText = 'privacy'.tr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'.tr),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:  Text(
          privacyPolicyText,
          style: const TextStyle(fontSize: 18),
        ),
        ),
      ),
    );
  }
}


class Termsofuse extends StatelessWidget {
  const Termsofuse({super.key});

   static String termsOfServiceText = 'terms'.tr;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Terms of use'.tr),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:  Text(
          termsOfServiceText,
          style: const TextStyle(fontSize: 18),
        ),
        ),
      ),
    );
  }
}