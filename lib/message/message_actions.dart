
class MessageListSuccessActionCreator {
  final List<Map> messageList;
  final Map paginateInfo;
  MessageListSuccessActionCreator(
    this.messageList,
    this.paginateInfo
  );
}

class SelectMessageActionCreator {
  final Map messageObj;
  final int listIndex;
  SelectMessageActionCreator(
    this.messageObj,
    this.listIndex
  );
}

class ReplaceMessageActionCreator {
  final Map messageObj;
  ReplaceMessageActionCreator(
    this.messageObj
  );
}

class ClearMessageActionCreator {
  ClearMessageActionCreator();
}

class CannedMessageGetSuccessActionCreator {
  final Map cannedMessageObj;
  CannedMessageGetSuccessActionCreator(
    this.cannedMessageObj
  );
}
