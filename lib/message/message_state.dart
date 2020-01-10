import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class MessageState {

  final List<Map> messageList;
  final Map paginateInfo;
  final Map messageObj;
  final int listIndex;
  final Map cannedMessageObj;

  const MessageState({
    this.messageList,
    this.paginateInfo,
    this.messageObj,
    this.listIndex,
    this.cannedMessageObj
  });

  MessageState copyWith({
    List<Map> messageList,
    Map paginateInfo,
    Map messageObj,
    int listIndex,
    Map cannedMessageObj
  }) {
    return new MessageState(
      messageList: messageList ?? this.messageList,
      paginateInfo: paginateInfo ?? this.paginateInfo,
      messageObj: messageObj ?? this.messageObj,
      listIndex: listIndex ?? this.listIndex,
      cannedMessageObj: cannedMessageObj ?? this.cannedMessageObj      
    );
  }
}
