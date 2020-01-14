import 'package:flutter/material.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';

class MenuUtils {

  static int getCurrentIndex(List<Map> _menuList, String _pageName) {
    for(int i=0; i<_menuList.length; i++) {
      if(_menuList[i]["name"] == _pageName) {
        return i;
      }
    }
    return 0;
  }

  static buildNavigationMenuBar(String _pageName) {
    
    List<BottomNavigationBarItem> _navigationItemList = new List<BottomNavigationBarItem>();
    BottomNavigationBarItem widget1 = new BottomNavigationBarItem(
      icon: new Icon(
        GomotiveIcons.home,
        color: _pageName == "home" ? dhfYellow : Colors.black87,
      ),
      title: new Text(
        "Home",
        style: TextStyle(
          color: _pageName == "home" ? dhfYellow : Colors.black87,
        )
      ),
    );
    _navigationItemList.add(widget1);        
    BottomNavigationBarItem widget2 = new BottomNavigationBarItem(
      icon: new Icon(
        GomotiveIcons.workouts,
        color: _pageName == "workouts" ? dhfYellow : Colors.black87,
      ),
      title: new Text(
        "Workouts",
        style: TextStyle(
          color: _pageName == "workouts" ? dhfYellow : Colors.black87,
        )
      ),
    );
    _navigationItemList.add(widget2);    
    if(token != null && token != "") {
      BottomNavigationBarItem widget4 = new BottomNavigationBarItem(
        icon: new Icon(
          Icons.credit_card,
          color: _pageName == "subscribe" ? dhfYellow : Colors.black87,
        ),
        title: new Text(
          "Plan",
          style: TextStyle(
            color: _pageName == "subscribe" ? dhfYellow : Colors.black87,
          )
        ),
      );
      _navigationItemList.add(widget4);
      /*BottomNavigationBarItem widget5 = new BottomNavigationBarItem(
        icon: new Icon(
          GomotiveIcons.edit_profile,
          color: _pageName == "profile" ? dhfYellow : Colors.black87,
        ),
        title: new Text(
          "Profile",
          style: TextStyle(
            color: _pageName == "profile" ? dhfYellow : Colors.black87,
          )
        ),
      );
      _navigationItemList.add(widget5);*/
    }                
    return _navigationItemList;
  }

  static menubarTap(BuildContext context, String pageName, int index) {    
    if(index == 0) {
      Navigator.of(context).pushNamed("/dashboard");      
    } else if(index == 1) {
      Navigator.of(context).pushNamed("/workouts");      
    } else if(index == 2) {
      Navigator.of(context).pushNamed("/my_plan");
    }/*else if(index == 3) {
      Navigator.of(context).pushNamed("/user");
    }*/
  }
  
}