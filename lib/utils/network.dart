import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:progress_hud/progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/dialog.dart';

typedef void Success(Map response);
typedef void Failure(dynamic error);

Future<Map<String, dynamic>> post(BuildContext context, String url, Map params,
    {showLoading = true}) async {

  var progress = new ProgressHUD (
    backgroundColor: Colors.transparent,
    color: Colors.white,
    containerColor: primaryColor,
    borderRadius: 1.0,
  );

  final String finalUrl = apiURL + url;
  Map body = Map();
  body.addAll(params);
  body["device_id"] = deviceId;
  body["app_version"] = appVersion;
  if(url != "authorize/user_logout") {
    if(selectedRoleName != "client") {
      body["practice_id"] = selectedRoleId;
      body["current_role_type"] = selectedRoleName;
    } else {
      body["current_role_type"] = selectedRoleName;
    }
  }

  if (showLoading) {
    showDialog(
        context: context, barrierDismissible: false, builder: (_) => progress);
  }  
  try {
    final response =
      await http.post(finalUrl, body: json.encode(body), headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': token
      });
    if (showLoading) {
      Navigator.pop(context);
    }
    Map data = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      String errorText = "";
      if (response.statusCode == 400) {
        errorText = "${data["reason"]}";
      } else if (response.statusCode == 401) {
        errorText = "${data["reason"]}";
      } else {
        errorText = "Failure - ${data["reason"]}";
      }      
      CustomDialog.alertDialog(context, "Error", errorText);
      return null;
    }
  } catch (error) {
    if (showLoading) {
      try {
        Navigator.pop(context);
      } catch(error) {        
      }
    }
    try {
      CustomDialog.alertDialog(context, "Error", "Network error: Please send an email to support@gomotive.com");
    }catch(error){      
    }
    return null;
  }
}