import 'package:flutter/material.dart';
import 'package:keuangan/model/Users.dart';

class Tahunan extends StatefulWidget {
  final int bulanan;
  final int tahunan;
  final Users data;

  Tahunan(this.bulanan, this.tahunan, this.data);
  @override
  _TahunanState createState() => _TahunanState();
}

class _TahunanState extends State<Tahunan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Data Tahunan Tidak Tersedia",
            style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }
}
