import 'package:flutter/material.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:keuangan/model/Users.dart';
import 'package:indonesia/indonesia.dart';

class Tahunan extends StatefulWidget {
  final int bulanan;
  final int tahunan;
  final Users data;

  Tahunan(this.bulanan, this.tahunan, this.data);
  @override
  _TahunanState createState() => _TahunanState();
}

class _TahunanState extends State<Tahunan> {
  Future<List> fetchStatus(int tahun) async {
    var db = DBHelper();

    List<Map> debit = await db.select(
        "SELECT SUM(jumlah) AS pemasukan FROM detail JOIN tanggal ON detail.id_tanggal = tanggal.id_tanggal WHERE id_user = ${widget.data.pin} AND kode = 1 AND tahun = $tahun");

    List<Map> kredit = await db.select(
        "SELECT SUM(jumlah) AS pengeluaran FROM detail JOIN tanggal ON detail.id_tanggal = tanggal.id_tanggal WHERE id_user = ${widget.data.pin} AND kode = 2 AND tahun = $tahun");

    int _debit = debit[0]['pemasukan'] == null ? 0 : debit[0]['pemasukan'];
    int _kredit =
        kredit[0]['pengeluaran'] == null ? 0 : kredit[0]['pengeluaran'];
    return [_debit, _kredit];
  }

  Future<List> tahun() async {
    var db = DBHelper();

    List<Map> tahun = await db.select(
        "SELECT tanggal.* FROM tanggal JOIN detail ON detail.id_tanggal = tanggal.id_tanggal WHERE detail.id_user = ${widget.data.pin} GROUP BY tahun ORDER BY tahun DESC");
    print(tahun);
    return tahun;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: tahun(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.length,
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
                    future: fetchStatus(snapshot.data[i]['tahun']),
                    builder: (ctx, snp) {
                      return ListTile(
                        leading: Text("${snapshot.data[i]['tahun']}"),
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
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
