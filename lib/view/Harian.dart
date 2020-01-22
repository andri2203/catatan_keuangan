import 'package:flutter/material.dart';

class Harian extends StatefulWidget {
  @override
  _HarianState createState() => _HarianState();
}

class _HarianState extends State<Harian> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Data Harian Tidak Tersedia",
            style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }
}
