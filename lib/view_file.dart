import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo1/main.dart';
import 'package:flutter/material.dart';

class View_Data extends StatefulWidget {
  const View_Data({Key? key}) : super(key: key);

  @override
  State<View_Data> createState() => _View_DataState();
}

class _View_DataState extends State<View_Data> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('contact_book').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection(
      'contact_book');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View Contact"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<
                    String,
                    dynamic>;
                print(document.id);
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['contact']),
                  trailing: Wrap(children: [
                    IconButton(onPressed: () {
                          deleteUser(document.id);
                    }, icon: Icon(Icons.delete)),
                    IconButton(onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return First(document);
                      // },));
                    }, icon: Icon(Icons.edit)),
                  ],),
                );
              }).toList(),
            );
          },
        )
    );
  }

  Future<void> deleteUser(String id) {
    return users
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"));
  }
}