
class WorkoutUtils{

  static Map getWorkoutScheduleDateList(Map _workout, Map _workoutProgression) {
    List<int> _dates = new List<int>();
    for(int j=0;j<_workoutProgression["days"].length; j++) {            
      _dates.add(_workoutProgression["days"][j]);
    }
    for(int j=0;j<_workout["rest_days"].length; j++) {
      _dates.add(_workout["rest_days"][j]);      
    }
    _dates.sort();

    Map _dateList = new Map();
    for(int j=0;j<_dates.length; j++) {      
      _dateList[_dates[j]] = true;
    }
    for(int j=0; j<_workout["rest_days"].length; j++) {
      _dateList[_workout["rest_days"][j]] = false;      
    }    
    return _dateList;

  }
}