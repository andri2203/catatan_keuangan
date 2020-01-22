import 'package:flutter/material.dart';

class Tahunan extends StatefulWidget {
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
