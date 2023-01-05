import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class viewrealtime extends StatefulWidget {
  const viewrealtime({Key? key}) : super(key: key);

  @override
  State<viewrealtime> createState() => _viewrealtimeState();
}

class _viewrealtimeState extends State<viewrealtime> {

  List keylist=[];
  List namelist=[];
  List contactlist=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('contact_book');
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map data = event.snapshot.value as Map;
      keylist.clear();
      namelist.clear();
      contactlist.clear();
      data.forEach((key, value) {
        print("$key=>$value");
        keylist.add(key);
        namelist.add(value['name']);
        contactlist.add(value['contact']);
      });
      setState(() {

      });
      print(keylist);
      print(namelist);
      print(contactlist);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(itemCount: namelist.length,itemBuilder: (context, index) {
        return ListTile(
          title: Text("${namelist[index]}"),
          subtitle: Text("${contactlist[index]}"),
          trailing: Wrap(
            children: [
              IconButton(onPressed: () async {
                DatabaseReference ref = FirebaseDatabase.instance.ref("contact_book").child(keylist[index]);
                await ref.remove();
                setState(() {
                });
              }, icon: Icon(Icons.delete)),
              IconButton(onPressed: () {

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return First(keylist[index],namelist[index],contactlist[index]);
                },));

              }, icon: Icon(Icons.edit))
            ],
          ),
        );
      },),
    );
  }
}
