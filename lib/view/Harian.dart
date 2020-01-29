import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:indonesia/indonesia.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:keuangan/model/Users.dart';

class Harian extends StatefulWidget {
  final int bulanan;
  final int tahunan;
  final Users data;

  Harian(this.bulanan, this.tahunan, this.data);
  @override
  _HarianState createState() => _HarianState();
}

class _HarianState extends State<Harian> {
  var now = DateTime.now();

  Users get user => widget.data;

  @override
  void initState() {
    super.initState();
    this.fetchData();
  }

  Future<List<Map>> fetchData() async {
    var db = DBHelper();

    List<Map> listData = await db.select(
        "SELECT tanggal.* FROM tanggal JOIN detail ON detail.id_tanggal = tanggal.id_tanggal WHERE detail.id_user = ${widget.data.pin} AND tanggal.bulan = ${widget.bulanan} AND tanggal.tahun = ${widget.tahunan} GROUP BY tanggal.id_tanggal ORDER BY tanggal DESC");

    return listData;
  }

  Future<List<Map>> fetchDetail(int idTanggal) async {
    var db = DBHelper();

    List<Map> list = await db.select(
        "SELECT * FROM detail WHERE id_user = ${widget.data.pin} AND id_tanggal = $idTanggal");

    return list;
  }

  Future<List> fetchStatus(int idTanggal) async {
    var db = DBHelper();

    List<Map> debit = await db.select(
        "SELECT SUM(jumlah) AS pemasukan FROM detail WHERE id_user = ${widget.data.pin} AND id_tanggal = $idTanggal AND kode = 1");

    List<Map> kredit = await db.select(
        "SELECT SUM(jumlah) AS pengeluaran FROM detail WHERE id_user = ${widget.data.pin} AND id_tanggal = $idTanggal AND kode = 2");

    return [debit, kredit];
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth =
        new DateTime(widget.tahunan, widget.bulanan, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  String format(String newPattern, DateTime date) {
    return DateFormat(newPattern, Localizations.localeOf(context).languageCode)
        .format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: StreamBuilder(
          stream: this.fetchData().asStream(),
          builder: (ctx, snap) {
            if (!snap.hasData)
              return Center(child: Text("Data Tida Ditemukan"));

            return ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: snap.data.length,
              itemBuilder: (context, i) {
                Map<String, dynamic> data = snap.data[i];
                DateTime tgl = new DateTime(
                  data['tahun'],
                  data['bulan'],
                  data['tanggal'],
                );

                return content(
                  context,
                  tgl: DateTime.utc(tgl.year, tgl.month, tgl.day),
                  data: data,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget content(BuildContext context,
      {DateTime tgl, Map<String, dynamic> data}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Colors.black54,
            style: BorderStyle.solid,
          )),
        ),
        child: Column(
          children: <Widget>[
            header(context, tgl, data),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Divider(),
            ),
            FutureBuilder(
              future: this.fetchDetail(data['id_tanggal']),
              builder: (ctx, snap) {
                if (!snap.hasData) return Text("Data Tidak Ada");
                return ListView.builder(
                  itemCount: snap.data.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    Map<String, dynamic> data = snap.data[i];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(data["kategori"]),
                          Text(data["keterangan"], softWrap: true),
                          Text(
                            rupiah(data['jumlah'], trailing: ',00'),
                            style: TextStyle(
                              color: data['kode'] == 1
                                  ? Colors.green
                                  : data['kode'] == 2
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context, DateTime tgl, Map<String, dynamic> data) {
    Color tColor =
        (tgl.year == now.year && tgl.month == now.month && tgl.day == now.day)
            ? Colors.blue
            : Colors.black;

    return FutureBuilder(
      future: this.fetchStatus(data['id_tanggal']),
      builder: (ctx, snap) {
        if (!snap.hasData) Text("");
        List data = snap.data;
        int pemasukan = data == null ? 0 : data[0][0]['pemasukan'];
        int pengeluaran = data == null ? 0 : data[1][0]['pengeluaran'];
        return ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(format("EEEE", tgl),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              Text(format("dd MMM yyyy", tgl),
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: tColor)),
            ],
          ),
          title: Text(
              rupiah(pemasukan == null ? 0 : pemasukan, trailing: ',00'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 10)),
          trailing: Text(
              rupiah(pengeluaran == null ? 0 : pengeluaran, trailing: ',00'),
              style: TextStyle(color: Colors.red, fontSize: 10)),
        );
      },
    );
  }
}
