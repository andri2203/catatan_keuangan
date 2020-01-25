class Detail {
  int idDetail;
  int idUser;
  int _idTanggal;
  String _kategori;
  int _jumlah;
  String _keterangan;
  int _kode;

  Detail(
    this.idUser,
    this._idTanggal,
    this._kategori,
    this._jumlah,
    this._keterangan,
    this._kode,
  );

  Detail.map(dynamic obj) {
    this.idUser = obj[''];
    this._kategori = obj[''];
    this._jumlah = obj[''];
    this._keterangan = obj[''];
    this._kode = obj[''];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id_user'] = idUser;
    map['id_tanggal'] = _idTanggal;
    map['kategori'] = _kategori;
    map['jumlah'] = _jumlah;
    map['keterangan'] = _keterangan;
    map['kode'] = _kode;

    return map;
  }
}
