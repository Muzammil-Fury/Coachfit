import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/document/document_network.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/document/views/document_list.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementDocuments extends StatelessWidget {
  final int engagementId;
  final int documentType;
  EngagementDocuments({
    this.engagementId,
    this.documentType,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementDocuments(
          engagementId: this.engagementId,
          documentType: this.documentType,
        ),
      ),
    );
  }
}

class _EngagementDocuments extends StatefulWidget {
  final int engagementId;
  final int documentType;
  _EngagementDocuments({
    this.engagementId,
    this.documentType,
  });

  @override
  _EngagementDocumentsState createState() => new _EngagementDocumentsState();
}

class _EngagementDocumentsState extends State<_EngagementDocuments> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final slideMenuKey = new GlobalKey<SlideMenuState>();

  var _getDocumentListAPI, _removeDocumentFromEngagementAPI, _togglePublishEngagementDocumentAPI;
  List<Map> _documentList;

  List<Widget> _listNutritionDocuments() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_documentList.length; i++) {
      SlideMenu _item = new SlideMenu(
        key: slideMenuKey,
        child: new ListTile(        
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),  
          title: new Container( 
            height: 80,                 
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),                                    
                  child: new Text(
                    _documentList[i]["name"],
                    textAlign: TextAlign.start,
                  )
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                  child: new Text(
                    _documentList[i]["is_published"] ? "Published" : "Draft",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                    ),
                  )
                )
              ]
            ),            
          )
        ),
        menuItems: <Widget>[
          new GestureDetector(
            onTap: () {
              Map params = new Map();
              params["engagement_id"] = widget.engagementId;
              params["document_type"] = widget.documentType;
              params["health_document_id"] = _documentList[i]["id"];
              _removeDocumentFromEngagementAPI(context, params);               
            },
            child: new Container(
              color:Colors.redAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    GomotiveIcons.delete,
                    color: Colors.white
                  ),                
                  new Text(
                    "DELETE",
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
          new GestureDetector(
            onTap: () { 
              Map params = new Map();
              params["engagement_id"] = widget.engagementId;
              params["document_type"] = widget.documentType;
              params["health_document_id"] = _documentList[i]["id"];
              _togglePublishEngagementDocumentAPI(context, params);                             
            },
            child: new Container(
              color:Colors.yellowAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    GomotiveIcons.select,
                    color: Colors.black87
                  ),                
                  new Text(
                    _documentList[i]["is_published"] ? "UNPUBLISH" : "PUBLISH",
                    style: TextStyle(
                      color: Colors.black87,
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
        _getDocumentListAPI = stateObject["getDocumentList"];
        _removeDocumentFromEngagementAPI = stateObject["removeDocumentFromEngagement"];
        _togglePublishEngagementDocumentAPI = stateObject["togglePublishEngagementDocument"];
        Map params = new Map();
        params["engagement_id"] = widget.engagementId;
        params["document_type"] = widget.documentType;
        _getDocumentListAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getDocumentList"] = (BuildContext context, Map params) =>
            store.dispatch(getDocumentList(context, params)); 
        returnObject["removeDocumentFromEngagement"] = (BuildContext context, Map params) =>
            store.dispatch(removeDocumentFromEngagement(context, params)); 
        returnObject["togglePublishEngagementDocument"] = (BuildContext context, Map params) =>
            store.dispatch(togglePublishEngagementDocument(context, params));                                            
        returnObject["documentList"] = store.state.documentState.engagementDocumentList;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _documentList = stateObject["documentList"];
        if(_documentList != null) {
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
                widget.documentType == 1 ? 'Nutrition Documents' : 'Guidance Documents',             
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
                    builder: (context) => new DocumentList(
                      engagementId: widget.engagementId,
                      documentType: widget.documentType,                         
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
                      child: _documentList.length > 0
                      ? new Column(
                          children: _listNutritionDocuments()
                        )
                      : new Center(
                        child: new Text(
                          widget.documentType == 1
                          ? "There is no nutrition document assigned. Kindly click on Add to assign a nutrition document."
                          : "There is no guidance document assigned. Kindly click on Add to assign a guidance document.",
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
