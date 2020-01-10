import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/education/education_network.dart';
import 'package:gomotive/education/education_actions.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/education/views/education_content_view.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class EducationContent extends StatelessWidget {
  final Map partner;
  final Map category;
  EducationContent({
    this.partner,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EducationContent(
          partner: this.partner,
          category: this.category
        ),
      ),
    );
  }
}

class _EducationContent extends StatefulWidget {
  final Map partner;
  final Map category;
  _EducationContent({
    this.partner,
    this.category
  });
  
  @override
  _EducationContentState createState() => new _EducationContentState();
}

class _EducationContentState extends State<_EducationContent> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getEducationContentAPI, _clearEducationContentActionCreator;
  List<Map> _educationContent;
 
  List<Widget> _listEducationCategories() {
    List<Widget> _list = new List<Widget>();
    if(_educationContent != null) {
      for(int i=0; i<_educationContent.length; i++) {
        GestureDetector _container = new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new EducationContentView(                  
                  content: _educationContent[i],
                ),
              ),
            );                           
          },
          child: new Container(
            width: MediaQuery.of(context).size.width,  
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.fromLTRB(4, 0, 8, 0),
                    width: MediaQuery.of(context).size.width*0.2,
                    child: new Thumbnail(
                      url: _educationContent[i]["thumbnail"],
                    )
                  ),
                  new Flexible(
                    child: new Text(
                      _educationContent[i]["name"]
                    )
                  )

                ],
              ) 
            )           
          )
        );
        _list.add(_container);
      }
    }
    return _list;
  }
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getEducationContentAPI = stateObject["getEducationContent"];
        _clearEducationContentActionCreator = stateObject["clearEducationContent"];
        Map params = new Map();
        params["partner_id"] = widget.partner["id"];
        params["education_category_id"] = widget.category["id"];        
        _getEducationContentAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();   
        returnObject["getEducationContent"] = (BuildContext context, Map params) =>
            store.dispatch(getEducationContent(context, params));         
        returnObject["clearEducationContent"] = () =>
            store.dispatch(ClearEducationPartnerContentActionCreator());         
        returnObject["educationContent"] = store.state.educationState.educationContent;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _educationContent = stateObject["educationContent"];        
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: IconButton(                  
              icon: Icon(
                GomotiveIcons.back,
                size: 40.0,
                color: primaryColor,
              ),
              onPressed: () {
                this._clearEducationContentActionCreator();
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              widget.category["name"],             
              style: TextStyle(
                color: Colors.black87
              )   
            ),              
            actions: <Widget>[],
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
                      children: _listEducationCategories() 
                    )                                                             
                  ),
                ),
              );
            },
          ),
        );        
      }
    );
  }
}
