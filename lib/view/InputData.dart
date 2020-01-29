import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:keuangan/helper/DBHelper.dart';
import 'package:keuangan/model/Tanggal.dart';
import 'package:keuangan/model/Users.dart';
import 'package:keuangan/model/Detail.dart';

class InputData extends StatefulWidget {
  final String title;
  final int kode;
  final Users users;

  InputData(this.title, this.kode, this.users);

  @override
  _InputDataState createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  final format = DateFormat("yyyy-MM-dd");

  var dateControl = new TextEditingController();
  var katControl = new TextEditingController();
  var jumControl = new TextEditingController();
  var ketControl = new TextEditingController();
  var now = DateTime.now();

  var inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.all(5.0),
  );

  @override
  void initState() {
    setState(() {
      dateControl.text = format.format(now);
    });
    super.initState();
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
    List<Map> data = await db.checkTanggal(date);
    int id =
        data.length > 0 ? data[0]['id_tanggal'] : await db.saveTanggal(tanggal);

    var detail = Detail(
      int.parse(widget.users.pin),
      id,
      katControl.text,
      int.parse(jumControl.text),
      ketControl.text,
      widget.kode,
    );

    print(detail.toMap());

    var qry = await db.saveDetail(detail);

    print("$qry");

    setState(() {
      dateControl.text = format.format(DateTime.now());
      katControl.text = '';
      jumControl.text = '';
      ketControl.text = '';
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          backgroundColor: Colors.blue,
          onPressed: () => saveData(context),
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
}
