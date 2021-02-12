class ElementList {
  String _creation;
  String _reference;
  String _state;
  String _direction;
  double _latitud;
  double _longitud;
  String _description;

  ElementList(this._creation, this._reference, this._state, this._direction, this._description, this._latitud, this._longitud);

  String get creation => _creation;
  set creation(String value) {
    _creation = value;
  }

  String get reference => _reference;
  set reference(String value) {
    _reference = value;
  }

  String get state => _state;
  set state(String value) {
    _state = value;
  }

  String get direction => _direction;
  set direction(String value) {
    _direction = value;
  }

  double get longitud => _longitud;

  set longitud(double value) {
    _longitud = value;
  }

  double get latitud => _latitud;

  set latitud(double value) {
    _latitud = value;
  }

  String get description => _description;
  set description(String value) {
    _description = value;
  }
}