import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/exercise/exercise_network.dart';
import 'package:gomotive/exercise/exercise_actions.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/components/multiselect.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/exercise/views/exercise_list.dart';

class ExerciseFilter extends StatelessWidget {
  final Map exerciseSearchParams;
  final String usageType;
  final int clientId;
  final int engagementId;

  ExerciseFilter({
    this.exerciseSearchParams,
    this.usageType,
    this.clientId,
    this.engagementId,
  });


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ExerciseFilter(
          exerciseSearchParams: this.exerciseSearchParams,
          usageType: this.usageType,
          clientId: this.clientId,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _ExerciseFilter extends StatefulWidget {
  final Map exerciseSearchParams;
  final String usageType;
  final int clientId;
  final int engagementId;

  _ExerciseFilter({
    this.exerciseSearchParams,
    this.usageType,
    this.clientId,
    this.engagementId,
  });

  @override
  _ExerciseFilterState createState() => new _ExerciseFilterState();
}

class _ExerciseFilterState extends State<_ExerciseFilter> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  
  TextEditingController _searchController = new TextEditingController();

  var _performanceDataList = [
    { "id": "ANALYSIS_MOBILITY", "name": "Mobility" },
    { "id": "ANALYSIS_STABILITY", "name": "Stability" },
    { "id": "PERFORMANCE_SUPPORT", "name": "Performance - Support" },
    { "id": "PERFORMANCE_ELEVATED_LUNGELEG", "name": "Performance - Elevated (Lunge Leg)" },
    { "id": "PERFORMANCE_FIXEDTRUNK", "name": "Performance - Fixed Trunk" },
    { "id": "PERFORMANCE_UNILATERALHANDSWING", "name": "Performance - Unilateral Hand Swing" },
    { "id": "PERFORMANCE_PLANE_HANDS", "name": "Performance - Plane (Hands)" },
    { "id": "PERFORMANCE_HYBRID_HANDS", "name": "Performance - Hybrid (Hands)" },
    { "id": "PERFORMANCE_HYBRID_FOOT", "name": "Performance - Hybrid (Foot)" },
    { "id": "PERFORMANCE_PIVOT_IN_CHAIN", "name": "Performance - Pivot (In-Chain)" },
    { "id": "PERFORMANCE_PIVOT_OUT_OF_CHAIN", "name": "Performance - Pivot (Out-of-Chain)" },
    { "id": "PERFORMANCE_LOAD", "name": "Performance - Load" },
    { "id": "PERFORMANCE_ELEVATED_STANCELEG", "name": "Performance - Elevated (Stance Leg)" },
    { "id": "PERFORMANCE_LOCOMOTOR", "name": "Performance - Locomotor" },
    { "id": "PERFORMANCE_SPHERICAL", "name": "Performance - Spherical" }
];

var _mostabilityDataList = [
    { "id": "MOBILITY", "name": "Mobility" },
    { "id": "STABILITY", "name": "Stability" }
];

var _matricDataList = [
    { "id": "ANT", "name": "ANT" },
    { "id": "PST", "name": "PST" },
    { "id": "SSL", "name": "SSL" },
    { "id": "OSL", "name": "OSL" },
    { "id": "SSR", "name": "SSR" },
    { "id": "OSR", "name": "OSR" }
];


  var _getSearchParamsExerciseAPI, _clearExerciseListActionCreator;

  List<Map> _exerciseCategoryList, 
            _exerciseMetricList, 
            _exerciseBodyPartList,
            _exerciseDifficultyList,
            _cueList, 
            _equipmentList, 
            _exerciseTypesList, 
            _exerciseActionList, 
            _exerciseDriverList, 
            _exerciseDirectionList,
            _partnerList,
            _giGolfLevel1FilterList,
            _giGolfLevel2FilterList,
            _giGolfLevel3FilterList;
  
  List<dynamic> _selectedPartnerList;
  List<dynamic> _exerciseMetricSelectedList, 
                _exerciseBodyPartSelectedList, 
                _exerciseDifficultyLevelSelectedList,
                _exerciseCueSelectdList,
                _exerciseEquipmentSelectedList,
                _exerciseTypeSelectedList,
                _exerciseActionSelectedList,
                _exerciseDriverSelectedList;

  Map _searchParams, _searchParamsFilterData;
  bool  _isFavorite,
        _isEvidenceBased, 
        _threedmapsFilterEnabled, 
        _golfFilterEnabled, 
        _myExercises, 
        _myPracticeExercises; 
     
  String _threedmapsPerformanceData, _threedmapsMostabilityData, _threedmapsMatricData;
  String _golfLevel1Filter, _golfLevel2Filter, _golfLevel3Filter;
  String _exerciseCategoryId;
  
  List<Widget> _listPartners() {
    List<Widget> _list = new List<Widget>();
    Container _myExerciseContainer = new Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12
          ),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            'My Exercises',
            style: TextStyle(
              fontSize: 16.0,
            )
          ),
          new Switch(
            value: _myExercises,
            activeColor: Colors.green,
            onChanged: (bool value) {
              _myExercises = value;
            }                           
          )
        ],
      )
    );
    _list.add(_myExerciseContainer);
    Container _myPracticeExerciseContainer = new Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12
          ),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            'My Practice Exercises',
            style: TextStyle(
              fontSize: 16.0,
            )
          ),
          new Switch(
            value: _myPracticeExercises,
            activeColor: Colors.green,
            onChanged: (bool value) {
              _myPracticeExercises = value;
            }                           
          )
        ],
      )
    );
    _list.add(_myPracticeExerciseContainer);
    for(int i=0; i<_partnerList.length; i++){      
      bool _selectedValue = false;
      for(int j=0; j<_selectedPartnerList.length; j++) {
        if(_partnerList[i]["id"] ==_selectedPartnerList[j]) {
          _selectedValue = true;
          _partnerList[i]["value"] = true;
          break;          
        } else {
          _partnerList[i]["value"] = false;
        }
      }
      Container _container = new Container(
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12
            ),
          ),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              _partnerList[i]["name"],
              style: TextStyle(
                fontSize: 16.0,
              )
            ),
            new Switch(
              value: _selectedValue,
              activeColor: Colors.green,              
              onChanged: (bool value) {
                _partnerList[i]["value"] = value;
              }                           
            )
          ],
        )
      );
      _list.add(_container);
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _clearExerciseListActionCreator = stateObject["clearExerciseListActionCreator"];
        _getSearchParamsExerciseAPI = stateObject["getSearchParamsExercise"];   
        if(stateObject["searchParams"] != null) {
          _getSearchParamsExerciseAPI(context, stateObject["searchParams"]);
        }        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getSearchParamsExercise"] = (BuildContext context, Map params) =>
            store.dispatch(getExerciseSearchParams(context, params));
        returnObject["clearExerciseListActionCreator"] = () =>
            store.dispatch(ClearExerciseListActionCreator());                        
        returnObject["searchParamsFilterData"] = store.state.exerciseState.searchParamsFilterData;            
        returnObject["searchParams"] = store.state.exerciseState.searchParams;
        if(returnObject["searchParams"] != null) {
          if(returnObject["searchParams"].containsKey('is_favorite')) {
            _isFavorite =returnObject["searchParams"]['is_favorite'];
          } else {
            _isFavorite = false;
          }
          if(returnObject["searchParams"].containsKey('is_evidence_based')) {
            _isEvidenceBased =returnObject["searchParams"]['is_evidence_based'];
          } else {
            _isEvidenceBased = false;
          }
          _threedmapsFilterEnabled = false;
          if(returnObject["searchParams"].containsKey('threedmaps_filter')) {
            if(returnObject["searchParams"]["threedmaps_filter"].toString().indexOf("gi_3dmaps") != -1) {              
              _threedmapsFilterEnabled = true;
              _threedmapsPerformanceData = null;
              _threedmapsMostabilityData = null;
              _threedmapsMatricData = null;              
            }            
          }
          _golfFilterEnabled = false;
          if(returnObject["searchParams"].containsKey('threedmaps_filter')) {
            if(returnObject["searchParams"]["threedmaps_filter"].toString().indexOf("gi_golf") != -1) {
              _golfFilterEnabled = true;
              _golfLevel1Filter = null;
              _golfLevel2Filter = null;
              _golfLevel3Filter = null;
            }            
          }
          _myExercises = false;
          if(returnObject["searchParams"].containsKey('my_exercises')) {
            _myExercises = returnObject["searchParams"]["my_exercises"];           
          }
          _myPracticeExercises = false;
          if(returnObject["searchParams"].containsKey('my_practice_exercise')) {
            _myPracticeExercises = returnObject["searchParams"]["my_practice_exercise"];           
          }
        }
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _searchParams = stateObject["searchParams"];        
        _searchParamsFilterData = stateObject["searchParamsFilterData"];
        if(_searchParams != null && _searchParamsFilterData != null) { 
          _exerciseCategoryList = Utils.parseList(_searchParamsFilterData, "category");
          _exerciseMetricList = Utils.parseList(_searchParamsFilterData, "metric"); 
          _exerciseBodyPartList = Utils.parseList(_searchParamsFilterData, "body_part"); 
          _exerciseDifficultyList = Utils.parseList(_searchParamsFilterData, "difficulty");    
          _cueList = Utils.parseList(_searchParamsFilterData, "cues");
          _equipmentList = Utils.parseList(_searchParamsFilterData, "equipments");
          _exerciseTypesList = Utils.parseList(_searchParamsFilterData, "exercise_types");
          _exerciseActionList = Utils.parseList(_searchParamsFilterData, "action");
          _exerciseDriverList = Utils.parseList(_searchParamsFilterData, "driver");                 
          _exerciseDirectionList = Utils.parseList(_searchParamsFilterData, "direction");
          _partnerList = Utils.parseList(_searchParamsFilterData, "partners");  
          _giGolfLevel1FilterList = Utils.parseList(_searchParamsFilterData, "gi_golf"); 
          _giGolfLevel2FilterList = null;           
          _giGolfLevel3FilterList = null;
          if(_searchParams.containsKey("partners")) {
            _selectedPartnerList = _searchParams["partners"]; 
          } else {
            _selectedPartnerList = [];          
          }
          if(_searchParams.containsKey("category")){
            _exerciseCategoryId = _searchParams["category"].toString();
          }
          if(_searchParams.containsKey("metric")) {
            _exerciseMetricSelectedList = _searchParams["metric"];
          } else {
            _exerciseMetricSelectedList = new List<int>();
          }
          if(_searchParams.containsKey("body_part")) {
            _exerciseBodyPartSelectedList = _searchParams["body_part"];
          } else {
            _exerciseBodyPartSelectedList = new List<int>();
          }
          if(_searchParams.containsKey("difficulty")) {
            _exerciseDifficultyLevelSelectedList = _searchParams["difficulty"];
          } else {
            _exerciseDifficultyLevelSelectedList = new List<int>();
          }
          if(_searchParams.containsKey("cues")) {
            _exerciseCueSelectdList = _searchParams["cues"];
          } else {
            _exerciseCueSelectdList = new List<int>();
          }
          if(_searchParams.containsKey("equipments")) {
            _exerciseEquipmentSelectedList = _searchParams["equipments"];
          } else {
            _exerciseEquipmentSelectedList = new List<int>();
          }
          if(_searchParams.containsKey("exercise_types")) {
            _exerciseTypeSelectedList = _searchParams["exercise_types"];
          } else {
            _exerciseTypeSelectedList = new List<int>();
          }
          if(_searchParams.containsKey("action")) {
            _exerciseActionSelectedList = _searchParams["action"];
          } else {
            _exerciseActionSelectedList = new List<int>();
          }
          if(_searchParams.containsKey("driver")) {
            _exerciseDriverSelectedList = _searchParams["driver"];
          } else {
            _exerciseDriverSelectedList = new List<int>();
          }
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 40.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  this._clearExerciseListActionCreator();
                  Navigator.pushReplacement(
                    context, 
                    new MaterialPageRoute(
                      builder: (context) => new ExerciseList(
                        usageType: widget.usageType,
                        clientId: widget.clientId,
                        engagementId: widget.engagementId,
                        exerciseSearchParams: widget.exerciseSearchParams
                      ),
                    ),
                  );
                },
              ),
              title: new Text(
                'Exercise Filters',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                  child: FlatButton(
                    color: primaryColor,                                
                    child: new Text(
                      'Submit',
                      style: TextStyle(
                        color: primaryTextColor
                      )
                    ),
                    onPressed: () {
                      Map params = new Map();
                      params["page"] = 0;
                      params["is_favorite"] =_isFavorite;
                      params["search"] = _searchController.text;
                      params["my_exercises"] = false;
                      params["my_practice_exercise"] = false;
                      if(_threedmapsFilterEnabled) {
                        String _threedmapsFilter = "gi_3dmaps";
                        if(_threedmapsPerformanceData != null) {
                          _threedmapsFilter =_threedmapsFilter + "_" + _threedmapsPerformanceData;
                          if(_threedmapsPerformanceData == "ANALYSIS_MOBILITY" || _threedmapsPerformanceData == "ANALYSIS_STABILITY") {
                            if(_threedmapsMatricData != null) {
                              _threedmapsFilter =_threedmapsFilter + "_" + _threedmapsMatricData;
                            }
                          } else {
                            if(_threedmapsMostabilityData != null) {
                              _threedmapsFilter =_threedmapsFilter + "_" + _threedmapsMostabilityData;
                            }
                            if(_threedmapsMatricData != null) {
                              _threedmapsFilter =_threedmapsFilter + "_" + _threedmapsMatricData;
                            }
                          } 
                        }
                        params["threedmaps_filter"] = _threedmapsFilter;
                      } else if(_golfFilterEnabled) {
                        String _threedmapsFilter = "gi_golf";
                        if(_golfLevel3Filter != null) {
                          _threedmapsFilter =_golfLevel3Filter;
                        } else if(_golfLevel2Filter != null) {
                          _threedmapsFilter =_golfLevel2Filter;
                        } else if(_golfLevel1Filter != null) {
                          _threedmapsFilter =_golfLevel1Filter;
                        }
                        params["threedmaps_filter"] = _threedmapsFilter;
                      } else {
                        params["threedmaps_filter"] = null;
                        params["my_exercises"] =_myExercises;
                        params["my_practice_exercise"] = _myPracticeExercises;
                        List<int> _partners = new List<int>();
                        for(int i=0; i<_partnerList.length; i++) {
                          if(_partnerList[i].containsKey("value") && _partnerList[i]["value"]) {
                            _partners.add(_partnerList[i]["id"]);
                          }
                        }
                        if(_partners.length > 0) {
                          params["partners"] = _partners;
                        } else {
                          if(params.containsKey("partners")) {
                            params.remove("partners");
                          }
                        }
                        if(_exerciseCategoryId != null) {
                          params["category"] =int.parse(_exerciseCategoryId);
                        }
                        if(_exerciseMetricSelectedList != null && _exerciseMetricSelectedList.length > 0) {
                          params["metric"] =_exerciseMetricSelectedList;
                        }
                        if(_exerciseBodyPartSelectedList != null && _exerciseBodyPartSelectedList.length > 0) {
                          params["body_part"] = _exerciseBodyPartSelectedList;
                        }
                        if(_exerciseDifficultyLevelSelectedList != null && _exerciseDifficultyLevelSelectedList.length > 0) {
                          params["difficulty"] = _exerciseDifficultyLevelSelectedList;
                        }
                        if(_exerciseCueSelectdList != null && _exerciseCueSelectdList.length > 0) {
                          params["cues"] = _exerciseCueSelectdList;
                        }
                        if(_exerciseEquipmentSelectedList != null && _exerciseEquipmentSelectedList.length > 0) {
                          params["equipments"] = _exerciseEquipmentSelectedList;
                        }
                        if(_exerciseTypeSelectedList != null && _exerciseTypeSelectedList.length > 0) {
                          params["exercise_types"] = _exerciseTypeSelectedList;
                        }
                        if(_exerciseActionSelectedList != null && _exerciseActionSelectedList.length > 0) {
                          params["action"] = _exerciseActionSelectedList;
                        }
                        if(_exerciseDriverList != null && _exerciseDriverSelectedList.length > 0) {
                          params["driver"] = _exerciseDriverSelectedList;
                        }
                      }      
                      this._clearExerciseListActionCreator();                
                      Navigator.pushReplacement(
                        context, 
                        new MaterialPageRoute(
                          builder: (context) => new ExerciseList(
                            usageType: widget.usageType,
                            clientId: widget.clientId,
                            engagementId: widget.engagementId,
                            exerciseSearchParams: params,
                          ),
                        ),
                      );                      
                    },
                  ),                
                ),              
              ],
            ),            
            body: new LayoutBuilder(
              builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: new Container(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                            child: new TextField(
                              controller: _searchController,
                              decoration: new InputDecoration(
                                border: new UnderlineInputBorder(                                          
                                  borderSide: const BorderSide(
                                    color: Colors.black87
                                  ),                                          
                                ),
                                hintStyle: new TextStyle(color: Colors.grey[800]),
                                hintText: "Search text",
                              ),
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12
                                ),
                              ),
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  // 'My Favorite Exercises (' + _searchParamsFilterData["favorites"].toString() +')',
                                  "My Favorite Exercises",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  )
                                ),
                                new Switch(
                                  value: _isFavorite,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    _isFavorite = value;
                                  }                           
                                )
                              ],
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12
                                ),
                              ),
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  // 'Evidence Based Exercises (' + _searchParamsFilterData["evidence_based_count"].toString() +')',
                                  "Evidence Based Exercises",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  )
                                ),
                                new Switch(
                                  value: _isEvidenceBased,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    _isEvidenceBased = value;
                                  }                           
                                )
                              ],
                            )
                          ),
                          selectedRole["is_3dmaps_enabled"] 
                          ? new Container(
                              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black12
                                  ),
                                ),
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    '3DMAPS',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    )
                                  ),
                                  new Switch(
                                    value: _threedmapsFilterEnabled,
                                    activeColor: Colors.green,
                                    onChanged: (bool value) {                                      
                                      if(value) {
                                        setState(() {
                                          _threedmapsFilterEnabled = true;
                                          _golfFilterEnabled = false;                                          
                                        });                                        
                                      } else {
                                        setState(() {
                                          _threedmapsFilterEnabled = false;
                                          _golfFilterEnabled = false;                                          
                                        });
                                      }
                                    }                           
                                  )
                                ],
                              )
                            )
                          : new Container(),
                          selectedRole["is_gi_golf_enabled"] 
                          ? new Container(
                              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black12
                                  ),
                                ),
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    'Golf',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    )
                                  ),
                                  new Switch(
                                    value: _golfFilterEnabled,
                                    activeColor: Colors.green,
                                    onChanged: (bool value) {
                                      if(value) {
                                        setState(() {
                                          _threedmapsFilterEnabled = false;
                                          _golfFilterEnabled = true;                                          
                                        });                                        
                                      } else {
                                        setState(() {
                                          _threedmapsFilterEnabled = false;
                                          _golfFilterEnabled = false;                                          
                                        });
                                      }
                                    }                           
                                  )
                                ],
                              )
                            )
                          : new Container(),
                          _threedmapsFilterEnabled
                          ? new Container(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                    child: new DropdownFormField(  
                                      labelKey: "name",
                                      valueKey: "id",  
                                      initialValue: _threedmapsPerformanceData,                             
                                      decoration: InputDecoration(
                                        labelText: "Select Performance",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      options: _performanceDataList,
                                      validator: (value) {
                                        _threedmapsPerformanceData = value; 
                                        _threedmapsMostabilityData = null;  
                                        _threedmapsMatricData = null;                                                                        
                                      },        
                                    ),
                                  ),
                                  _threedmapsPerformanceData != "ANALYSIS_MOBILITY" && _threedmapsPerformanceData != "ANALYSIS_STABILITY"
                                  ? new Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                      child: new DropdownFormField(  
                                        labelKey: "name",
                                        valueKey: "id",  
                                        initialValue: _threedmapsMostabilityData,                              
                                        decoration: InputDecoration(
                                          labelText: "Select Mobility/Stability",
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        autovalidate: true,
                                        options: _mostabilityDataList,
                                        validator: (value) {
                                          _threedmapsMostabilityData = value; 
                                          _threedmapsMatricData = null;                                          
                                        },        
                                      ),
                                    )
                                  : new Container(),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                    child: new DropdownFormField(  
                                      labelKey: "name",
                                      valueKey: "id",         
                                      initialValue: _threedmapsMatricData,                       
                                      decoration: InputDecoration(
                                        labelText: "Select Metric",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      options: _matricDataList,
                                      validator: (value) {
                                        _threedmapsMatricData = value;                                 
                                      },        
                                    ),
                                  )
                                ],
                              )   
                            )                           
                          : new Container(),
                          _golfFilterEnabled
                          ? new Container(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                    child: new DropdownFormField(  
                                      labelKey: "name",
                                      valueKey: "id",         
                                      initialValue: _golfLevel1Filter,                       
                                      decoration: InputDecoration(
                                        labelText: "Select Level 1 Filter",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      options: _giGolfLevel1FilterList,
                                      validator: (value) {                                          
                                        if(value != null && _golfLevel1Filter != value) {
                                          for(int i=0; i<_giGolfLevel1FilterList.length; i++) {
                                            if(_giGolfLevel1FilterList[i]["id"] == value) {
                                              _golfLevel1Filter = value;
                                              _giGolfLevel3FilterList = null;
                                              _golfLevel3Filter = null;                                              
                                              _giGolfLevel2FilterList = Utils.parseList(_giGolfLevel1FilterList[i],"children");
                                              _golfLevel2Filter = null;                                              
                                              break;
                                            }
                                          }
                                        }                                        
                                      },        
                                    ),
                                  ),
                                  _giGolfLevel2FilterList != null
                                  ? new Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                      child: new DropdownFormField(  
                                        labelKey: "name",
                                        valueKey: "id",         
                                        initialValue: _golfLevel2Filter,                       
                                        decoration: InputDecoration(
                                          labelText: "Select Level 2 Filter",
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        autovalidate: true,
                                        options: _giGolfLevel2FilterList,
                                        validator: (value) {
                                          if(value != null && _golfLevel2Filter != value && _giGolfLevel2FilterList != null) {
                                            bool valueFound = false;
                                            for(int i=0; i<_giGolfLevel2FilterList.length; i++) {
                                              if(_giGolfLevel2FilterList[i]["id"] == value) {                                                
                                                valueFound = true;
                                                if(_giGolfLevel2FilterList[i].containsKey("children")) {
                                                  _giGolfLevel3FilterList = Utils.parseList(_giGolfLevel2FilterList[i],"children");
                                                  _golfLevel3Filter = null;
                                                  break;
                                                }
                                              }
                                            }
                                            if(valueFound) {
                                              _golfLevel2Filter = value; 
                                            }
                                          }                                                                          
                                        },        
                                      ),
                                    )
                                  : new Container(),
                                  _giGolfLevel3FilterList != null
                                  ? new Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                      child: new DropdownFormField(  
                                        labelKey: "name",
                                        valueKey: "id",         
                                        initialValue: _golfLevel3Filter,                       
                                        decoration: InputDecoration(
                                          labelText: "Select Level 3 Filter",
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        autovalidate: true,
                                        options: _giGolfLevel3FilterList,
                                        validator: (value) {
                                          _golfLevel3Filter = value;                                 
                                        },        
                                      ),
                                    )
                                  : new Container(),
                                ],
                              ),
                            )
                          : new Container(),
                          !_threedmapsFilterEnabled && !_golfFilterEnabled 
                          ? new Container(
                              child: new Column(
                                children: <Widget>[
                                  new Container(    
                                    width: MediaQuery.of(context).size.width,   
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey
                                    ),                       
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: new Container(                                  
                                      child: new Text(
                                        "EXERCISE SOURCES",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(  
                                          color: Colors.white,                                  
                                        ),
                                      )
                                    ),                              
                                  ),
                                  new Container(
                                    child: new Column(
                                      children: _listPartners(),
                                    )
                                  ),                          
                                  new Container(    
                                    width: MediaQuery.of(context).size.width,   
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey
                                    ),                       
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: new Container(                                  
                                      child: new Text(
                                        "EXERCISE CATEGORY",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(  
                                          color: Colors.white,                                  
                                        ),
                                      )
                                    ),                              
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                    child: new DropdownFormField(  
                                      labelKey: "name",
                                      valueKey: "id",
                                      decoration: InputDecoration(
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,                                      
                                      initialValue: _exerciseCategoryId,
                                      options: _exerciseCategoryList,
                                      validator: (value) { 
                                        if(value != null || value != "") {
                                          _exerciseCategoryId = value;                                
                                        }
                                      },        
                                    ),
                                  ),
                                  new Container(    
                                    width: MediaQuery.of(context).size.width,   
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey
                                    ),                       
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: new Container(                                  
                                      child: new Text(
                                        "ADDITIONAL FILTERS",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(  
                                          color: Colors.white,                                  
                                        ),
                                      )
                                    ),                              
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(   
                                      context: context,                            
                                      decoration: InputDecoration(
                                        labelText: "Exercise Metric",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _exerciseMetricList,
                                      initialValue: _exerciseMetricSelectedList,       
                                      validator: (value) {
                                        if(value != null) {
                                          _exerciseMetricSelectedList = value;
                                        }
                                      },                              
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(  
                                      context: context,
                                      labelKey: "name",
                                      valueKey: "id", 
                                      decoration: InputDecoration(
                                        labelText: "Body Part",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _exerciseBodyPartList,
                                      initialValue: _exerciseBodyPartSelectedList,
                                      validator: (value) {
                                        if(value != null) {
                                          _exerciseBodyPartSelectedList = value;
                                        }                                 
                                      },        
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(
                                      context: context,                                
                                      decoration: InputDecoration(
                                        labelText: "Difficulty Level",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _exerciseDifficultyList,
                                      initialValue:_exerciseDifficultyLevelSelectedList,
                                      validator: (value) {
                                        if(value != null) {
                                          _exerciseDifficultyLevelSelectedList = value;
                                        }                                 
                                      },        
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(
                                      context: context, 
                                      labelKey: "name",
                                      valueKey: "id",                             
                                      decoration: InputDecoration(
                                        labelText: "Cues",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _cueList,
                                      initialValue:_exerciseCueSelectdList,
                                      validator: (value) {
                                        if(value != null) {
                                          _exerciseCueSelectdList = value;
                                        }                                 
                                      },        
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(
                                      context: context,    
                                      labelKey: "name",
                                      valueKey: "id",                             
                                      decoration: InputDecoration(
                                        labelText: "Equipment",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _equipmentList,
                                      initialValue: _exerciseEquipmentSelectedList,
                                      validator: (value) {  
                                        if(value != null) {
                                          _exerciseEquipmentSelectedList = value;
                                        }                               
                                      },        
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(
                                      context: context,    
                                      labelKey: "name",
                                      valueKey: "id",                             
                                      decoration: InputDecoration(
                                        labelText: "Types",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _exerciseTypesList,
                                      initialValue: _exerciseTypeSelectedList,
                                      validator: (value) {                   
                                        if(value != null) {
                                          _exerciseTypeSelectedList = value;
                                        }              
                                      },        
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(
                                      context: context,    
                                      labelKey: "name",
                                      valueKey: "id",                             
                                      decoration: InputDecoration(
                                        labelText: "Action",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _exerciseActionList,
                                      initialValue: _exerciseActionSelectedList,
                                      validator: (value) {                     
                                        if(value != null) {
                                          _exerciseActionSelectedList = value;
                                        }            
                                      },        
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                    child: new MultiSelect(
                                      context: context,    
                                      labelKey: "name",
                                      valueKey: "id",                             
                                      decoration: InputDecoration(
                                        labelText: "Driver",
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      enabled: true,
                                      optionList: _exerciseDriverList,
                                      initialValue: _exerciseDriverSelectedList,
                                      validator: (value) {                     
                                        if(value != null) {
                                          _exerciseDriverSelectedList = value;
                                        }
                                      },        
                                    ),
                                  ),
                                  // new Container(
                                  //   padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  //   child: new DropdownFormField(    
                                  //     labelKey: "name",
                                  //     valueKey: "id",                             
                                  //     decoration: InputDecoration(
                                  //       labelText: "Direction",
                                  //       border: new UnderlineInputBorder(
                                  //         borderSide: new BorderSide(
                                  //           color: Colors.black87,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     autovalidate: true,
                                  //     options: _exerciseDirectionList,
                                  //     validator: (value) {                                 
                                  //     },        
                                  //   ),
                                  // ),
                                ]
                              )
                            )
                          : new Container(),
                        ],
                      ),
                    )
                  )
                );
              }
            )
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
