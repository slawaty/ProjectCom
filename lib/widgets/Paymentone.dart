import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kirana/models/items.dart';
import 'package:kirana/models/shop.dart';
import 'package:kirana/models/shops.dart';
import 'package:kirana/models/user.dart';
import 'package:kirana/pages/items.dart';
import 'package:kirana/widgets/ImagePicker.dart';
import 'package:kirana/widgets/TextFieldWidget.dart';
import 'package:kirana/models/Item.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Paymentone extends StatefulWidget {
  @override
  _PaymentoneState createState() => _PaymentoneState();
}

class _PaymentoneState extends State<Paymentone> {
  final name = 'Payment';
  final _formKey = GlobalKey<FormState>();

  String imageurl = '';
  File itemimage;
  int id;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadImage() async {
    StorageReference reference = _storage.ref().child('Payment/');
    StorageUploadTask uploadTask = reference
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(itemimage);
    if (uploadTask.isComplete) {
      if (uploadTask.isSuccessful) {
        final String url = await reference.getDownloadURL();
        print("The download URL is " + url);
        setState(() {
          imageurl = url;
        });
      } else {
        isLoading = false;
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Error uploading pic"),
          backgroundColor: Colors.red,
        ));
      }
    } else if (uploadTask.isInProgress) {
      uploadTask.events.listen((event) {
        double percentage = 100 *
            (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble());
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      imageurl = await storageTaskSnapshot.ref.getDownloadURL();

      //Here you can get the download URL when the task has been completed.
      print("Download URL " + imageurl.toString());
    } else {
      isLoading = false;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Error uploading pic"),
        backgroundColor: Colors.red,
      ));
      return imageurl;
    }
    insertPaymentToFirestore();
  }

  Future<void> insertPaymentToFirestore() async {
    Firestore firestore = Firestore.instance;

    Map<String, dynamic> map = Map();
    map['PathImage'] = imageurl;
  
    await firestore
        .collection('payment')
        .document()
        .setData(map)
        .then((value) {});
  }
  


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(children: [
        ItemImagePicker(
          notifyParent: setUrl,
          fromEdit: false,
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: !isLoading
                ? RaisedButton(
                    child: Text(
                      "ยืนยัน".toUpperCase(),
                      style: TextStyle(color: Colors.white, letterSpacing: 1),
                    ),
                    color: Colors.green[700],
                    onPressed: () async {
                      setState(() {});
                      if (_formKey.currentState.validate() &&
                          itemimage != null) {
                        setState(() {
                          isLoading = true;
                        });

                        await uploadImage();
                        id = new DateTime.now().millisecondsSinceEpoch;
                        if (imageurl == "") {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Upload failed please check internet connection")));
                          isLoading = false;
                        } else {
                          // _additem_to_container();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemsPage()));
                        }
                      } else if (itemimage == null) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("select an image")));
                        isLoading = false;
                      }
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        )
      ]),
    );
  }

  void setUrl(File image) {
    setState(() {
      itemimage = image;
      print("image setted");
      if (itemimage == null) {
        print("done");
      }
    });
  }
}
