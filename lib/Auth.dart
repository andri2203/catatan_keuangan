import 'package:flutter/material.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:keuangan/model/Users.dart';
import 'package:toast/toast.dart';

import './Home.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  Widget _widget;

  TextEditingController _pinLog = new TextEditingController();
  TextEditingController _pinReg = new TextEditingController();
  TextEditingController _nameReg = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _widget = login();
    });
  }

  Future registerUser() async {
    var db = DBHelper();

    var users = Users(_nameReg.text, _pinReg.text);
    await db.saveUser(users);
    setState(() {
      _pinReg.text = "";
      _nameReg.text = "";
      _widget = login();
    });
    print("Users Registered");
  }

  loginUser() async {
    var db = DBHelper();

    List<Map> data = await db.authUser(_pinLog.text);

    if (data.length > 0) {
      var _user = new Users(data[0]['nama'], data[0]['pin']);
      _user.setUserId(data[0]['id']);

      Navigator.of(context)
        ..pushReplacement(MaterialPageRoute(builder: (_) => Home(_user)));
    } else {
      Toast.show("Pin Salah Atau Belum Terdaftar", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      setState(() {
        _pinLog.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(child: _widget),
        ),
      ),
    );
  }

  Widget login() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("LOGIN",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
              )),
        ),
        TextFormField(
          controller: _pinLog,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.all(5.0),
            hintText: "Masukkan Pin Anda",
          ),
          keyboardType: TextInputType.number,
          maxLength: 5,
        ),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        RaisedButton(
          color: Colors.blue,
          child: Text("Masuk", style: TextStyle(color: Colors.white)),
          onPressed: loginUser,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "- Atau -",
            style: TextStyle(fontSize: 14, color: Colors.blue[300]),
            textAlign: TextAlign.center,
          ),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("Daftar", style: TextStyle(color: Colors.white)),
          onPressed: () {
            setState(() {
              _widget = register();
            });
          },
        ),
      ],
    );
  }

  Widget register() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("REGISTER",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
              )),
        ),
        TextFormField(
          controller: _nameReg,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.all(5.0),
            hintText: "Masukkan Nama Anda",
          ),
          keyboardType: TextInputType.text,
        ),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        TextFormField(
          controller: _pinReg,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.all(5.0),
            hintText: "Masukkan Pin Anda",
          ),
          keyboardType: TextInputType.number,
          maxLength: 5,
        ),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        RaisedButton(
          color: Colors.blue,
          child: Text("Daftar", style: TextStyle(color: Colors.white)),
          onPressed: registerUser,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "- Atau -",
            style: TextStyle(fontSize: 14, color: Colors.blue[300]),
            textAlign: TextAlign.center,
          ),
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text("Masuk", style: TextStyle(color: Colors.white)),
          onPressed: () {
            setState(() {
              _widget = login();
            });
          },
        ),
      ],
    );
  }
}
