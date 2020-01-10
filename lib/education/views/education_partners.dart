import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/education/education_network.dart';
import 'package:gomotive/education/education_actions.dart';
import 'package:gomotive/practitioner/practitioner_utils.dart';
import 'package:gomotive/education/views/education_categories.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class EducationPartners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EducationPartners(),
      ),
    );
  }
}

class _EducationPartners extends StatefulWidget {
  @override
  _EducationPartnersState createState() => new _EducationPartnersState();
}

class _EducationPartnersState extends State<_EducationPartners> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _pageName = "education";  
  List<Map> _menuList;

  var _getEducationPartnersAPI, _clearEducationPartnerActionCreator;
  List<Map> _educationPartners;
 
  List<Widget> _listEducationPartners() {
    List<Widget> _list = new List<Widget>();
    if(_educationPartners != null) {
      for(int i=0; i<_educationPartners.length; i++) {
        GestureDetector _container = new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new EducationCategories(
                  partner: _educationPartners[i],
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
              _educationPartners[i]["name"]
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
        _getEducationPartnersAPI = stateObject["getEducationPartners"];
        _clearEducationPartnerActionCreator = stateObject["clearEducationPartner"];
        _getEducationPartnersAPI(context, {});   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();   
        returnObject["getEducationPartners"] = (BuildContext context, Map params) =>
            store.dispatch(getEducationPartners(context, params));         
        returnObject["clearEducationPartner"] = () =>
            store.dispatch(ClearEducationPartnerActionCreator());         
        returnObject["menuList"] = store.state.practitionerState.menuItems;
        returnObject["educationPartners"] = store.state.educationState.educationPartners;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _menuList = stateObject["menuList"];
        _educationPartners = stateObject["educationPartners"];
        if(_menuList != null) {
          int _currentIndex = PractitionerUtils.getCurrentIndex(_menuList, _pageName);
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
                  this._clearEducationPartnerActionCreator();
                  Navigator.of(context).pushReplacementNamed('/home/route');
                },
              ),
              backgroundColor: Colors.white,
              title: new Text(
                'Select one',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              items: PractitionerUtils.buildNavigationMenuBar(_menuList, _pageName),
              onTap: (int index) {
                PractitionerUtils.menubarTap(
                  context, _menuList, _pageName, index
                );
              },
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
                        children: _listEducationPartners() 
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
