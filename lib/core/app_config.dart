
import 'package:flutter/material.dart';

const appVersion = "5.1.3";
const apiVersion = "6";
const deviceType = "m";

var packageName = ""; // Name of the package (Eg. com.gomotive.dhf)
var partnerSubdomain = "dhf";
var partnerAppType = "dhf";

var baseURL = "https://" + partnerSubdomain + ".gomotive.com/";
// var baseURL = "https://" + partnerSubdomain + ".qa.gomotive.com/";
// var baseURL = "http://" + partnerSubdomain + ".dev.gomotive.com:8000/";

var apiURL = baseURL + "api/" + deviceType + "/" + apiVersion + "/";

String token;
Map selectedUser;
String selectedRoleId;
String selectedRoleName;
String practiceDisplayName;
Map selectedRole;
String deviceId;
List<Map> roleList;
String notificationStr;
BuildContext initialContext;
String loadInitialURL;