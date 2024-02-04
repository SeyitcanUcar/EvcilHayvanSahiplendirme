// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectapp/api.dart';
import 'package:projectapp/contact.dart';
import 'package:projectapp/imageLook.dart';
import 'package:projectapp/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> getItemsStream() {
    return _firestore.collection('evcilHayvanlar').snapshots();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTapprofile() {
    Navigator.of(context).push(FadeRouteBuilder(page: profilePage()));
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  List<String> favoriteID = [];
  List<String> favoriteIDkey = [];
/////////////////////////////////
  final storage = FlutterSecureStorage();

  Future<void> veriYazma(String keyy, String valuee) async {
    await storage.write(key: keyy, value: valuee);
    // storage.deleteAll();
  }

  Future<void> readAllData() async {
    final storage = FlutterSecureStorage();

    try {
      Map<String, String> allData = await storage.readAll();

      if (allData.isNotEmpty) {
        allData.forEach((key, value) {
          print('Key: $key, Value: $value');
          favoriteID.add(value);
          favoriteIDkey.add(key);
        });
      } else {
        print('No data found in FlutterSecureStorage');
      }
    } catch (e) {
      print('Error reading all data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    readAllData().then((value) => print(favoriteID.length.toString()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Evcil Hayvan Sahiplendirme",
            style: GoogleFonts.montserratAlternates(
                fontSize: 23, color: Color.fromARGB(255, 0, 0, 0))),
      ), //Color.fromARGB(255, 88, 8, 8)
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: getItemsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 241, 236, 222),
                    ),
                    margin: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  //Sayfa yönlendirme
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          pageImage(data['hayvanFoto'])));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 150,
                              height: 120,
                              child: Image.network(
                                data['hayvanFoto'],
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['hayvanAdi'],
                                style: GoogleFonts.pacifico(
                                    color: Color.fromARGB(255, 246, 0, 0),
                                    fontSize: 20)),
                            Container(
                                width: 160,
                                height: 90,
                                child: Text(data['hayvanAciklamasi'],
                                    style: GoogleFonts.asap(
                                        color: Color.fromARGB(255, 40, 55, 68),
                                        fontSize: 17))),
                            Row(
                              children: [
                                Text(data['hayvanSehir'],
                                    style: GoogleFonts.asap(
                                        color: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 40, 55, 68),
                                        fontSize: 15)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("  Yaş: " + data['hayvanYas'],
                                    style: GoogleFonts.asap(
                                        color: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 72, 161, 243),
                                        fontSize: 15)),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.48,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _launchUrl(
                                            Uri.parse(data['hayvanLink']));
                                      },
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.link,
                                          size: 25,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  favoriteID.indexOf(data['hayvanID']) == -1
                                      ? InkWell(
                                          onTap: () {
////////////////
                                            Alert(
                                              onWillPopActive: true,
                                              closeIcon: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close),
                                              ),
                                              context: context,
                                              title: "FAVORİ EKLE",
                                              content: Container(
                                                  padding:
                                                      EdgeInsets.only(top: 17),
                                                  child: Text(data[
                                                          'hayvanAdi'] +
                                                      " adlı hayvanı favoriye eklemek istiyor musunuz?")),
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "İptal",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  color: Color.fromARGB(
                                                      255, 151, 79, 8),
                                                ),
                                                DialogButton(
                                                  child: Text(
                                                    "EKLE",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      veriYazma((favoriteID.length + 1).toString(), data['hayvanID']).then((value) => readAllData()
                                                          .then((value) =>
                                                              Navigator.of(context)
                                                                  .pop())
                                                          .then((value) => Fluttertoast.showToast(
                                                              msg:
                                                                  "Favoriye eklenmiştir!",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0)));
                                                    });
                                                  },
                                                  color: Color.fromARGB(
                                                      255, 8, 130, 151),
                                                )
                                              ],
                                            ).show();

                                            ///////////////////////
                                          },
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Icon(
                                              Icons.star_border,
                                              size: 25,
                                            ),
                                          ))
                                      : InkWell(
                                          onTap: () {
                                            ////////////////
                                            Alert(
                                              onWillPopActive: true,
                                              closeIcon: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close),
                                              ),
                                              context: context,
                                              title: "FAVORİ KALDIR",
                                              content: Container(
                                                  padding:
                                                      EdgeInsets.only(top: 17),
                                                  child: Text(data[
                                                          'hayvanAdi'] +
                                                      " adlı hayvanı favorikaldırmak istiyor musunuz?")),
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "İptal",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  color: Color.fromARGB(
                                                      255, 151, 79, 8),
                                                ),
                                                DialogButton(
                                                  child: Text(
                                                    "KALDIR",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      storage.delete(key: favoriteIDkey[favoriteID.indexOf(data['hayvanID'])]).then((value) => favoriteID = []).then((value) => favoriteIDkey = []).then((value) => readAllData()
                                                          .then((value) =>
                                                              Navigator.of(context)
                                                                  .pop())
                                                          .then((value) => Fluttertoast.showToast(
                                                              msg:
                                                                  "Favoriden kaldırılmıştır!",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  const Color.fromARGB(
                                                                      255,
                                                                      76,
                                                                      122,
                                                                      175),
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0)));
                                                    });
                                                  },
                                                  color: Color.fromARGB(
                                                      255, 8, 130, 151),
                                                )
                                              ],
                                            ).show();

                                            ///////////////////////
                                          },
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Icon(
                                              Icons.star_border_purple500,
                                              color: Colors.amber,
                                              size: 25,
                                            ),
                                          ))
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Wrap(
        //will break to another line on overflow
        direction: Axis.horizontal, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(FadeRouteBuilder(page: contactPage()));
                },
                child: Icon(Icons.call),
              )), //button first
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(FadeRouteBuilder(page: apiPage()));
                },
                child: Icon(Icons.api),
              )),
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () {
                  _onTapprofile();
                },
                backgroundColor: Color.fromARGB(255, 241, 236, 222),
                child: Icon(Icons.person),
              )), // button third

          // Add more buttons here
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
