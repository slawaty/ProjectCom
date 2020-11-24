import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirana/widgets/drawer.dart';
import 'slip.dart';

class Sliphistory extends StatelessWidget {
  final name = 'Sliphistory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      appBar: AppBar(title: Text("สลิป"),),
      body: ShowSlipPage(),
    );
  }
}
