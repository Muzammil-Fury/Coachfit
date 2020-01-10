import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/conversation/conversation_actions.dart';

const CONVERSATION_PACKAGE_VERSION = "1";

Function getChatList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CONVERSATION_PACKAGE_VERSION;
    Map responseData = await post(context, "conversation/chat_list", params);
    if (responseData != null) {
      store.dispatch(new ChatListSuccessActionCreator(
        responseData["data"]["conversation"],
        Utils.parseList(responseData["data"], 'chats'),
        responseData["data"]['paginate_info']
      ));
    }
  };
}

Function postChat(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CONVERSATION_PACKAGE_VERSION;
    Map responseData = await post(context, "conversation/chat_post", params);
    if (responseData != null) {
      store.dispatch(new PostChatSuccessActionCreator(
        responseData["data"]
      ));
    }
  };
}
