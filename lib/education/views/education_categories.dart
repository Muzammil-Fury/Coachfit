import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/education/education_network.dart';
import 'package:gomotive/education/education_actions.dart';
import 'package:gomotive/education/views/education_content.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class EducationCategories extends StatelessWidget {
  final Map partner;
  EducationCategories({
    this.partner
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EducationCategories(
          partner: this.partner,
        ),
      ),
    );
  }
}

class _EducationCategories extends StatefulWidget {
  final Map partner;
  _EducationCategories({
    this.partner
  });
  
  @override
  _EducationCategoriesState createState() => new _EducationCategoriesState();
}

class _EducationCategoriesState extends State<_EducationCategories> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getEducationCategoriesAPI, _clearEducationCategoryActionCreator;
  List<Map> _educationCategories;
 
  List<Widget> _listEducationCategories() {
    List<Widget> _list = new List<Widget>();
    if(_educationCategories != null) {
      for(int i=0; i<_educationCategories.length; i++) {
        GestureDetector _container = new GestureDetector(
          onTap: () {   
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new EducationContent(
                  partner: widget.partner,
                  category: _educationCategories[i],
                ),
              ),
            );            
          },
          child: new Container(
            width: MediaQuery.of(context).size.width,  
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            child: new Text(
              _educationCategories[i]["name"]
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
        _getEducationCategoriesAPI = stateObject["getEducationCategories"];
        _clearEducationCategoryActionCreator = stateObject["clearEducationCategory"];
        Map params = new Map();
        params["partner_id"] = widget.partner["id"];
        _getEducationCategoriesAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();   
        returnObject["getEducationCategories"] = (BuildContext context, Map params) =>
            store.dispatch(getEducationCategories(context, params));         
        returnObject["clearEducationCategory"] = () =>
            store.dispatch(ClearEducationPartnerCategoryActionCreator());         
        returnObject["educationCategories"] = store.state.educationState.educationCategories;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _educationCategories = stateObject["educationCategories"];        
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
                this._clearEducationCategoryActionCreator();
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              widget.partner["name"],             
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
