import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/document/document_network.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class DocumentList extends StatelessWidget {
  final int engagementId;
  final int documentType;
  DocumentList({
    this.engagementId,
    this.documentType,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _DocumentList(
          engagementId: this.engagementId,
          documentType: this.documentType,
        ),
      ),
    );
  }
}

class _DocumentList extends StatefulWidget {
  final int engagementId;
  final int documentType;
  _DocumentList({
    this.engagementId,
    this.documentType,
  });

  @override
  _DocumentListState createState() => new _DocumentListState();
}

class _DocumentListState extends State<_DocumentList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _getAllDocumentListAPI, _addDocumentToEngagementAPI;

  List<Map> _documentList;

  List<Widget> _listNutritionDocuments() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_documentList.length; i++) {
      final slideMenuKey = new GlobalKey<SlideMenuState>();
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
              _addDocumentToEngagementAPI(context, params);
              Navigator.of(context).pop();           
            },
            child: new Container(
              color:Colors.greenAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    Icons.add_circle_outline,
                    color: Colors.white
                  ),                
                  new Text(
                    "ADD",
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
        _getAllDocumentListAPI = stateObject["getAllDocumentList"];
        _addDocumentToEngagementAPI = stateObject["addDocumentToEngagement"];
        Map params = new Map();
        params["engagement_id"] = widget.engagementId;
        params["document_type"] = widget.documentType;
        _getAllDocumentListAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getAllDocumentList"] = (BuildContext context, Map params) =>
            store.dispatch(getAllDocumentList(context, params));  
        returnObject["addDocumentToEngagement"] = (BuildContext context, Map params) =>
            store.dispatch(addDocumentToEngagement(context, params));                        
        returnObject["documentList"] = store.state.documentState.documentList;
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
                widget.documentType == 1 ? 'Add Nutrition Documents' : 'Add Guidance Documents',             
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0),                        
                      child: _documentList.length > 0
                      ? new Column(
                          children: _listNutritionDocuments()
                        )
                      : new Center(
                        child: new Text(
                          widget.documentType == 1 
                          ? 'You have not uploaded any nutrition documents. Kindly login to web app and upload the same.'
                          : 'You have not uploaded any guidance documents. Kindly login to web app and upload the same.',
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
