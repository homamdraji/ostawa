
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ostawat/servicpa.dart';




List service = [
  "home service", 
  "maintenance and installing" ,
  "building ", 
  "design", 
  "preparing",
  "online services" ,  
  "packaging", 
  "others",
 ];
 
 List images = [
  'images/house.jpg',
  'images/maintenance.jpg',
  'images/building.jpg',
  'images/design.jpg',
  'images/occasions.jpg',
  'images/online.jpg',
  'images/movong.jpg',
  'images/other.jpg',
 ];





class Math extends StatefulWidget {
   const Math({super.key});
  
  @override
  State<Math> createState() => _MathState();
}

class _MathState extends State<Math> {
  
 
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
     final double itemHeight = (size.height - kToolbarHeight - 100) / 2;
    final double itemWidth = size.width / 2;
    
      
  
    return  Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
  
      child:    GridView.builder(
        itemCount: service.length,
      gridDelegate:    SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
     childAspectRatio: (itemWidth/ itemHeight),),
      itemBuilder: (context, i){
        return  Container(color: const Color.fromRGBO(46,204,113,1),
          child: InkWell(onTap: (){
          Navigator.of(context).push( MaterialPageRoute(builder: (context) => Servicepa(datas: service[i], image: images[i],) ));
              },
          child: Stack( 
           fit: StackFit.expand,
          
          children: [Column(
            children: [const SizedBox(height: 5,),
              Expanded(
                flex: 3,
                child: Container(
                   decoration: BoxDecoration(image: DecorationImage(image: AssetImage("${images[i]}"),
                   ))),
              ),
                  
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('${service[i]}'.tr
                  ),
                ),
              ),
            ],
          )]),
              ),
        );
    }));}
    
  }