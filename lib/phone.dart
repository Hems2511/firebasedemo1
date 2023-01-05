import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'dashboard.dart';

class phone extends StatefulWidget {
  const phone({Key? key}) : super(key: key);

  @override
  State<phone> createState() => _phoneState();
}

class _phoneState extends State<phone> {
  TextEditingController t=TextEditingController();
  TextEditingController t2=TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String vid="";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(controller: t,),
          ElevatedButton(onPressed: () async {

            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91 ${t.text}',
              verificationCompleted: (PhoneAuthCredential credential) async {
                await auth.signInWithCredential(credential);
              },
              verificationFailed: (FirebaseAuthException e) {
                if (e.code == 'invalid-phone-number') {
                  print('The provided phone number is not valid.');
                }
              },
              codeSent: (String verificationId, int? resendToken) {
                print("code sent");
                vid=verificationId;
                setState(() {

                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );

          }, child: Text("Send OTP")),
          TextField(controller: t2,),
          ElevatedButton(onPressed: () async {

            String smsCode = t2.text;

            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vid,
                smsCode: smsCode);

            // Sign the user in (or link) with the credential
            await auth.signInWithCredential(credential).then((value) {
              print(value.user!.phoneNumber);
              if(value!=null)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Dashboard();
                },));
              }
            });


          }, child: Text("Verify otp")),
          OtpTextField(
            numberOfFields: 6,
            borderColor: Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) async {

              print(verificationCode);
              String smsCode = verificationCode;

              // Create a PhoneAuthCredential with the code
              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vid,
                  smsCode: smsCode);

              // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential).then((value) {
                print(value.user!.phoneNumber);
                if(value!=null)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Dashboard();
                    },));
                  }
              });

            }, // end onSubmit
          ),

        ],
      ),
    );
  }
}
