import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/message/message_actions.dart';
import 'package:gomotive/utils/dialog.dart';

const MESSAGE_PACKAGE_VERSION = "1";

Function getMessageList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = MESSAGE_PACKAGE_VERSION;
    Map responseData = await post(context, "message/message_list", params);
    if (responseData != null) {
      store.dispatch(new MessageListSuccessActionCreator(
        Utils.parseList(responseData, 'messages'),
        responseData['paginate_info']
      ));
    }
  };
}

Function viewMessage(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = MESSAGE_PACKAGE_VERSION;
    Map responseData = await post(context, "message/message_view", params);
    if(responseData != null) {
      store.dispatch(new ReplaceMessageActionCreator(
        responseData["message"]
      ));
    }    
  };
}

Function getCannedMessage(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = MESSAGE_PACKAGE_VERSION;
    Map responseData = await post(context, "message/canned_message_get", params);
    if(responseData != null) {
      store.dispatch(new CannedMessageGetSuccessActionCreator(
        responseData["canned_message"]
      ));
    }    
  };
}

Function messagePracticeAllClients(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = MESSAGE_PACKAGE_VERSION;
    Map responseData = await post(context, "message/message_all_practice_clients", params);
    if(responseData != null) {
      CustomDialog.alertDialog(context, "Message Sent", "Email has been sent to all practice clients").then((int respose) {
        Navigator.of(context).pop();
      });
    }    
  };
}