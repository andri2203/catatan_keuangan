import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Mingguan extends StatefulWidget {
  final int bulanan;
  final int tahunan;

  Mingguan(this.bulanan, this.tahunan);
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

  

  bool ifDayInWeek(DateTime first, DateTime last) {
    var _first = now.subtract(new Duration(days: now.weekday));
    var _last = new DateTime(_first.year, _first.month, _first.day + 6);

    if (now.year == first.year || now.year == last.year) {
      if (now.month == first.month || now.month == last.month) {
        if (_first.day == first.day && _last.day == last.day) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
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
    DateFormat format = DateFormat("dd MMM");

    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, i) {
          int index = 6;
          dayInMonth -= 7;
          DateTime date = weekInMonth(dayInMonth);
          DateTime first = date.subtract(new Duration(days: date.weekday));
          DateTime last = new DateTime(first.year, first.month, first.day + 6);

          Color boxColor =
              (ifDayInWeek(first, last)) ? Colors.yellow[600] : Colors.grey;

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
                            color: boxColor,
                          ),
                          child: Text(
                            "${format.format(first)} ~ ${format.format(last)}",
                            style: TextStyle(fontSize: 9, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    title:
                        Text("Rp. 0,00", style: TextStyle(color: Colors.green)),
                    trailing:
                        Text("Rp. 0,00", style: TextStyle(color: Colors.red)),
                  ),
                )
              : Text("");
        },
      ),
    );
  }
}
