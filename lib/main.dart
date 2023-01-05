import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasedemo1/glogin.dart';
import 'package:firebasedemo1/phone.dart';
import 'package:firebasedemo1/view_file.dart';
import 'package:firebasedemo1/viewrealtime.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: First(),
  ));
}
class First extends StatefulWidget {

  String? name,key1,contact;
  First([this.key1,this.name,this.contact]);

  // DocumentSnapshot? document;
  // First([this.document]);
  @override
  State<First> createState() => _FirstState();
}
class _FirstState extends State<First> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('contact_book');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.key1!=null)
      {
        t1.text=widget.name!;
        t2.text=widget.contact!;
      }
    // if(widget.document!=null){
    //   Map<String, dynamic> data = widget.document!.data()! as Map<
    //       String,
    //       dynamic>;
    //   t1.text=data['name'];
    //   t2.text=data['contact'];
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Contact")),
      body: Column(children: [
        TextField(controller: t1,),
        TextField(controller: t2,),
        ElevatedButton(onPressed: () async {

          if(widget.key1==null)
            {
              DatabaseReference ref = FirebaseDatabase.instance.ref("contact_book").push();
              await ref.set({
                "name": t1.text,
                "contact": t2.text,
              });
            }
          else{
            DatabaseReference ref = FirebaseDatabase.instance.ref("contact_book").child(widget.key1!);
            await ref.update({
              "name": t1.text,
              "contact": t2.text,
            });
          }

          // if(widget.document!=null){
          //   update_user();
          // }else
          //   {
          //     addUser();
          //   }
        }, child: Text("Submit")),
        ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return viewrealtime();
          },));
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return View_Data();
          // },));
        }, child: Text("View Contact"))
      ],),
    );
  }
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'name': t1.text, // John Doe
      'contact': t2.text, // Stokes and Sons
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
    // Future<void> update_user() {
    //   return users
    //       .doc(widget.document!.id)
    //       .update({'name': t1.text,
    //     'contact': t2.text})
    //       .then((value) {
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return View_Data();
    //     },));
    //   })
    //       .catchError((error) => print("Failed to update user: $error"));
    // }

}
