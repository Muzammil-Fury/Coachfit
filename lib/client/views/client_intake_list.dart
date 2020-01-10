import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/intake/views/intake_view.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_config.dart';

class ClientIntakeList extends StatelessWidget {
  final bool fromExternal;
  ClientIntakeList({
    this.fromExternal: false
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientIntakeList(
          fromExternal: this.fromExternal
        ),
      ),
    );
  }
}

class _ClientIntakeList extends StatefulWidget {
  final bool fromExternal;
  _ClientIntakeList({
    this.fromExternal
  });

  @override
  _ClientIntakeListState createState() => new _ClientIntakeListState();
}

class _ClientIntakeListState extends State<_ClientIntakeList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getIntakeFormListAPI;
  List<Map> _intakeForms;
  
  List<Widget> _listIntakeForms() {
    List<Widget> _list = new List<Widget>();
    if(_intakeForms.length > 0) {
      for(int i=0;i<_intakeForms.length;i++) {
        GestureDetector _intakeContainer = new GestureDetector(   
          onTap:() {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new IntakeView(
                  engagementId: _intakeForms[i]["engagement"]["id"],
                  enableSubmit: _intakeForms[i]["submitted"] ? false : true,
                  intakeFormId: _intakeForms[i]["id"],
                  formName: _intakeForms[i]["intake"]["name"],
                  formFields: Utils.parseList(_intakeForms[i], "form")                
                ),
              ),
            );
          },   
          child: new Container(
            width: MediaQuery.of(context).size.width,  
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),         
            decoration: new BoxDecoration(                          
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ 
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),                                    
                  child: new Text(
                    _intakeForms[i]["intake"]["name"],
                    textAlign: TextAlign.start,
                  )
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),                                    
                  child: new Text(
                    _intakeForms[i]["engagement"]["name"] + " game plan",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                    )
                  )
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),                                    
                  child: new Text(
                    _intakeForms[i]["practice"]["name"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                    )
                  )
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),                                    
                  child: new Text(
                    _intakeForms[i]["submitted"] 
                      ? "Submitted on: " + Utils.convertDateStringToDisplayStringDateAndTime(_intakeForms[i]["submitted_date"])
                      : "",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                      color: _intakeForms[i]["submitted"] ? Colors.green : Colors.red,
                    )
                  )
                ),                 
              ]
            ),
          )
        );
        _list.add(_intakeContainer);
      }
    } else {
      Container _emptyContainer = new Container(
        padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 0.0),
        child: new Center(
          child: new Text(
            "You have not been assigned any intake forms"
          )
        )
      );
      _list.add(_emptyContainer);
    }
    return _list;
  }
  
  @override
  void deactivate() { 
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getIntakeFormListAPI = stateObject["getIntakeFormList"];
        _getIntakeFormListAPI(context, {});
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();      
        returnObject["getIntakeFormList"] = (BuildContext context, Map params) =>
            store.dispatch(getIntakeFormList(context, params));  
        returnObject["intakeForms"] = store.state.clientState.intakeForms;        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _intakeForms = stateObject["intakeForms"];        
        if(_intakeForms != null) {                    
          return new Scaffold(
            key: _scaffoldKey,            
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:primaryColor,
                ),
                onPressed: () {
                  if(widget.fromExternal) {
                    Navigator.of(context).pushReplacementNamed("/home/route");
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: new Text(
                'Intake Forms',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[                
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),  
                      child: new Column(
                        children: _listIntakeForms()
                      )                    
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
