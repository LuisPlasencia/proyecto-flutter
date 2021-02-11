
class ElementList {
  String _creation;
  String _reference;
  String _state;
  String _direction;

  ElementList(this._creation, this._reference, this._state, this._direction);

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
}