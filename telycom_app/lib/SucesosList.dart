
class SucesosList {

  String _entidad;
  String _tipificacion;
  String _localizacion;
  String _descripcion;
  String _agencia;
  String _fecha;
  String _tipoMsg;

  SucesosList(this._entidad,
      this._tipificacion, this._localizacion, this._descripcion, this._agencia, this._fecha, this._tipoMsg);

  String get fecha => _fecha;

  set fecha(String value) {
    _fecha = value;
  }

  String get entidad => _entidad;

  set entidad(String value) {
    _entidad = value;
  }

  String get localizacion => _localizacion;

  set localizacion(String value) {
    _localizacion = value;
  }

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  String get agencia => _agencia;

  set agencia(String value) {
    _agencia = value;
  }

  String get tipificacion => _tipificacion;

  set tipificacion(String value) {
    _tipificacion = value;
  }

  String get tipoMsg => _tipoMsg;

  set tipoMsg(String value) {
    _tipoMsg = value;
  }
}