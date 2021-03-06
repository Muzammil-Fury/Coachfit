import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/scheduler/scheduler_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:gomotive/scheduler/scheduler_actions.dart';
import 'package:gomotive/core/app_config.dart';

class StudioFacilityBooking extends StatelessWidget {
  final int studioFacilityId;
  StudioFacilityBooking({
    this.studioFacilityId
  });

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: _StudioFacilityBooking(
          studioFacilityId: this.studioFacilityId,
        ),
      ),
    );
  }
}

class _StudioFacilityBooking extends StatefulWidget {
  final int studioFacilityId;
  _StudioFacilityBooking({
    this.studioFacilityId
  });
  
  @override
  _StudioFacilityBookingState createState() => new _StudioFacilityBookingState();
}

class _StudioFacilityBookingState extends State<_StudioFacilityBooking> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getStudioFacilityBookingListAPI, 
      _bookStudioFacilityAPI, 
      _cancelBookingStudioFacilityAPI,
      _clearStudioFacilityBookingListActionCreator;
  int _selectedDate, _todaysDate;
  String _selectedDateStr;
  Map _studioFacility;
  List<Map> _bookingSlots;

  Future _chooseDateController(BuildContext context) async {
    var now = new DateTime.now();
    var initialDate = Utils.convertStringToDate(_selectedDateStr) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: new DateTime(2100),
    );

    if (result == null) return;        
    setState(() {      
      _selectedDate = result.millisecondsSinceEpoch;
      _selectedDateStr = Utils.convertDateToValueString(result).toString();
      this._clearStudioFacilityBookingListActionCreator();
      Map _params = new Map();
      _params["selected_date"] =_selectedDateStr;
      _params["facility_id"] = widget.studioFacilityId;
      _getStudioFacilityBookingListAPI(context, _params);
    });
  }

  
  @override
  void initState() { 
    _todaysDate = DateTime.now().millisecondsSinceEpoch;
    _selectedDate = _todaysDate;
    _selectedDateStr = Utils.convertDateToValueString(new DateTime.now()).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) { 
        _getStudioFacilityBookingListAPI = stateObject["getStudioFacilityBookingList"];
        _bookStudioFacilityAPI = stateObject["bookStudioFacility"];
        _cancelBookingStudioFacilityAPI = stateObject["cancelBookingStudioFacility"];
        _clearStudioFacilityBookingListActionCreator = stateObject["clearStudioFacilityBookingListActionCreator"];
        Map _params = new Map();
        _params["selected_date"] =_selectedDateStr;
        _params["facility_id"] = widget.studioFacilityId;
        _getStudioFacilityBookingListAPI(context, _params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();  
        returnObject["getStudioFacilityBookingList"] = (BuildContext context, Map params) =>
            store.dispatch(getStudioFacilityBookingList(context, params)); 
        returnObject["bookStudioFacility"] = (BuildContext context, Map params) =>
            store.dispatch(bookStudioFacility(context, params)); 
        returnObject["cancelBookingStudioFacility"] = (BuildContext context, Map params) =>
            store.dispatch(cancelBookingStudioFacility(context, params)); 
        returnObject["clearStudioFacilityBookingListActionCreator"] = () =>
            store.dispatch(ClearStudioFacilityBookingListActionCreator()); 
        returnObject["studioFacility"] = store.state.schedulerState.studioFacilityObj;
        returnObject["bookingSlots"] = store.state.schedulerState.studioFacilityBookingSlots;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _studioFacility = stateObject["studioFacility"];
        _bookingSlots = stateObject["bookingSlots"];
        if(_bookingSlots != null && _studioFacility != null && _studioFacility.keys.length > 0) {            
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 30.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  this._clearStudioFacilityBookingListActionCreator();
                  Navigator.of(context).pushReplacementNamed("/scheduler/studio_facility");
                },
              ),
              title: new Text(
                _studioFacility["name"],             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(
                      GomotiveIcons.appointments,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _chooseDateController(context);                         
                    },
                  ),                
                ),                
              ],
            ),
            body: new Container(                  
              child: _bookingSlots.length > 0
              ? new ListView.builder(
                  shrinkWrap: true,
                  itemCount: _bookingSlots.length + 1,
                  itemBuilder: (context, idx) {
                    if(idx==0) {
                      return new Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                        color: Colors.blueGrey,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                              child: new Text(
                                "Studio Facility: " + _studioFacility["name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white
                                )
                              )
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                              child: new Text(
                                "Bookings for " + Utils.convertDateStringToDisplayStringDate(_selectedDateStr),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white
                                )
                              )
                            )
                          ],
                        )
                      );
                    } else {
                      int i = idx - 1;
                      String _actionButtonText;
                      Color _actionButtonColor;
                      Color _actionButtonTextColor;
                      if(_bookingSlots[i]["status"] == "AVAILABLE" && _selectedDate >= _todaysDate) {
                        _actionButtonText = "BOOK";
                        _actionButtonColor = Colors.green;
                        _actionButtonTextColor = Colors.white;
                      }else if(_bookingSlots[i]["status"] == "BOOKED" && _selectedDate >= _todaysDate) {
                        _actionButtonText = "CANCEL";
                        _actionButtonColor = Colors.red;
                        _actionButtonTextColor = Colors.white;
                      } else {
                        _actionButtonText = "N/A";
                        _actionButtonColor = Colors.grey[200];
                        _actionButtonTextColor = Colors.black;
                      }
                      String _startTime = DateFormat.jm().format(
                        DateTime.parse(
                          _bookingSlots[i]["start_time"]
                        ).toLocal()
                      );
                      String _endTime = DateFormat.jm().format(
                        DateTime.parse(
                          _bookingSlots[i]["end_time"]
                        ).toLocal()
                      );
                      return new Container(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        decoration: new BoxDecoration(
                          border: new Border(
                            bottom: new BorderSide(
                              color: Colors.black12
                            ),
                          ),                              
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(
                              child: new Container(                         
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[                                                                  
                                    new Container(
                                      child: new Text(
                                        _startTime + " - " + _endTime,                                        
                                        style: TextStyle(
                                          fontSize: 16,
                                        )
                                      )
                                    ),
                                    new Container(
                                      child: new Text(
                                        "Slot Availability: " + 
                                        _bookingSlots[i]["booking_count"].toString() + 
                                        "/" +
                                        _studioFacility["max_client_count"].toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w100
                                        )
                                      )
                                    )
                                  ],
                                )                                
                              )
                            ),                        
                            new Container(
                              child: new FlatButton(
                                color: _actionButtonColor,
                                child: new Text(
                                  _actionButtonText,
                                ),
                                textColor: _actionButtonTextColor, 
                                onPressed: () {
                                  if(_actionButtonText == "BOOK") {
                                    Map _params = new Map();
                                    _params["facility_id"] = _studioFacility["id"];
                                    _params["id"] = _bookingSlots[i]["id"];
                                    _bookStudioFacilityAPI(context, _params);
                                  } else if(_actionButtonText == "CANCEL") {
                                    Map _params = new Map();
                                    _params["facility_id"] = _studioFacility["id"];
                                    _params["id"] = _bookingSlots[i]["id"];
                                    _cancelBookingStudioFacilityAPI(context, _params);
                                  }
                                },
                              ),
                            ),
                          ]
                        )                   
                      );
                    }
                  }
                ) 
              : new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                      color: Colors.blueGrey,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                            child: new Text(
                              "Studio Facility: " + _studioFacility["name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white
                              )
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                            child: new Text(
                              "Bookings for " + Utils.convertDateStringToDisplayStringDate(_selectedDateStr),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white
                              )
                            )
                          )
                        ],
                      )
                    ),
                    new Container(                    
                      padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 0.0),
                      child: new Text(
                        'No booking slots available for the selected date',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        )
                      )
                    )
                  ],
                )                
              )                     
            ),
          );
        } else {
          return new Container();
        }
      },  
    );
  }
}
