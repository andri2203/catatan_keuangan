import 'dart:io';

import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:keuangan/ekspor/generate_pdf.dart';
import 'package:keuangan/model/Users.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile extends StatefulWidget {
  final Users user;
  final bool isCSV;
  final bool isPDF;

  const SaveFile({Key key, @required this.user, this.isCSV, this.isPDF})
      : super(key: key);

  @override
  _SaveFileState createState() => _SaveFileState();
}

class _SaveFileState extends State<SaveFile> {
  final format = DateFormat("yyyy-MM-dd");
  final DateFormat save = DateFormat("EEE_dd_MMM_yyyy_HH_mm_ss");
  final newFormat = DateFormat("dd MMM yyyy");

  var formC = new TextEditingController();
  var toC = new TextEditingController();
  DateTime now = DateTime.now();

  @override
  void initState() {
    setState(() {
      formC.text = format.format(now);
      toC.text = format.format(DateTime(now.year, now.month, now.day + 10));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text("Ekspor Data", style: TextStyle(fontSize: 14)),
      ),
      content: Container(
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DateTimeField(
              controller: formC,
              decoration: InputDecoration(
                labelText: "Dari Tanggal",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(5.0),
              ),
              format: format,
              onShowPicker: (context, current) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: current ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            DateTimeField(
              controller: toC,
              decoration: InputDecoration(
                labelText: "Ke Tanggal",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(5.0),
              ),
              format: format,
              onShowPicker: (context, current) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: current ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[FlatButton(onPressed: ekspor, child: Text("Ekspor"))],
    );
  }

  Future<void> ekspor() async {
    var db = DBHelper();
    int from = DateTime.parse(formC.text).millisecondsSinceEpoch;
    int to = DateTime.parse(toC.text).millisecondsSinceEpoch;

    List<Map> _data = await db.select("SELECT detail.*, tanggal.time FROM detail " +
        "JOIN tanggal ON tanggal.id_tanggal = detail.id_tanggal " +
        "WHERE detail.id_user = ${widget.user.pin} AND tanggal.time BETWEEN $from AND $to");

    if (widget.isPDF) {
      return GeneratePdf()
          .savePdf(
              list: _data,
              forEach: (map) => <String>[
                    newFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(map['time'])),
                    map['kategori'],
                    rupiah(map['jumlah'], trailing: ',00'),
                    map['kode'] == 1 ? "Pemasukan" : "Pengeluaran",
                  ])
          .whenComplete(() => Navigator.of(context).pop());
    } else if (widget.isCSV) {
      return csv(_data).whenComplete(() => Navigator.of(context).pop());
    } else
      return;
  }

  csv(List<Map> _data) async {
    String csv = const ListToCsvConverter().convert(<List<String>>[
      <String>['Tanggal', 'Kategori', 'Jumlah', 'Status'],
      ..._data
          .map((map) => <String>[
                newFormat
                    .format(DateTime.fromMillisecondsSinceEpoch(map['time'])),
                map['kategori'],
                rupiah(map['jumlah'], trailing: ',00'),
                map['kode'] == 1 ? "Pemasukan" : "Pengeluaran",
              ])
          .toList()
    ]);

    final String dir = (await getExternalStorageDirectory()).path;
    final File file = File("$dir/${save.format(now)}.csv");
    print("$dir/${save.format(now)}.csv");
    var create = file.writeAsString(csv);
    return create;
  }
}
