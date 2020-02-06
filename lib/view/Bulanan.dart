import 'package:flutter/material.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:keuangan/model/Users.dart';
import 'package:intl/intl.dart';
import 'package:indonesia/indonesia.dart';

class Bulanan extends StatefulWidget {
  final int bulanan;
  final int tahunan;
  final Users data;

  Bulanan(this.bulanan, this.tahunan, this.data);
  @override
  _BulananState createState() => _BulananState();
}

class _BulananState extends State<Bulanan> {
  Future<List> fetchStatus(int bulan) async {
    var db = DBHelper();

    List<Map> debit = await db.select(
        "SELECT SUM(jumlah) AS pemasukan FROM detail JOIN tanggal ON detail.id_tanggal = tanggal.id_tanggal WHERE id_user = ${widget.data.pin} AND bulan = $bulan AND tahun = ${widget.tahunan} AND kode = 1");

    List<Map> kredit = await db.select(
        "SELECT SUM(jumlah) AS pengeluaran FROM detail JOIN tanggal ON detail.id_tanggal = tanggal.id_tanggal WHERE id_user = ${widget.data.pin} AND bulan = $bulan AND tahun = ${widget.tahunan} AND kode = 2");

    int _debit = debit[0]['pemasukan'] == null ? 0 : debit[0]['pemasukan'];
    int _kredit =
        kredit[0]['pengeluaran'] == null ? 0 : kredit[0]['pengeluaran'];
    return [_debit, _kredit];
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format =
        DateFormat("MMM", Localizations.localeOf(context).languageCode);
    return Container(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (ctx, i) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black38),
              ),
              color: Colors.white,
            ),
            child: FutureBuilder(
                future: fetchStatus(12 - i),
                builder: (context, snp) {
                  return ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                      ),
                      child: Text(
                        "${format.format(DateTime(widget.tahunan, 12 - i))}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      rupiah(snp.data == null ? 0 : snp.data[0],
                          trailing: '0,00'),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                    trailing: Text(
                      rupiah(snp.data == null ? 0 : snp.data[1],
                          trailing: '0,00'),
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
