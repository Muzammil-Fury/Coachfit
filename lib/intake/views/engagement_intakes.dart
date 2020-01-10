import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/intake/views/engagement_intake_invite.dart';
import 'package:gomotive/intake/views/intake_view.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementIntakes extends StatelessWidget {
  final Map client;
  final int engagementId;
  EngagementIntakes({
    this.client,
    this.engagementId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementIntakes(
          client: this.client,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _EngagementIntakes extends StatefulWidget {
  final Map client;
  final int engagementId;
  _EngagementIntakes({
    this.client,
    this.engagementId,
  });


  @override
  _EngagementIntakesState createState() => new _EngagementIntakesState();
}

class _EngagementIntakesState extends State<_EngagementIntakes> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  Map _engagementObj;
  List<Map> _intakes;

  List<Widget> _listIntakes() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_intakes.length; i++) {
      final slideMenuKey = new GlobalKey<SlideMenuState>();
      SlideMenu _item = new SlideMenu(
        key: slideMenuKey,
        child: new ListTile(        
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), 
          title: new Container(          
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),                                    
                  child: new Text(
                    _intakes[i]["intake"]["name"],
                    textAlign: TextAlign.start,
                  )
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),                                    
                  child: new Text(
                    _intakes[i]["submitted"] 
                      ? "Submitted on: " + Utils.convertDateStringToDisplayStringDateAndTime(_intakes[i]["submitted_date"])
                      : "Not submitted by client",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                    )
                  )
                ),                 
              ]
            ),            
          )
        ),
        menuItems: <Widget>[
          new GestureDetector(
            onTap: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new IntakeView(
                    enableSubmit: false,
                    formName: _intakes[i]["intake"]["name"],
                    formFields: Utils.parseList(_intakes[i], "form")                
                  ),
                ),
              );
            },
            child: new Container(
              color: Colors.blueAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    Icons.info_outline,
                    color: Colors.white
                  ),                
                  new Text(
                    "VIEW",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500
                    )
                  )              
                ]
              )
            ),
          ),          
        ]
      );
      _list.add(_item);
    }
    return _list;
  }
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {           
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();          
        returnObject["engagement"] = store.state.practitionerState.activeClientEngagement;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _engagementObj = stateObject["engagement"];        
        if(_engagementObj != null) {
          _intakes = Utils.parseList(_engagementObj, "intakes");
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
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new PractitionerClientHome(
                        clientId: widget.client["id"],                           
                      ),
                    ),
                  );
                },
              ),     
              backgroundColor: Colors.white,
              title: new Text(
                'Intakes',
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                     
              actions: <Widget>[                
              ],
            ),  
            floatingActionButton: new FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {   
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new EngagementIntakeInvite(
                      client: widget.client,       
                      engagementId: widget.engagementId,                    
                    ),
                  ),
                );
              },
              child: new Text(
                "ADD",
                style: TextStyle(
                  color: primaryTextColor
                )
              ),            
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,                      
            body: new LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0), 
                      child: _intakes.length > 0
                      ? new Column(
                          children: _listIntakes()
                        )
                      : new Center(
                        child: new Text(                          
                          "No intakes have been assigned. Kindly click on Add to assign one.",
                          textAlign: TextAlign.center,
                        )
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
