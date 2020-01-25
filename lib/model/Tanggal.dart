class Tanggal {
  int idTanggal;
  int _idUser;
  int _tanggal;
  int _bulan;
  int _tahun;

  Tanggal(
    this._idUser,
    this._tanggal,
    this._bulan,
    this._tahun,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['tanggal'] = _tanggal;
    map['id_user'] = _idUser;
    map['bulan'] = _bulan;
    map['tahun'] = _tahun;

    return map;
  }
}
