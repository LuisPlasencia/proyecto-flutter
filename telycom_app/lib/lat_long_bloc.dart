import 'dart:async';
import 'package:latlong/latlong.dart';

class LatLongBloc {
  StreamController _latLongStreamController = StreamController<LatLng>();

  Stream get latLongStream => _latLongStreamController.stream;

  dispose(){
    _latLongStreamController.close();
  }

  updateLatLong(LatLng latLong){
    _latLongStreamController.sink.add(latLong);
  }
}

final latLongBloc = LatLongBloc();