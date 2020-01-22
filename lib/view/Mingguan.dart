import 'package:flutter/material.dart';

class Mingguan extends StatefulWidget {
  @override
  _MingguanState createState() => _MingguanState();
}

class _MingguanState extends State<Mingguan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Data Mingguan Tidak Tersedia",
            style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }
}
