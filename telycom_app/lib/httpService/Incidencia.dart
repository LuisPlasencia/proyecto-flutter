import 'dart:convert';

List<Incidencia> postFromJson(String str) => List<Incidencia>.from(json.decode(str).map((x) => Incidencia.fromJson(x)));

class Incidencia {
  final int idSuceso;
  final String referencia;
  final String estado;
  final String atendido;
  final String nombreSucesoTipo;
  final String codigoSucesoTipo;
  final String nombreSubtipo;
  final String codigoSubtipo;
  final String timestampCreacion;
  final String operadorCreacion;
  final String nombrePrioridad;
  final String color;
  final String latitud;
  final String longitud;
  final String comunidad;
  final String provincia;
  final String municipio;

  Incidencia({
    this.idSuceso,
    this.referencia,
    this.estado,
    this.atendido,
    this.nombreSucesoTipo,
    this.codigoSucesoTipo,
    this.nombreSubtipo,
    this.codigoSubtipo,
    this.timestampCreacion,
    this.operadorCreacion,
    this.nombrePrioridad,
    this.color,
    this.latitud,
    this.longitud,
    this.comunidad,
    this.provincia,
    this.municipio
  });


  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      idSuceso: json['idSuceso'],
      referencia: json['referencia'],
      estado: json['estado'],
      atendido: json['atendido'],
      nombreSucesoTipo: json['nombreSucesoTipo'],
      codigoSucesoTipo: json['codigoSucesoTipo'],
      nombreSubtipo: json['nombreSubtipo'],
      codigoSubtipo: json['codigoSubtipo'],
      timestampCreacion: json['timestampCreacion'],
      operadorCreacion: json['operadorCreacion'],
      nombrePrioridad: json['nombrePrioridad'],
      color: json['color'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      comunidad: json['comunidad'],
      provincia: json['provincia'],
      municipio: json['municipio'],
    );
  }
}