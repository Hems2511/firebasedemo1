import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo1/glogin.dart';
import 'package:firebasedemo1/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser;
  String UserName="";
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if (user != null) {
  //     UserName=user!.displayName.toString();
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () async {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
       Navigator.push(context, MaterialPageRoute(builder: (context) {
         return GLogin();
       },));
        }, icon: Icon(Icons.logout))
      ],
        title: Text("DashBoard"),
      ),
      body: Column(
        children: [
          // Text("Name : $UserName",style: TextStyle(fontSize: 35),),
          Text("Name : ${user!.phoneNumber}",style: TextStyle(fontSize: 35),),
        ],
      ),
    );
  }
}
