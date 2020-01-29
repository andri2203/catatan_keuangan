class Tanggal {
  int idTanggal;
  int _tanggal;
  int _bulan;
  int _tahun;
  int _time;

  Tanggal(
    this._tanggal,
    this._bulan,
    this._tahun,
    this._time,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['tanggal'] = _tanggal;
    map['bulan'] = _bulan;
    map['tahun'] = _tahun;
    map['time'] = _time;

    return map;
  }
}
