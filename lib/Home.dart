import 'package:keuangan/helper/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/model/SaveFile.dart';
import 'package:keuangan/model/Users.dart';
import 'package:keuangan/view/InputData.dart';
import 'package:intl/intl.dart';
import 'package:indonesia/indonesia.dart';

import './view/Harian.dart' as hari;
import './view/Mingguan.dart' as minggu;
import './view/Bulanan.dart' as bulan;
import './view/Tahunan.dart' as tahun;

class Home extends StatefulWidget {
  final Users user;

  Home(this.user);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;
  AnimationController animationCon;
  Animation<double> animation;
  bool currentState = true;
  double _elevation = 0;
  var date = DateTime.now();
  int bulanan;
  int tahunan;
  int pemasukan = 0;
  int pengeluaran = 0;
  ScrollController _controller;

  @override
  void initState() {
    setState(() {
      bulanan = date.month;
      tahunan = date.year;
    });
    _controller = new ScrollController();
    tabController = new TabController(vsync: this, length: 4);
    super.initState();
    animationCon = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 70).animate(animationCon)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<List> data() async {
    var db = DBHelper();

    List<Map> _data = await db.select(
        "SELECT SUM(jumlah) AS debit FROM detail WHERE id_user = ${widget.user.pin} AND kode = 1");
    List<Map> _data1 = await db.select(
        "SELECT SUM(jumlah) AS kredit FROM detail WHERE id_user = ${widget.user.pin} AND kode = 2");

    int debit = _data[0]['debit'] == null ? 0 : _data[0]['debit'];
    int kredit = _data1[0]['kredit'] == null ? 0 : _data1[0]['kredit'];
    int saldo = debit - kredit;
    return [debit, kredit, saldo];
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Keuangan'),
          bottom: new TabBar(
            labelPadding: EdgeInsets.all(5.0),
            controller: tabController,
            tabs: <Widget>[
              new Tab(child: Text("Harian", style: TextStyle(fontSize: 14))),
              new Tab(child: Text("Mingguan", style: TextStyle(fontSize: 14))),
              new Tab(child: Text("Bulanan", style: TextStyle(fontSize: 14))),
              new Tab(child: Text("Tahunan", style: TextStyle(fontSize: 14))),
            ],
          ),
          actions: <Widget>[
            _buttonCal(context),
          ],
        ),
        drawer: drawer(context),
        body: Container(
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              status(context),
              Expanded(
                child: Scrollbar(
                  controller: _controller,
                  child: new TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      new hari.Harian(bulanan, tahunan, widget.user),
                      new minggu.Mingguan(bulanan, tahunan, widget.user),
                      new bulan.Bulanan(bulanan, tahunan, widget.user),
                      new tahun.Tahunan(bulanan, tahunan, widget.user),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: floatAnimateButton(context),
      ),
    );
  }

