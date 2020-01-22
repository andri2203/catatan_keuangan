class Users {
  int id;
  String _nama;
  String _pin;

  Users(this._nama, this._pin);

  Users.map(dynamic obj) {
    this._nama = obj['nama'];
    this._pin = obj['pin'];
  }

  String get nama => _nama;
  String get pin => _pin;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['nama'] = _nama;
    map['pin'] = _pin;

    return map;
  }

  void setUserId(int id) {
    this.id = id;
  }
}
