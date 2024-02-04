// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class pageImage extends StatefulWidget {
  String imageURL = "";
  pageImage(this.imageURL);

  @override
  State<pageImage> createState() => pageImageState(imageURL);
}

class pageImageState extends State<pageImage> {
  String imageURL = "";
  pageImageState(this.imageURL);

  @override
  void initState() {
    //Buraya ilk yüklendiği anda kodlar yazılır.
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.network(
            imageURL,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          )),
    );
  }
}
