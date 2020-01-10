import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/components/video_app.dart';
import 'package:gomotive/gi/views/gi_3dmaps_performance.dart';
import 'dart:collection';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class GI3dmapsAssessment extends StatelessWidget {
  final Map client;
  final int engagementId;
  GI3dmapsAssessment({
    this.client,
    this.engagementId
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _GI3dmapsAssessment(
          client: this.client,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _GI3dmapsAssessment extends StatefulWidget {
  final Map client;
  final int engagementId;
  _GI3dmapsAssessment({
    this.client,
    this.engagementId
  });

  @override
  _GI3dmapsAssessmentState createState() => new _GI3dmapsAssessmentState();
}

class _GI3dmapsAssessmentState extends State<_GI3dmapsAssessment> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _notesController = new TextEditingController();
  List<Map> _3dmapsConfig;
  Map _3dmapsVideo;
  String _analysisType;
  String _assessmentType;
  String antR, antC, antL, pstR, pstC, pstL, sslR, sslC, sslL, oslR, oslC, oslL, ssrR, ssrC, ssrL, osrR, osrC, osrL;
  String _relativeSuccessCode;
  bool _autoPlay;
  
  _getNextValueForRightLeft(String currVal) {
    if(currVal == "") {
      return "-";
    } else if(currVal == "-") {
      return "-p";
    } else if(currVal == "-p"){
      return "";
    }
  }

  _getNextValueForCenter(String currVal) {
    if(currVal == "") {
      return "+";
    } else if(currVal == "+") {
      return "-";
    } else if(currVal == "-"){
      return "-p";
    } else if(currVal == "-p"){
      return "";
    }
  }

  _changeValue(String name, String lrc) {
    if(name == "ANT"){
      if(lrc == "r") {
        setState(() {
          antR = _getNextValueForRightLeft(antR);
          antC = "";
          antL = "";
        });
      } else if(lrc == "c") {
        setState(() {
          antR = "";
          antC = _getNextValueForCenter(antC);
          antL = "";
        });
      } else if(lrc == "l") {
        setState(() {
          antR = "";
          antC = "";
          antL = _getNextValueForRightLeft(antL);
        });
      }
    } else if(name == "PST"){
      if(lrc == "r") {
        setState(() {
          pstR = _getNextValueForRightLeft(pstR);
          pstC = "";
          pstL = "";
        });
      } else if(lrc == "c") {
        setState(() {
          pstR = "";
          pstC = _getNextValueForCenter(pstC);
          pstL = "";
        });
      } else if(lrc == "l") {
        setState(() {
          pstR = "";
          pstC = "";
          pstL = _getNextValueForRightLeft(pstL);
        });
      }
    } else if(name == "SSL"){
      if(lrc == "r") {
        setState(() {
          sslR = _getNextValueForRightLeft(sslR);
          sslC = "";
          sslL = "";
        });
      } else if(lrc == "c") {
        setState(() {
          sslR = "";
          sslC = _getNextValueForCenter(sslC);
          sslL = "";
        });
      } else if(lrc == "l") {
        setState(() {
          sslR = "";
          sslC = "";
          sslL = _getNextValueForRightLeft(sslL);
        });
      }
    } else if(name == "OSL"){
      if(lrc == "r") {
        setState(() {
          oslR = _getNextValueForRightLeft(oslR);
          oslC = "";
          oslL = "";
        });
      } else if(lrc == "c") {
        setState(() {
          oslR = "";
          oslC = _getNextValueForCenter(oslC);
          oslL = "";
        });
      } else if(lrc == "l") {
        setState(() {
          oslR = "";
          oslC = "";
          oslL = _getNextValueForRightLeft(oslL);
        });
      }
    } else if(name == "SSR"){
      if(lrc == "r") {
        setState(() {
          ssrR = _getNextValueForRightLeft(ssrR);
          ssrC = "";
          ssrL = "";
        });
      } else if(lrc == "c") {
        setState(() {
          ssrR = "";
          ssrC = _getNextValueForCenter(ssrC);
          ssrL = "";
        });
      } else if(lrc == "l") {
        setState(() {
          ssrR = "";
          ssrC = "";
          ssrL = _getNextValueForRightLeft(ssrL);
        });
      }
    } else if(name == "OSR"){
      if(lrc == "r") {
        setState(() {
          osrR = _getNextValueForRightLeft(osrR);
          osrC = "";
          osrL = "";
        });
      } else if(lrc == "c") {
        setState(() {
          osrR = "";
          osrC = _getNextValueForCenter(osrC);
          osrL = "";
        });
      } else if(lrc == "l") {
        setState(() {
          osrR = "";
          osrC = "";
          osrL = _getNextValueForRightLeft(osrL);
        });
      }
    }
  }

  _calculateRelativeSuccessCode() {
    Map<String, int> _order = new Map<String, int>();
    _order["ANT"] = 5;
    _order["PST"] = 5;
    _order["SSL"] = 5;
    _order["OSL"] = 5;
    _order["SSR"] = 5;
    _order["OSR"] = 5;
    for(int i=0;i<_order.keys.toList().length;i++) {
      String _test = _order.keys.toList()[i];
      String _left, _center, _right;
      _left="";
      _center="";
      _right="";
      if(_test == "ANT") {
        _left = antL;
        _center = antC;
        _right = antR;
      } else if(_test == "PST") {
        _left = pstL;
        _center = pstC;
        _right = pstR;
      } else if(_test == "SSL") {
        _left = sslL;
        _center = sslC;
        _right = sslR;
      } else if(_test == "OSL") {
        _left = oslL;
        _center = oslC;
        _right = oslR;
      } else if(_test == "SSR") {
        _left = ssrL;
        _center = ssrC;
        _right = ssrR;
      } else if(_test == "OSR") {
        _left = osrL;
        _center = osrC;
        _right = osrR;
      }
      if(_center == "+") {
        _order[_test] = 0;
      } else if(_left == "-" || _right == "-") {
        _order[_test] = 1;
      } else if(_center == "-") {
        _order[_test] = 2;
      } else if(_left == "-p" || _right == "-p") {
        _order[_test] = 3;
      } else if(_center == "-p") {
        _order[_test] = 4;
      } else {
        _order[_test] = 5;
      }
    } 
    var sortedKeys = _order.keys.toList(growable:false)
    ..sort((k1, k2) => _order[k1].compareTo(_order[k2]));
    LinkedHashMap sortedMap = new LinkedHashMap
      .fromIterable(sortedKeys, key: (k) => k, value: (k) => _order[k]);
    _relativeSuccessCode = "";
    for(int i=0;i<sortedMap.keys.toList().length;i++) {
      if(_relativeSuccessCode == "") {
        _relativeSuccessCode = sortedMap.keys.toList()[i];
      } else {
        _relativeSuccessCode = _relativeSuccessCode + "," + sortedMap.keys.toList()[i];
      }      
    } 
  }

  @override
  void initState() {
    _autoPlay = false;
    _assessmentType = "ANT Mobility";
    _analysisType = "3";
    antR = antC = antL = pstR = pstC = pstL = sslR = sslC = sslL = oslR = oslC = oslL = ssrR = ssrC = ssrL = osrR = osrC = osrL = "";
    _3dmapsVideo = {
      "ANT Mobility": "https://player.vimeo.com/external/257731495.m3u8?s=0f459b25887117dce32298a5941f43d5fa2d2fff&oauth2_token_id=1042420788",
      "ANT Stability": "https://player.vimeo.com/external/257731540.m3u8?s=ba192363672b7153fc4aa0ece5c4c056aed0e088&oauth2_token_id=1042420788",
      "PST Mobility": "https://player.vimeo.com/external/257731497.m3u8?s=736060a18d2bdf31c4503826572a88dcf97b62aa&oauth2_token_id=1042420788",
      "PST Stability": "https://player.vimeo.com/external/257731543.m3u8?s=f86141f82da5ed0add57f578cc58cb99be07f6f3&oauth2_token_id=1042420788",
      "SSL Mobility": "https://player.vimeo.com/external/257731498.m3u8?s=2c421666ace2d8c616f0f74ceaab76247f4da10a&oauth2_token_id=1042420788",
      "SSL Stability": "https://player.vimeo.com/external/257731548.m3u8?s=dc808251e7a3c224d61866b6b25273266e60e2a7&oauth2_token_id=1042420788",
      "OSL Mobility": "https://player.vimeo.com/external/257731500.m3u8?s=9155f1c4a7dccd7f6d77b4df72b023a590f49f40&oauth2_token_id=1042420788",
      "OSL Stability": "https://player.vimeo.com/external/257731554.m3u8?s=61bd625545e677bc7f8adad596447fb47c3d03bb&oauth2_token_id=1042420788",
      "SSR Mobility": "https://player.vimeo.com/external/257731503.m3u8?s=7dd51ba99c72b77647152b9a463307f2d10da80f&oauth2_token_id=1042420788",
      "SSR Stability": "https://player.vimeo.com/external/257731558.m3u8?s=dc993440cd2de530cc915e1b2b56ddbee02b5190&oauth2_token_id=1042420788",
      "OSR Mobility": "https://player.vimeo.com/external/257731506.m3u8?s=dae1563607cf7a978ae16150f20ecbef9aa2c0a9&oauth2_token_id=1042420788",
      "OSR Stability": "https://player.vimeo.com/external/257731560.m3u8?s=abead536e7119aea2b2073453500b667686efdd8&oauth2_token_id=1042420788",
    };
    _3dmapsConfig = [
        {
            "name": "ANT",            
            "mobility_thumbnail":"https://i.vimeocdn.com/video/685721120_640x360.jpg?r=pad",
            "stability_thumbnail" : "https://i.vimeocdn.com/video/685721282_640x360.jpg?r=pad"
        },
        {
            "name": "PST",
            "mobility_thumbnail":"https://i.vimeocdn.com/video/685721143_640x360.jpg?r=pad",
            "stability_thumbnail" : "https://i.vimeocdn.com/video/685721097_640x360.jpg?r=pad"
        },
        {
            "name": "SSL",
            "mobility_thumbnail":"https://i.vimeocdn.com/video/685720990_640x360.jpg?r=pad",
            "stability_thumbnail": "https://i.vimeocdn.com/video/685722433_640x360.jpg?r=pad"
        },
        {
            "name": "OSL",
            "mobility_thumbnail":"https://i.vimeocdn.com/video/685721104_640x360.jpg?r=pad",
            "stability_thumbnail" : "https://i.vimeocdn.com/video/685721985_640x360.jpg?r=pad"
        },
        {
            "name": "SSR",
            "mobility_thumbnail":"https://i.vimeocdn.com/video/685721114_640x360.jpg?r=pad",
            "stability_thumbnail" : "https://i.vimeocdn.com/video/685721722_640x360.jpg?r=pad"
        },
        {
            "name": "OSR",
            "mobility_thumbnail":"https://i.vimeocdn.com/video/685721039_640x360.jpg?r=pad",
            "stability_thumbnail": "https://i.vimeocdn.com/video/685721680_640x360.jpg?r=pad"
        }
    ];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
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
               "3DMAPS Assessment",             
              style: TextStyle(
                color: Colors.black87
              )   
            ),            
            actions: <Widget>[ ],
          ),
          body: new LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              double halfWidth = (MediaQuery.of(context).size.width)/2;
              double imageWidth = (halfWidth)/2;
              double inputWidth = (halfWidth-30)/3;
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blueGrey,
                      child: new Text(
                        _assessmentType,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      )
                    ),
                    new Container(                      
                      child: new VideoApp(
                        videoUrl: _3dmapsVideo[_assessmentType],
                        autoPlay: _autoPlay,
                      ),
                    ),
                    new Expanded(
                      child: new ListView.builder(
                        shrinkWrap: true,
                        itemCount: _3dmapsConfig.length+3,
                        itemBuilder: (context, i) {  
                          if(i == 0) {
                            return new Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black12,
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: new Center (
                                      child: new Avatar(
                                        url: widget.client["avatar_url_tb"],
                                        name: widget.client["name"],
                                        maxRadius: 24,
                                      ),
                                    )
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          child: new Text(
                                            widget.client["name"]
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            widget.client["email"],
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w100
                                            )
                                          )
                                        )
                                      ],
                                    )
                                  )
                                ],
                              )
                            );
                          } else if(i == 1) {
                            return new Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                              child: new DropdownFormField(
                                initialValue: _analysisType,        
                                decoration: InputDecoration(
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                autovalidate: true,
                                options: [
                                  {
                                    "label": "Mobility Analysis",
                                    "value": "1"
                                  },
                                  {
                                    "label": "Stability Analysis",
                                    "value": "2"
                                  },
                                  {
                                    "label": "Mostability Analysis",
                                    "value": "3"
                                  },
                                ],
                                validator: (value) {
                                  if(_analysisType != value) {
                                    _analysisType = value;
                                    if(_analysisType == "1") {
                                      _assessmentType = "ANT Mobility";
                                    } else if(_analysisType == "2") {
                                      _assessmentType = "ANT Stability";
                                    } else {
                                      _assessmentType = "ANT Mobility";
                                    }
                                  }
                                },        
                              ),
                            );
                          } else if (i>=2 && i<=7){
                            int idx = i - 2;
                            String right="";
                            String center="";
                            String left = "";

                            if(_3dmapsConfig[idx]["name"] == "ANT") {
                              right = antR;
                              center = antC;
                              left = antL;
                            } else if(_3dmapsConfig[idx]["name"] == "PST") {
                              right = pstR;
                              center = pstC;
                              left = pstL;
                            } else if(_3dmapsConfig[idx]["name"] == "SSL") {
                              right = sslR;
                              center = sslC;
                              left = sslL;
                            } else if(_3dmapsConfig[idx]["name"] == "OSL") {
                              right = oslR;
                              center = oslC;
                              left = oslL;
                            } else if(_3dmapsConfig[idx]["name"] == "SSR") {
                              right = ssrR;
                              center = ssrC;
                              left = ssrL;
                            } else if(_3dmapsConfig[idx]["name"] == "OSR") {
                              right = osrR;
                              center = osrC;
                              left = osrL;
                            }
                            return new Container(        
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.blueGrey,
                                    child: new Text(
                                      _3dmapsConfig[idx]["name"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      )
                                    )
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        new Container(
                                          child: new Row(
                                            children: <Widget>[
                                              _analysisType == "1" || _analysisType == "3"
                                              ? new Container(
                                                  child: GestureDetector(
                                                    onTap:() {
                                                      setState(() {
                                                        _assessmentType = _3dmapsConfig[idx]["name"] + " Mobility";
                                                        _autoPlay = true;
                                                      });
                                                    },
                                                    child: new Stack(
                                                      alignment: AlignmentDirectional.bottomCenter,                              
                                                      children: <Widget>[
                                                        new Container(
                                                          padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                                          width: imageWidth,
                                                          child: new CachedNetworkImage(
                                                            imageUrl: _3dmapsConfig[idx]["mobility_thumbnail"]
                                                          )
                                                        ),
                                                        new Positioned(  
                                                          child: new Text(
                                                            'Mobility',
                                                            style: TextStyle(
                                                              fontSize: 10.0
                                                            )
                                                          ),
                                                        ),                                                                                      
                                                      ],
                                                    )
                                                  )
                                                )
                                              : new Container(),
                                              _analysisType == "2" || _analysisType == "3"
                                              ? new Container(
                                                  child: new GestureDetector(
                                                    onTap:() {
                                                      setState(() {
                                                        _assessmentType = _3dmapsConfig[idx]["name"] + " Stability";
                                                        _autoPlay = true;
                                                      });
                                                    },
                                                    child: new Stack(
                                                      alignment: AlignmentDirectional.bottomCenter,                              
                                                      children: <Widget>[
                                                        new Container(
                                                          padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                                          width: imageWidth,
                                                          child: new CachedNetworkImage(
                                                            imageUrl: _3dmapsConfig[idx]["stability_thumbnail"]
                                                          )
                                                        ),
                                                        new Positioned(  
                                                          child: new Text(
                                                            'Stability',
                                                            style: TextStyle(
                                                              fontSize: 10.0
                                                            )
                                                          ),
                                                        ),                                                                                      
                                                      ],
                                                    )
                                                  )
                                                )
                                              : new Container(),                        
                                            ],
                                          )
                                        ),
                                        new Container(
                                          child: new Row(
                                            children: <Widget>[
                                              new Container(
                                                child: new Column(
                                                  children: <Widget>[
                                                    new Container(
                                                      child: new Text('R'),
                                                    ),
                                                    new Container(
                                                      padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                                      child: new GestureDetector(
                                                        onTap:() {
                                                          _changeValue(_3dmapsConfig[idx]["name"], "r");
                                                        },
                                                        child: new Container(
                                                          width: inputWidth,
                                                          height: 40,
                                                          decoration: new BoxDecoration(
                                                            border: new Border.all(color: Colors.black54)                      
                                                          ),
                                                          child: new Center(
                                                            child: new Text(
                                                              right,
                                                              style: TextStyle(
                                                                fontSize: 24
                                                              )
                                                            )
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),
                                              new Container(
                                                child: new Column(
                                                  children: <Widget>[
                                                    new Container(
                                                      child: new Text('C'),
                                                    ),
                                                    new Container(
                                                      padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                                      child: new GestureDetector(
                                                        onTap:() {
                                                          _changeValue(_3dmapsConfig[idx]["name"], "c");
                                                        },
                                                        child: new Container(
                                                          width: inputWidth,
                                                          height: 40,
                                                          decoration: new BoxDecoration(
                                                            border: new Border.all(color: Colors.black54)                      
                                                          ),
                                                          child: new Center(
                                                            child: Text(
                                                              center,
                                                              style: TextStyle(
                                                                fontSize: 24
                                                              )
                                                            ),
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),
                                              new Container(
                                                child: new Column(
                                                  children: <Widget>[
                                                    new Container(
                                                      child: new Text('L'),
                                                    ),
                                                    new Container(
                                                      padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                                      child: new GestureDetector(
                                                        onTap:() {
                                                          _changeValue(_3dmapsConfig[idx]["name"], "l");
                                                        },
                                                        child: new Container(
                                                          width: inputWidth,
                                                          height: 40,
                                                          decoration: new BoxDecoration(
                                                            border: new Border.all(color: Colors.black54)                      
                                                          ),
                                                          child: new Center(
                                                            child: Text(
                                                              left,
                                                              style: TextStyle(
                                                                fontSize: 24
                                                              )
                                                            ),
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              )                                                
                                            ],
                                          )
                                        )                                    
                                      ],
                                    )
                                  )
                                ],
                              )
                            );
                          } else {
                            return new Container(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.blueGrey,
                                    child: new Text(
                                      "Notes",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      )
                                    )
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                    child: new TextField(
                                      controller: _notesController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: new InputDecoration(
                                        border: new OutlineInputBorder(                                          
                                          borderSide: const BorderSide(
                                            color: Colors.black87
                                          ),                                          
                                        ),
                                        hintStyle: new TextStyle(color: Colors.grey[800]),
                                        hintText: "Enter Notes",
                                      ),
                                    )
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                    child: new FlatButton(
                                      color: primaryColor,                                
                                      child: new Text(
                                        'Generate RSC and Select Performance System',
                                        style: TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 13.5,
                                        )
                                      ),
                                      onPressed: () {
                                        _calculateRelativeSuccessCode();
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => new GI3dmapsPerformance(
                                              client: widget.client,
                                              engagementId: widget.engagementId,
                                              analysisType: int.parse(_analysisType),
                                              relativeSuccessCode: _relativeSuccessCode,
                                              notes: _notesController.text,
                                            ),
                                          ),
                                        );                           
                                      },
                                    ),
                                  )
                                ],
                              )
                            );                            
                          }                   
                        }                      
                      )
                    )
                  ]                      
                )
              );
            },
          ),
        );
        
      }
    );
  }
}