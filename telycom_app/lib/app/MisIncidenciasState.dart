import 'package:flutter_map/flutter_map.dart';
import 'package:map_controller/map_controller.dart';


class MisIncidenciasState{

  Map<String, StatefulMarker> statefulMarkers;
  bool errorTimeout = false;
  bool errorSolved = true;
  bool running = false;
  int numberOfMarkers = 0;

  StatefulMapController statefulMapController = StatefulMapController(mapController: MapController()) ;
  MapController mapController = MapController();



}