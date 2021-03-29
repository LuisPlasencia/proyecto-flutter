

import 'package:telycom_app/app/MisIncidenciasState.dart';

class AppMediator{
  static MisIncidenciasState incidenciasState;
  static AppMediator _instance;

  AppMediator(){
    incidenciasState = new MisIncidenciasState();
  }

  static AppMediator getInstance(){
    if(_instance == null){
      _instance = new AppMediator();
    }
    return _instance;
  }

  static void resetInstance(){
    _instance = null;
  }

  MisIncidenciasState getMisIncidenciasState(){
    return incidenciasState;
  }

  void setMisIncidenciasState(MisIncidenciasState state){
    incidenciasState = state;
  }

}
