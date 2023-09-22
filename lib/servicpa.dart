
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostawat/addservice.dart';
import 'package:ostawat/idpage.dart';





class Servicepa extends StatefulWidget {
  final String datas;
  final String image ;
  const Servicepa({Key? key, required this.datas, required this.image}) : super(key: key);

  @override
  State<Servicepa> createState() => _ServicepaState();
}

class _ServicepaState extends State<Servicepa> {
  String locationfilter = '';
  String query = '';
  List<Map<String, dynamic>> dataList = [];
 final ScrollController _scrollController = ScrollController();
 bool isLoading = false;


  Future<List<Map<String, dynamic>>> fetchData(int limit) async {
    
    Query<Map<String, dynamic>> usersQuery =
        FirebaseFirestore.instance.collection('service')
            .where('fireservice', isEqualTo: widget.datas).where('free', isEqualTo: true)
            .orderBy('servicetitle')
            .startAt([query]).endAt(['$query\uf8ff']).limit(limit);
    
    if (locationfilter.isNotEmpty) {
      usersQuery = usersQuery.where('location', isEqualTo: locationfilter);
    }

    QuerySnapshot snapshot = await usersQuery.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
   void _fetchAndBuild(int limit) async {
    
      isLoading = true;
    
    List<Map<String, dynamic>> data = await fetchData(limit);

    if (mounted) {
      setState(() {
        dataList = data;
          isLoading = false;
      });
    }
  }

    @override
  void initState() {
    super.initState();
   
    _fetchAndBuild(10);
     _scrollController.addListener(() {
  if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    // Load more data here
    _fetchAndBuild(dataList.length + 10); 
  }
});

  }
   

  @override
  Widget build(BuildContext context) {
   
     Widget bui (var data) { return
         Container(
                    margin:  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    padding: const EdgeInsets.all(5),
                    
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(46,204,113,1),
                      borderRadius: BorderRadius.circular(15)
                    ), 
                  child: 
                   Row(
                   children: [
                     Expanded(flex: 3,
                       child: SizedBox(width: double.infinity,
                        height: 100,
                          child: InkWell(onTap: (){
                          Navigator.of(context).push( MaterialPageRoute(builder: (context) => Idpage(docsnap: data,) ));
                                },
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [ Expanded(flex: 1,
                            child: Container(),
                              // child: data['imageurl'] !=null ? 
                              // Image(image: NetworkImage(data['imageUrl'])):
                              // Image( image:  AssetImage(widget.image),),
                             
                                ),
                               Expanded(
                                flex: 3,
                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                  Expanded(
                                    
                                child: Text("${data['servicetitle']}")),
                                     Expanded(child: Text("${data['name']}")),
                           Expanded(
                            child: Text("${data['username']}")),

                                  Expanded(child: Text("${data['location']}".tr)),
                                 
                                ],),
                              ),
                            ],
                          )
                                ),
                        ),
                     ),
                   ],
             )
          );
      }
    return GestureDetector(
       onTap: () {
        // FocusScope.of(context).unfocus() will hide the keyboard.
        FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar:AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: AlertDialog(
                        actions: [
                          DropdownMenu(
                            initialSelection: gover[0],
                            leadingIcon: const Icon(Icons.location_on),
                            onSelected: (value) {
                              setState(() {
                                locationfilter = value;
                              });
                              _fetchAndBuild(10);
                            },
                            menuHeight: double.infinity - 400,
                            dropdownMenuEntries: gover
                                .map((e) =>
                                    DropdownMenuEntry(value: e, label: '$e'.tr))
                                .toList(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('cancel'.tr),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.location_on),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                 _fetchAndBuild(10);
                },
              ),
            ),
           Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Show progress indicator while loading
                : dataList.isEmpty
                    ?  Center(child: Text('No data available.'.tr))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return bui(dataList[index]);
                        },
                      ),
          ),
          ],
        ),
      ),
    );
  }
}






