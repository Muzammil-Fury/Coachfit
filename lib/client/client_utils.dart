import 'package:flutter/material.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_constants.dart';

class ClientUtils {

  static const clientMenuRouteOptions = <String, String>  {    
    'home': "/client/home",
    'tracking': "/client/tracking",
    'scheduler': "/client/scheduler",
    'profile': "/client/profile",
  };

  static int getCurrentIndex(List<Map> _menuList, String _pageName) {
    for(int i=0; i<_menuList.length; i++) {
      if(_menuList[i]["name"] == _pageName) {
        return i;
      }
    }
    return 0;
  }

  static buildNavigationMenuBar(List<Map> _menuList, String _pageName) {

    final _clientMenuIcons = <String, IconData>  {
      'home': GomotiveIcons.home,
      'tracking': GomotiveIcons.track_goal,
      'scheduler': GomotiveIcons.appointments,
      'profile': GomotiveIcons.profile,
    };
    List<BottomNavigationBarItem> _navigationItemList = new List<BottomNavigationBarItem>();
    if(_menuList != null) {      
      for(int i=0; i<_menuList.length; i++) {
        if(_menuList[i]["name"] == 'profile') {
          BottomNavigationBarItem widget = new BottomNavigationBarItem(
            icon: new Image.asset(
              "assets/images/user_profile.png",
              color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
              width: 32,
            ),
            title: new Text(
              _menuList[i]["title"],
              style: TextStyle(
                color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
              )
            ),
          );
          _navigationItemList.add(widget);
        } else {
          BottomNavigationBarItem widget = new BottomNavigationBarItem(
            icon: new Icon(
              _clientMenuIcons[_menuList[i]["name"]],
              color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
            ),
            title: new Text(
              _menuList[i]["title"],
              style: TextStyle(
                color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
              )
            ),
          );
          _navigationItemList.add(widget);
        }
        
      }
    }
    return _navigationItemList;
  }

  static menubarTap(
    BuildContext context, List<Map> menuList, String pageName, int index,
    int programCount, String programType, int programId) {
    if(menuList[index]["name"] != pageName) {
      if(index == 0) {
        Navigator.of(context).pushReplacementNamed(
          "/client/home"
        );
      } else {
        Navigator.of(context).pushNamed(
          ClientUtils.clientMenuRouteOptions[menuList[index]["name"]]
        );
      }
    }
  }
 

}