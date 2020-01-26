import 'package:flutter/material.dart';
import 'package:keuangan/model/Users.dart';

class Bulanan extends StatefulWidget {
  final int bulanan;
  final int tahunan;
  final Users data;

  Bulanan(this.bulanan, this.tahunan, this.data);
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
