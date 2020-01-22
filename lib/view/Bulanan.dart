import 'package:flutter/material.dart';

class Bulanan extends StatefulWidget {
  @override
  _BulananState createState() => _BulananState();
}

class _BulananState extends State<Bulanan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Data Bulanan Tidak Tersedia",
            style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }
}
