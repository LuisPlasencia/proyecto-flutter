class Suceso {

  String _tipo;
  String _idSuceso;
  String _refSuceso;
  String _description;
  double _latitude;
  double _longitude;

  Suceso(this._tipo,this._idSuceso, this._refSuceso, this._description, this._latitude,
      this._longitude);


  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get refSuceso => _refSuceso;

  set refSuceso(String value) {
    _refSuceso = value;
  }

  String get idSuceso => _idSuceso;

  set idSuceso(String value) {
    _idSuceso = value;
  }
}