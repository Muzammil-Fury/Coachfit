import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String headingText;
  Heading({this.headingText});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.black54,
      child: new Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),        
        child: new Text(
          headingText,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
