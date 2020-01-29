import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
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
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, i) {
          dayInMonth -= 7;
          DateTime date = weekInMonth(dayInMonth);
          DateTime first = date.subtract(new Duration(days: date.weekday));
          DateTime last = new DateTime(first.year, first.month, first.day + 6);

          if (ifWeekInYear(first, last)) {
            return Material(
              color: Colors.white,
              elevation: 5,
              child: ListTile(
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Minggu ${i + 1}",
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
                      var debit =
                          snapshot.data == null ? 0 : snapshot.data[0]['debit'];
                      return Text(
                          rupiah(debit == null ? 0 : debit, trailing: ",00"),
                          style: TextStyle(color: Colors.green));
                    }),
                trailing: FutureBuilder(
                    future: kredit(first, last),
                    builder: (context, snapshot) {
                      var kredit = snapshot.data == null
                          ? 0
                          : snapshot.data[0]['kredit'];
                      return Text(
                          rupiah(kredit == null ? 0 : kredit, trailing: ",00"),
                          style: TextStyle(color: Colors.red));
                    }),
              ),
            );
          } else {
            return Text("");
          }
        },
      ),
    );
  }

  Future<List<Map>> debit(DateTime f, DateTime l) async {
    var db = DBHelper();
    String ketentuan =
        "WHERE detail.kode = 1 AND tanggal.time BETWEEN ${f.millisecondsSinceEpoch} AND ${l.millisecondsSinceEpoch}";

    List<Map> _data = await db.select(
        "SELECT SUM(jumlah) AS debit FROM detail INNER JOIN tanggal ON tanggal.id_tanggal = detail.id_tanggal " +
            ketentuan);
    return _data == null
        ? [
            {'debit': 0}
          ]
        : _data;
  }

  Future<List<Map>> kredit(DateTime f, DateTime l) async {
    var db = DBHelper();
    String ketentuan =
        "WHERE detail.kode = 2 AND tanggal.time BETWEEN ${f.millisecondsSinceEpoch} AND ${l.millisecondsSinceEpoch}";

    List<Map> _data = await db.select(
        "SELECT SUM(jumlah) AS kredit FROM detail INNER JOIN tanggal ON tanggal.id_tanggal = detail.id_tanggal " +
            ketentuan);
    return _data == null
        ? [
            {'kredit': 0}
          ]
        : _data;
  }
}
