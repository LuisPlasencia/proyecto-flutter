import 'package:map_controller/map_controller.dart';


class MisIncidenciasState{

  Map<String, StatefulMarker> statefulMarkers;
  bool errorTimeout = false;
  bool running = false;
  int numberOfMarkers = 0;

}