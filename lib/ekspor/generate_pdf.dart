import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';

class GeneratePdf {
  List data;

  final double margin = 1.5 * PdfPageFormat.mm;
  final DateFormat format = DateFormat("dd MMM yyyy");
  final DateFormat save = DateFormat("EEE_dd_MMM_yyyy_HH_mm_ss");
  final DateTime now = DateTime.now();

  Future<void> savePdf(
      {List list, List<String> Function(dynamic) forEach}) async {
    final Document pdf = new Document();
    var data1 = await rootBundle.load("font/times.ttf");
    var data2 = await rootBundle.load("font/timesbd.ttf");
    var font = Font.ttf(data1);
    var fontbd = Font.ttf(data2);
    var myStyle = TextStyle(font: font, fontBold: fontbd);

    print("${list.map(forEach).toList()}");

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.all(margin),
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) => <Widget>[
        Header(textStyle: myStyle, level: 1, text: "Data Keuangan"),
        Table.fromTextArray(context: context, data: <List<String>>[
          <String>['Tanggal', 'Kategori', 'Jumlah', 'Status'],
          ...list.map(forEach).toList(),
        ]),
      ],
    ));
    final String dir = (await getExternalStorageDirectory()).path;
    final File file = File("$dir/${save.format(now)}.pdf");
    print("$dir/${save.format(now)}.pdf");
    var create = file.writeAsBytesSync(pdf.save());
    return create;
  }
}
