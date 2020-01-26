import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:keuangan/model/Users.dart';

class Mingguan extends StatefulWidget {
  final int bulanan;
  final int tahunan;
  final Users data;

  Mingguan(this.bulanan, this.tahunan, this.data);
  @override
  _MingguanState createState() => _MingguanState();
}

class _MingguanState extends State<Mingguan> {
  var now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth =
        new DateTime(widget.tahunan, widget.bulanan, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  DateTime weekInMonth(int dayInMonth) {
    var date = new DateTime(widget.tahunan, widget.bulanan, dayInMonth);

    return date;
  }

  bool ifWeekInYear(DateTime first, DateTime last) {
    if (first.year >= widget.tahunan) {
      if (first.month >= widget.bulanan || first.month + 1 <= last.month) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    int dayInMonth = daysInMonth(now) + 7;
    DateFormat format =
        DateFormat("dd MMM", Localizations.localeOf(context).languageCode);

    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, i) {
          int index = 6;
          dayInMonth -= 7;
          DateTime date = weekInMonth(dayInMonth);
          DateTime first = date.subtract(new Duration(days: date.weekday));
          DateTime last = new DateTime(first.year, first.month, first.day + 6);

          return ifWeekInYear(first, last)
              ? Material(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    leading: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Minggu ${index - i}",
                            style: TextStyle(fontSize: 9, color: Colors.black)),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey,
                          ),
                          child: Text(
                            "${format.format(first)} ~ ${format.format(last)}",
                            style: TextStyle(fontSize: 9, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    title: FutureBuilder(
                        future: debit(first, last),
                        builder: (context, snapshot) {
                          return Text("Rp. 0,00",
                              style: TextStyle(color: Colors.green));
                        }),
                    trailing: FutureBuilder(
                        future: null,
                        builder: (context, snapshot) {
                          return Text("Rp. 0,00",
                              style: TextStyle(color: Colors.red));
                        }),
                  ),
                )
              : Text("");
        },
      ),
    );
  }

  Future<List<Map>> debit(DateTime first, DateTime last) async {
    var db = DBHelper();

    List<Map> _data = await db.select(
        "SELECT SUM(jumlah) FROM detail INNER JOIN tanggal ON tanggal.id_tanggal = detail.id_tanggal WHERE detail.id_user = ${widget.data.pin} AND detail.kode = 1 AND ");
    print(_data);
    return _data;
  }

  Future<List<Map>> kredit() async {
    var db = DBHelper();

    List<Map> _data = await db.select(
        "SELECT SUM(jumlah) AS kredit FROM detail WHERE id_user = ${widget.data.pin} AND kode = 2");
    return _data;
  }
}
