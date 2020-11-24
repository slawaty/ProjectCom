import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirana/widgets/Paymentone.dart';
import 'package:kirana/widgets/drawer.dart';

class Payment extends StatelessWidget {
  final name = 'Payment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      appBar: AppBar(title: Text("อัปโหลดสลิป"),),
      body: Paymentone(),
    );
  }
}
