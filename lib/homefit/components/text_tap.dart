import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class TextTap extends StatelessWidget {

  final String textString;
  final String accessType;
  final String accessURL;
  final Color textColor;
  final double fontSize;

  TextTap(this.textString, this.accessType, this.accessURL, {this.textColor, this.fontSize});

  Future<Null> _launchInWebViewOrVC() async {
    if (await canLaunch(accessURL)) {
      await launch(accessURL, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $accessURL';
    }
  }

  _launch(BuildContext context) {
  	if(accessType == "web") {
  		_launchInWebViewOrVC();
	} else if(accessType == "route") {
		Navigator.of(context).pushNamed(accessURL);
	}
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
		  _launch(context);
      },
      child: new Text(
        textString, 
        style: new TextStyle(
          color: textColor,
          fontSize: fontSize,
        )
      ),
    );
  }
}
