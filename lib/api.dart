import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:projectapp/imageLook.dart';
import 'package:url_launcher/url_launcher.dart';

class apiPage extends StatefulWidget {
  @override
  State<apiPage> createState() => _apiPageState();
}

class foods {
  final int foodCity;
  final int foodExplane;
  final String foodName;
  final String webAdres;

  foods({
    required this.foodCity,
    required this.foodExplane,
    required this.foodName,
    required this.webAdres,
  });
}

class _apiPageState extends State<apiPage> {
  List<dynamic> _jsonData = [];
  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://api.npoint.io/f11696af9d60de1c0e33/foodsvalue'));

    if (response.statusCode == 200) {
      setState(() {
        _jsonData = jsonDecode(response.body);
        print("tttttttt==>>: " + _jsonData[0]['Img1'].toString());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //255,37, 150, 190
        backgroundColor: Color.fromARGB(255, 8, 130, 151),
        title: Text(
          "Günün Yemekleri",
          style: GoogleFonts.cinzel(
              fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: _jsonData.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 241, 236, 222),
              ),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
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
                                    pageImage(_jsonData[index]["foodImage"])));
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: 150,
                        height: 120,
                        child: Image.network(
                          _jsonData[index]["foodImage"],
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_jsonData[index]["foodName"],
                          style: GoogleFonts.pacifico(
                              color: Color.fromARGB(255, 246, 0, 0),
                              fontSize: 20)),
                      Container(
                          width: 160,
                          height: 90,
                          child: Text(_jsonData[index]["foodExplane"],
                              style: GoogleFonts.asap(
                                  color: Color.fromARGB(255, 40, 55, 68),
                                  fontSize: 17))),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  _launchUrl(
                                      Uri.parse(_jsonData[index]["webAdres"]));
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
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
