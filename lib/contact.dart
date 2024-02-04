import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class contactPage extends StatefulWidget {
  @override
  State<contactPage> createState() => _contactPageState();
}

class _contactPageState extends State<contactPage> {
  TextEditingController controllerKonu = new TextEditingController();
  TextEditingController controllerAciklama = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //255,37, 150, 190
        backgroundColor: Color.fromARGB(255, 8, 130, 151),
        title: Text(
          "İletişim",
          style: GoogleFonts.cinzel(
              fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Center(
          child: Container(
        child: Column(
          children: [
            TextFieldContainer(
              child: TextFormField(
                controller: controllerKonu,
                onEditingComplete: () => TextInput.finishAutofillContext(),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Konu',
                    hintText: "Konuyu girin..."),
                onChanged: (value) {},
                validator: (value) {
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 300,
              child: TextFieldContainer(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: controllerAciklama,
                  onEditingComplete: () => TextInput.finishAutofillContext(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Açıklama',
                      hintText: "Bir açıklama girin..."),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            FlutterIconButton(
              buttonText: 'Mail Gönder',
              buttonColor: Colors.green,
              buttonIcon: const Icon(Icons.send),
              onTap: () {
                FlutterEmailSender.send(Email(
                    body: controllerAciklama.text,
                    subject: controllerKonu.text,
                    recipients: ['admin@gmail.com']));
              },
            ),
          ],
        ),
      )),
    );
  }
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
