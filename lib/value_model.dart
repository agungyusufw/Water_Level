class ValueModel{
  String _serial;
  String _nama;
  String _value;
  String _status;


  ValueModel(this._serial, this._nama, this._value, this._status);

  String get serial => _serial;

  set serial(String value) {
    _serial = value;
  }

  String get nama => _nama;

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }

  set nama(String value) {
    _nama = value;
  }
}