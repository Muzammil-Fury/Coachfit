import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ConversationState {

  final Map conversationObj;
  final List<Map> chatList;
  final Map paginateInfo;
  

  const ConversationState({
    this.conversationObj,
    this.chatList,
    this.paginateInfo,    
  });

  ConversationState copyWith({
    Map conversationObj,
    List<Map> chatList,
    Map paginateInfo,    
  }) {
    return new ConversationState(
      conversationObj: conversationObj ?? this.conversationObj,
      chatList: chatList ?? this.chatList,
      paginateInfo: paginateInfo ?? this.paginateInfo,      
    );
  }
}
