import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ShowSlipPage extends StatefulWidget {

  @override
  _ShowSlipPage createState() => _ShowSlipPage();
}

class _ShowSlipPage extends State<ShowSlipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: Firestore.instance.collection('payment').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            {
              return PageView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(snapshot.data.documents
                          .elementAt(index)['PathImage']),
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}