  Widget floatAnimateButton(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Positioned(
          bottom: animation.value * 2,
          child: FloatingActionButton(
            heroTag: "Pemasukan",
            tooltip: "Pemasukan",
            elevation: _elevation,
            child: Icon(Icons.file_download),
            backgroundColor: Colors.green,
            onPressed: () {
              setState(() {
                _elevation = 0.0;
                currentState = true;
              });
              animationCon.reverse();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => InputData("Pemasukan", 1, widget.user)));
            },
          ),
        ),
        Positioned(
          bottom: animation.value,
          child: FloatingActionButton(
            heroTag: "Pengeluaran",
            tooltip: "Pengeluaran",
            elevation: _elevation,
            child: Icon(Icons.file_upload),
            backgroundColor: Colors.red,
            onPressed: () {
              animationCon.reverse();
              setState(() {
                _elevation = 0.0;
                currentState = true;
              });
              animationCon.reverse();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => InputData("Pengeluaran", 2, widget.user)));
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: FloatingActionButton(
            heroTag: "Add",
            elevation: 10.0,
            child: Icon(Icons.add),
            onPressed: () {
              if (currentState == true) {
                animationCon.forward();
                setState(() {
                  _elevation = 10.0;
                  currentState = false;
                });
              } else {
                animationCon.reverse();
                setState(() {
                  _elevation = 0.0;
                  currentState = true;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget status(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: StreamBuilder(
        stream: data().asStream(),
        builder: (ctx, snap) {
          var debit = snap.data == null ? 0 : snap.data[0];
          var kredit = snap.data == null ? 0 : snap.data[1];
          var saldo = snap.data == null ? 0 : snap.data[2];
          return new Material(
            elevation: 5,
            color: Colors.white,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new FlatButton(
                  child: Column(
                    children: <Widget>[
                      Text("Pemasukan", style: TextStyle(color: Colors.black)),
                      SizedBox(height: 5.0),
                      Text(rupiah(debit == null ? 0 : debit, trailing: ',00'),
                          style: TextStyle(color: Colors.green, fontSize: 10))
                    ],
                  ),
                  onPressed: () {},
                ),
                new FlatButton(
                  child: Column(
                    children: <Widget>[
                      Text("Pengeluaran",
                          style: TextStyle(color: Colors.black)),
                      SizedBox(height: 5.0),
                      Text(rupiah(kredit == null ? 0 : kredit, trailing: ',00'),
                          style: TextStyle(color: Colors.red, fontSize: 10))
                    ],
                  ),
                  onPressed: () {},
                ),
                new FlatButton(
                  child: Column(
                    children: <Widget>[
                      Text("Saldo", style: TextStyle(color: Colors.black)),
                      SizedBox(height: 5.0),
                      Text(rupiah(saldo == null ? 0 : saldo, trailing: ',00'),
                          style: TextStyle(color: Colors.black, fontSize: 10)),
                    ],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget drawer(BuildContext context) {
    DateFormat format = DateFormat(
      "EEEE, dd MMM yyyy",
      Localizations.localeOf(context).languageCode,
    );
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(widget.user.nama),
            accountEmail: Text(format.format(date.toLocal())),
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text("Ekspor PDF"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              showDialog(
                child: SaveFile(user: widget.user, isPDF: true, isCSV: false),
                context: context,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_file),
            title: Text("Ekspor Excel"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              showDialog(
                child: SaveFile(user: widget.user, isCSV: true, isPDF: false),
                context: context,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Keluar"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => Navigator.of(context).popAndPushNamed('/'),
          ),
        ],
      ),
    );
  }

  Widget _buttonCal(BuildContext context) {
    DateFormat format = DateFormat(
      "MMM yyyy",
      Localizations.localeOf(context).languageCode,
    );

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              bulanan--;
              if (bulanan < 1) {
                bulanan = 12;
                tahunan--;
              }
              print(bulanan);
            });
          },
        ),
        Text(format.format(new DateTime(tahunan, bulanan, date.day))),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            setState(() {
              bulanan++;
              if (bulanan > 12) {
                bulanan = 1;
                tahunan++;
              }
              print(bulanan);
            });
          },
        ),
      ],
    );
  }
}

Widget statusNull(BuildContext context) {
  int debit = 0;
  int kredit = 0;
  return Material(
    elevation: 5,
    color: Colors.white,
    child: ButtonBar(
      alignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new FlatButton(
          child: Column(
            children: <Widget>[
              Text("Pemasukan", style: TextStyle(color: Colors.black)),
              SizedBox(height: 5.0),
              Text(rupiah(debit, trailing: ',00'),
                  style: TextStyle(color: Colors.green, fontSize: 10))
            ],
          ),
          onPressed: () {},
        ),
        new FlatButton(
          child: Column(
            children: <Widget>[
              Text("Pengeluaran", style: TextStyle(color: Colors.black)),
              SizedBox(height: 5.0),
              Text(rupiah(kredit, trailing: ',00'),
                  style: TextStyle(color: Colors.red, fontSize: 10))
            ],
          ),
          onPressed: () {},
        ),
        new FlatButton(
          child: Column(
            children: <Widget>[
              Text("Saldo", style: TextStyle(color: Colors.black)),
              SizedBox(height: 5.0),
              Text(rupiah(debit - kredit, trailing: ',00'),
                  style: TextStyle(color: Colors.black, fontSize: 10)),
            ],
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}
