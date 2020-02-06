import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:keuangan/model/Tanggal.dart';
import 'package:keuangan/model/Users.dart';
import 'package:keuangan/model/Detail.dart';

class UpdateData extends StatefulWidget {
  final Users users;
  final Map<String, dynamic> data;
  final DateTime date;

  UpdateData(this.users, this.data, this.date);

  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final format = DateFormat("yyyy-MM-dd");
  Map<String, dynamic> get data => widget.data;

  var dateControl = new TextEditingController();
  var katControl = new TextEditingController();
  var jumControl = new TextEditingController();
  var ketControl = new TextEditingController();
  DateTime get now => widget.date;

  var inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.all(5.0),
  );

  @override
  void initState() {
    print(data);
    setState(() {
      dateControl.text = format.format(now);
      katControl.text = data['kategori'];
      jumControl.text = data['jumlah'].toString();
      ketControl.text = data['keterangan'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update'),
        ),
        floatingActionButton: Column(
          verticalDirection: VerticalDirection.up,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'hapus',
              child: Icon(Icons.restore_from_trash),
              backgroundColor: Colors.red,
              onPressed: () {},
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: 'update',
              child: Icon(Icons.edit),
              backgroundColor: Colors.green,
              onPressed: () => saveData(context),
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                elevation: 5.0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      formField(
                        title: "Tanggal",
                        widget: DateTimeField(
                          controller: dateControl,
                          decoration: InputDecoration(
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
                      ),
                      formField(
                          title: "Kategori",
                          widget: TextFormField(
                            controller: katControl,
                            decoration: inputDecoration,
                          )),
                      formField(
                          title: "Jumlah",
                          widget: TextFormField(
                            controller: jumControl,
                            decoration: inputDecoration,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                          )),
                      formField(
                          title: "Keterangan",
                          widget: TextFormField(
                            controller: ketControl,
                            decoration: inputDecoration,
                            maxLength: 50,
                            maxLines: 1,
                            keyboardType: TextInputType.multiline,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formField({@required String title, @required Widget widget}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(title),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: widget,
          ),
        ],
      ),
    );
  }

  Future saveData(BuildContext context) async {
    var db = DBHelper();
    var date = DateTime.parse(dateControl.text);

    var tanggal = Tanggal(
      date.day,
      date.month,
      date.year,
      date.millisecondsSinceEpoch,
    );
    List<Map> _data = await db.checkTanggal(date);
    int id = _data.length > 0
        ? _data[0]['id_tanggal']
        : await db.saveTanggal(tanggal);

    var detail = Detail(
      int.parse(widget.users.pin),
      id,
      katControl.text,
      int.parse(jumControl.text),
      ketControl.text,
      data['kode'],
    );

    await db.updateDetail(detail, data['id_detail']);

    setState(() {
      dateControl.text = format.format(DateTime.now());
      katControl.text = '';
      jumControl.text = '';
      ketControl.text = '';
    });

    Navigator.of(context).pop();
  }
}
