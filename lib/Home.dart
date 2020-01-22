import 'package:flutter/material.dart';
import 'package:keuangan/model/Users.dart';
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

  @override
  void initState() {
    setState(() {
      bulanan = date.month;
      tahunan = date.year;
    });
    tabController = new TabController(vsync: this, length: 4);
    super.initState();
    animationCon = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 70).animate(animationCon)
      ..addListener(() {
        setState(() {});
      });
  }

  String _dayName(int dayWeek) {
    String day;

    if (dayWeek == DateTime.monday) {
      day = "Senin";
    } else if (dayWeek == DateTime.tuesday) {
      day = "Selasa";
    } else if (dayWeek == DateTime.wednesday) {
      day = "Rabu";
    } else if (dayWeek == DateTime.thursday) {
      day = "Kamis";
    } else if (dayWeek == DateTime.friday) {
      day = "Jum'at";
    } else if (dayWeek == DateTime.saturday) {
      day = "Sabtu";
    } else if (dayWeek == DateTime.sunday) {
      day = "Minggu";
    }

    return day;
  }

  String _monthName() {
    String month;

    if (bulanan == DateTime.january)
      month = "Jan";
    else if (bulanan == DateTime.february)
      month = "Feb";
    else if (bulanan == DateTime.march)
      month = "Mar";
    else if (bulanan == DateTime.april)
      month = "Apr";
    else if (bulanan == DateTime.may)
      month = "Mei";
    else if (bulanan == DateTime.june)
      month = "Jun";
    else if (bulanan == DateTime.july)
      month = "Jul";
    else if (bulanan == DateTime.august)
      month = "Aug";
    else if (bulanan == DateTime.september)
      month = "Sep";
    else if (bulanan == DateTime.october)
      month = "Okt";
    else if (bulanan == DateTime.november)
      month = "Nov";
    else if (bulanan == DateTime.december) month = "Des";

    return month;
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
            _buttonCal(),
          ],
        ),
        drawer: drawer(),
        body: Container(
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              status(),
              Expanded(
                child: new TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    new hari.Harian(),
                    new minggu.Mingguan(),
                    new bulan.Bulanan(),
                    new tahun.Tahunan(),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: floatAnimateButton(),
      ),
    );
  }

  Widget floatAnimateButton() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Positioned(
          bottom: animation.value * 2,
          child: FloatingActionButton(
            heroTag: "Pemasukan",
            elevation: _elevation,
            child: Icon(Icons.file_upload),
            backgroundColor: Colors.green,
            onPressed: () {},
          ),
        ),
        Positioned(
          bottom: animation.value,
          child: FloatingActionButton(
            heroTag: "Pengeluaran",
            elevation: _elevation,
            child: Icon(Icons.file_download),
            backgroundColor: Colors.red,
            onPressed: () {},
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

  Widget status() {
    return new Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: new Material(
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
                  Text("0,00", style: TextStyle(color: Colors.green))
                ],
              ),
              onPressed: () {},
            ),
            new FlatButton(
              child: Column(
                children: <Widget>[
                  Text("Pengeluaran", style: TextStyle(color: Colors.black)),
                  SizedBox(height: 5.0),
                  Text("0,00", style: TextStyle(color: Colors.red))
                ],
              ),
              onPressed: () {},
            ),
            new FlatButton(
              child: Column(
                children: <Widget>[
                  Text("Saldo", style: TextStyle(color: Colors.black)),
                  SizedBox(height: 5.0),
                  Text("0,00", style: TextStyle(color: Colors.black)),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(widget.user.nama),
            accountEmail: Text(
                "${_dayName(date.weekday)}, ${date.day}/${date.month}/${date.year}"),
          ),
        ],
      ),
    );
  }

  Widget _buttonCal() {
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
        Text("${_monthName()} $tahunan"),
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
