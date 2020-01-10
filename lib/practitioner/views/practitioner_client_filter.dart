import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/practitioner/views/practitioner_clients.dart';
import 'package:gomotive/core/app_config.dart';

class PractitionerClientFilter extends StatelessWidget {
  final String flowType;
  PractitionerClientFilter({
    this.flowType
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerClientFilter(
          flowType: this.flowType,
        ),
      ),
    );
  }
}

class _PractitionerClientFilter extends StatefulWidget {
  final String flowType;
  _PractitionerClientFilter({
    this.flowType
  });
  
  
  @override
  _PractitionerClientFilterState createState() => new _PractitionerClientFilterState();
}

class _PractitionerClientFilterState extends State<_PractitionerClientFilter> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getClientFiltersAPI;
  List<Map> _clientFiltersSelectionList, _practitionerList, _consultantList;

  bool _allPracticeClients, _hiddenPracticeClients;
  String _clientFiltersSelection;  
  String _practitionerId, _consultantId;
  String _clientType;

  @override
  void initState() {
    _allPracticeClients = false;
    _hiddenPracticeClients = false;
    _practitionerId = null;
    _consultantId = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getClientFiltersAPI = stateObject["getClientFilters"];
        _getClientFiltersAPI(context, new Map());    
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getClientFilters"] = (BuildContext context, Map params) =>
            store.dispatch(getClientFilters(context, params));
        returnObject["clientFiltersSelectionList"] = store.state.practitionerState.clientFilterSelectionList;
        returnObject["practitionerList"] = store.state.practitionerState.practitionerList;
        returnObject["consultantList"] = store.state.practitionerState.consultantList;
        returnObject["clientSearchPreference"] = store.state.practitionerState.clientSearchPreference;
        if(returnObject["clientSearchPreference"] != null) {
          _clientFiltersSelection = returnObject["clientSearchPreference"];
        }
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {            
        _clientFiltersSelectionList = stateObject["clientFiltersSelectionList"];
        _practitionerList = stateObject["practitionerList"];
        _consultantList = stateObject["consultantList"];        
        if(_clientFiltersSelectionList != null) { 
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(  
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 30.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),   
              backgroundColor: Colors.white,
              title: new Text(
                'Client Filters',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                       
              actions: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: IconButton(
                    icon: Icon(
                      GomotiveIcons.search,
                      size: 30.0,
                      color: primaryColor,
                    ),
                    onPressed: () {                      
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new PractitionerClients(
                            flowType: widget.flowType,
                            clientType: _clientType,
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
                                  'All Practice Clients',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  )
                                ),
                                new Switch(
                                  value: _allPracticeClients,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    _clientType = "all";
                                    if(value) {
                                      setState(() {
                                        _allPracticeClients = true;
                                        _hiddenPracticeClients = false;
                                      });
                                    } else {
                                      setState(() {
                                        _allPracticeClients = false;
                                        _hiddenPracticeClients = false;
                                      });
                                    }    
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
                                  'Hidden Practice Clients',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  )
                                ),
                                new Switch(
                                  value: _hiddenPracticeClients,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    _clientType = "hidden";
                                    if(value) {
                                      setState(() {
                                        _allPracticeClients = false;
                                        _hiddenPracticeClients = true;
                                      });
                                    } else {
                                      setState(() {
                                        _allPracticeClients = false;
                                        _hiddenPracticeClients = false;
                                      });
                                    }                                                                        
                                  }                           
                                )
                              ],
                            )
                          ),   
                          !_allPracticeClients && !_hiddenPracticeClients
                          ? new Container(
                              child: new Column(
                                children: <Widget>[
                                  _clientFiltersSelectionList != null && _clientFiltersSelectionList.length > 0
                                  ? new Container(
                                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                                      child: new DropdownFormField(
                                        decoration: InputDecoration(                                    
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          labelText: 'My Clients',
                                          labelStyle: new TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),           
                                        initialValue: _clientFiltersSelection,    
                                        options: _clientFiltersSelectionList,  
                                        autovalidate: true,
                                        validator: (value) {
                                          _clientType = value;
                                          _clientFiltersSelection = value;
                                        },                              
                                      ),
                                    )
                                  : new Container(),
                                  _practitionerList != null && _practitionerList.length > 0
                                  ? new Container(
                                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                                      child: new DropdownFormField(
                                        decoration: InputDecoration(                                    
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          labelText: 'Practice Practitioner Clients',
                                          labelStyle: new TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),               
                                        initialValue: _practitionerId,
                                        options: _practitionerList, 
                                        autovalidate: true,
                                        validator: (value) {
                                          if(value != null) {
                                            _clientType = value;
                                          }
                                          _practitionerId = value;
                                          
                                        },                               
                                      ),
                                    )
                                  : new Container(),
                                  _consultantList != null && _consultantList.length > 0
                                  ? new Container(
                                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                                      child: new DropdownFormField(
                                        decoration: InputDecoration(                                    
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          labelText: 'Practice Consultant Clients',
                                          labelStyle: new TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),               
                                        options: _consultantList, 
                                        initialValue: _consultantId,
                                        autovalidate: true, 
                                        validator: (value) {
                                          if(value != null) {
                                            _clientType = value;                         
                                          }
                                          _consultantId = value;
                                        }                              
                                      ),
                                    )
                                  : new Container(),
                                ],
                              )
                            )
                          : new Container(),                                                 
                        ],
                      )
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
