import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/workout/views/workout_template_list.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutTemplateFilter extends StatelessWidget {
  final Map searchParams;
  final String usageType;
  final int clientId;
  final int engagementId;  
  final String dhfMovementMeterType;

  WorkoutTemplateFilter({
    this.searchParams,
    this.usageType,
    this.clientId,
    this.engagementId,
    this.dhfMovementMeterType,
  });


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutTemplateFilter(
          searchParams: this.searchParams,
          usageType: this.usageType,
          clientId: this.clientId,
          engagementId: this.engagementId,
          dhfMovementMeterType: this.dhfMovementMeterType,
        ),
      ),
    );
  }
}

class _WorkoutTemplateFilter extends StatefulWidget {
  final Map searchParams;
  final String usageType;
  final int clientId;
  final int engagementId;
  final String dhfMovementMeterType;

  _WorkoutTemplateFilter({
    this.searchParams,
    this.usageType,
    this.clientId,
    this.engagementId,
    this.dhfMovementMeterType,
  });

  @override
  _WorkoutTemplateFilterState createState() => new _WorkoutTemplateFilterState();
}

class _WorkoutTemplateFilterState extends State<_WorkoutTemplateFilter> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  

  var _getSearchParamsWorkoutTemplateAPI,
      _clearWorkoutTemplateListActionCreator;
  Map _searchParams, _searchParamsSupportingData;

  List<Map<String, dynamic>>  _partnerList,
                              _categoryList,
                              _categoryLevel2List,
                              _categoryLevel3List;

  List<dynamic> _selectedPartnerList;
  bool  _isFavorite,
        _myWorkoutTemplates, 
        _myPracticeWorkoutTemplates;

  String _categoryId, _categoryLevel2Id, _categoryLevel3Id;

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
            'My Workout Templates',
            style: TextStyle(
              fontSize: 16.0,
            )
          ),
          new Switch(
            value: _myWorkoutTemplates,
            activeColor: Colors.green,
            onChanged: (bool value) {
              _myWorkoutTemplates = value;
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
            'My Practice Workout Templates',
            style: TextStyle(
              fontSize: 16.0,
            )
          ),
          new Switch(
            value: _myPracticeWorkoutTemplates,
            activeColor: Colors.green,
            onChanged: (bool value) {
              _myPracticeWorkoutTemplates = value;
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
        _getSearchParamsWorkoutTemplateAPI = stateObject["getSearchParamsWorkoutTemplate"];   
        _clearWorkoutTemplateListActionCreator = stateObject["clearWorkoutTemplateListActionCreator"];        
        if(stateObject["searchParams"] != null) {
          _getSearchParamsWorkoutTemplateAPI(context, stateObject["searchParams"]);
        }        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();       
        returnObject["getSearchParamsWorkoutTemplate"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkoutTemplateSearchParams(context, params)); 
        returnObject["clearWorkoutTemplateListActionCreator"] = () =>
            store.dispatch(WorkoutTemplateClearActionCreator());   
        returnObject["searchParamsSupportingData"] = store.state.workoutState.workoutTemplateSearchParamsSupportingData;            
        returnObject["searchParams"] = store.state.workoutState.workoutTemplateSearchParams;                             
        if(returnObject["searchParams"].containsKey('is_favorite')) {
          _isFavorite =returnObject["searchParams"]['is_favorite'];
        } else {
          _isFavorite = false;
        }
        _myWorkoutTemplates = false;
        if(returnObject["searchParams"].containsKey('my_programs')) {
          _myWorkoutTemplates = returnObject["searchParams"]["my_programs"];           
        }
        _myPracticeWorkoutTemplates = false;
        if(returnObject["searchParams"].containsKey('my_practice_programs')) {
          _myPracticeWorkoutTemplates = returnObject["searchParams"]["my_practice_programs"];           
        }
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _searchParams = stateObject["searchParams"];        
        _searchParamsSupportingData = stateObject["searchParamsSupportingData"];
        if(_searchParams != null && _searchParamsSupportingData != null) {  
          _categoryList = Utils.parseList(_searchParamsSupportingData, "category");
          _categoryLevel2List = new List<Map<String, dynamic>>();
          _categoryLevel3List = new List<Map<String, dynamic>>();                    
          if(_searchParams.containsKey("category")){
            _categoryId = _searchParams["category"].toString();            
          }
          if(_searchParams.containsKey("category_level2")){
            _categoryLevel2Id = _searchParams["category_level2"].toString();            
          }
          if(_searchParams.containsKey("category_level3")){
            _categoryLevel3Id = _searchParams["category_level3"].toString();
          }
          if(_searchParams.containsKey("partners")) {
            _selectedPartnerList = _searchParams["partners"]; 
          } else {
            _selectedPartnerList = [];          
          }  
          _partnerList = Utils.parseList(_searchParamsSupportingData, "partners");      
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  this._clearWorkoutTemplateListActionCreator();
                  Navigator.pushReplacement(
                    context, 
                    new MaterialPageRoute(
                      builder: (context) => new WorkoutTemplateList(
                        usageType: widget.usageType,
                        clientId: widget.clientId,
                        engagementId: widget.engagementId,
                        searchParams: widget.searchParams,
                        dhfMovementMeterType: widget.dhfMovementMeterType,
                      ),
                    ),
                  );
                },
              ),
              title: new Text(
                'Filters',             
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
                      this._clearWorkoutTemplateListActionCreator();                
                      Map params = new Map();
                      params["page"] = 0;
                      params["is_favorite"] =_isFavorite;                      
                      params["my_programs"] = _myWorkoutTemplates;
                      params["my_practice_programs"] = _myPracticeWorkoutTemplates;
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
                      if(_categoryId != null) {
                        params["category"] =int.parse(_categoryId);
                      }
                      if(_categoryLevel2Id != null && _categoryLevel2Id != "-1") {
                        params["category_level2"] =int.parse(_categoryLevel2Id);
                      }
                      if(_categoryLevel3Id != null && _categoryLevel3Id != "-1") {
                        params["category_level3"] =int.parse(_categoryLevel3Id);
                      }
                      Navigator.pushReplacement(
                        context, 
                        new MaterialPageRoute(
                          builder: (context) => new WorkoutTemplateList(
                            usageType: widget.usageType,
                            clientId: widget.clientId,
                            engagementId: widget.engagementId,
                            searchParams: params,
                            dhfMovementMeterType: widget.dhfMovementMeterType,
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
                                  "My Favorite Workout Templates",
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
                                      "WORKOUT TEMPLATE SOURCES",
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
                                    options: _categoryList,
                                    initialValue: _categoryId,
                                    validator: (value) { 
                                      if(value != null && value != "") {
                                        _categoryId = value;  
                                        _categoryLevel3Id = null;  
                                        _categoryLevel3List.clear();
                                        _categoryLevel2Id = null;
                                        _categoryLevel2List.clear();                                    
                                        List<Map> _tempList = Utils.parseList(_searchParamsSupportingData, "category_level2");            
                                        _categoryLevel2List.add({"id": "-1", "name": ""});
                                        for(int i=0; i<_tempList.length; i++) {
                                          if(_tempList[i]["category"] == int.parse(_categoryId)) {
                                            _categoryLevel2List.add(_tempList[i]);
                                          }
                                        }                                                                     
                                      }
                                    },        
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
                                    options: _categoryLevel2List,
                                    initialValue: _categoryLevel2Id,
                                    validator: (value) { 
                                      if(value != null && value != "") { 
                                        bool flag = false;
                                        if(value == "-1") {
                                          flag = true;
                                        } else {
                                          for(int i=0; i<_categoryLevel2List.length; i++) {
                                            if(_categoryLevel2List[i]["id"] == int.parse(value)) {
                                              flag = true;
                                              break;
                                            }
                                          }
                                        }
                                        if(flag) {
                                          _categoryLevel2Id = value;
                                          _categoryLevel3Id = null;  
                                          _categoryLevel3List.clear();
                                          List<Map> _tempList = Utils.parseList(_searchParamsSupportingData, "category_level3");            
                                          _categoryLevel3List.add({"id": "-1", "name": ""});
                                          for(int i=0; i<_tempList.length; i++) {
                                            if(_tempList[i]["category_level2"] == int.parse(_categoryLevel2Id)) {
                                              _categoryLevel3List.add(_tempList[i]);
                                            }
                                          }                                        
                                        }
                                      }
                                    },        
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
                                    options: _categoryLevel3List,
                                    initialValue: _categoryLevel3Id,
                                    validator: (value) { 
                                      if(value != null && value != "") {
                                        bool flag = false;
                                        for(int i=0; i<_categoryLevel3List.length; i++) {
                                          if(_categoryLevel3List[i]["id"] == int.parse(value)) {
                                            flag = true;
                                            break;
                                          }
                                        }
                                        if(flag) {
                                          _categoryLevel3Id = value;                                
                                        }
                                      }
                                    },        
                                  ),
                                ),
                              ]
                            )
                          )                                  
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
