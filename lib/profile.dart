// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:projectapp/loginScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class profilePage extends StatefulWidget {
  @override
  State<profilePage> createState() => profilePagePageState();
}

class profilePagePageState extends State<profilePage> {
  String name = "", tel = "", mail = "";

  Future<void> getData() async {
    try {
      CollectionReference dataCollection =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await dataCollection.get();
      querySnapshot.docs.forEach((doc) {
        setState(() {
          print("GİRİŞ YAPAN: " +
              FirebaseAuth.instance.currentUser!.uid.toString());
          if (doc["userID"] ==
              FirebaseAuth.instance.currentUser!.uid.toString()) {
            name = doc["userNameSurName"];
            tel = doc["userTelephone"];
            mail = doc["useremail"];
          }
        });
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //255,37, 150, 190
        backgroundColor: Color.fromARGB(255, 8, 130, 151),
        title: Text(
          "Profil",
          style: GoogleFonts.cinzel(
              fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 76, 132, 175).withAlpha(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Ad Soyad: ",
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
                    )
                  ],
                )),
            SizedBox(
              height: 7,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 76, 132, 175).withAlpha(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Telefon: ",
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      tel,
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
                    )
                  ],
                )),
            SizedBox(
              height: 7,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 76, 132, 175).withAlpha(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Email: ",
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      mail,
                      textAlign: TextAlign.left,
                      style:
                          GoogleFonts.ubuntu(fontSize: 20, color: Colors.black),
                    )
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            FlutterIconButton(
              buttonText: 'ÇIKIŞ YAP',
              buttonColor: Colors.green,
              buttonIcon: const Icon(Icons.logout_sharp),
              onTap: () {
                /////////////////
                Alert(
                  onWillPopActive: true,
                  closeIcon: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                  context: context,
                  title: "ÇIKIŞ",
                  content: Container(
                      padding: EdgeInsets.only(top: 17),
                      child: Text("Çıkış yapmayı onaylıyor musunuz?")),
                  buttons: [
                    DialogButton(
                      child: Text(
                        "İptal",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Color.fromARGB(255, 151, 79, 8),
                    ),
                    DialogButton(
                      child: Text(
                        "ÇIKIŞ YAP",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance
                            .signOut() .then((value) => Navigator.of(context).pop()) .then((value) => Navigator.of(context).pop())
                            ;
                            /*
                            .then((value) => Navigator.of(context).pop())
                            .then((value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => loginScreen()))
                                    
                                    ) */
                      },
                      color: Color.fromARGB(255, 8, 130, 151),
                    )
                  ],
                ).show();
                //////////////////////
              },
            ),
          ],
        ),
      ),
    );
  }
}
