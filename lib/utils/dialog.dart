import 'package:flutter/material.dart';
import 'package:gomotive/core/app_constants.dart';
import 'dart:async';


class CustomDialog {

  static Future<int> alertDialog(
    BuildContext context, 
    String title, 
    String content
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            title,
          ),
          content: new SingleChildScrollView(
            child: Text(
              content
            )
          ),
          actions: <Widget>[            
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      'OK',
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }

  static Future<int> confirmDialog(
    BuildContext context, 
    String title, 
    String content,
    String okButton,
    String cancelButton
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            title,
          ),
          content: new SingleChildScrollView(
            child: Text(
              content
            )
          ),
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      okButton,
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      cancelButton,
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop(0); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }

  static Future<int> trackDialog(
    BuildContext context,     
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            "Track Workout",
          ),          
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Did it",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(2); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Did Part of it",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop(0); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }


  static Future<int> createWorkout(
    BuildContext context,     
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            "How would you like to create workout?",
          ),          
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Create from Workout Template",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(2); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Create new Workout",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop(0); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }

  static Future<int> createHabit(
    BuildContext context,     
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            "How would you like to create habit?",
          ),          
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Create from Habit Template",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(2); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Create new Habit",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop(0); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }

  static Future<int> createGoal(
    BuildContext context,     
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            "How would you like to create goal?",
          ),          
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Create from Goal Template",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(2); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Create new Goal",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop(0); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }


  static Future<int> dhfLibraryOptions(
    BuildContext context,     
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            "Select one",
          ),          
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Exercises",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(2); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Workout Templates",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ), 
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Game Plan Templates",
                      style: new TextStyle(color: primaryTextColor),
                    ),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(3); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                 
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context).pop(0); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }


}