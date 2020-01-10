class ChatListSuccessActionCreator {
  final Map conversationObj;
  final List<Map> chatList;
  final Map paginateInfo;
  ChatListSuccessActionCreator(
    this.conversationObj,
    this.chatList,
    this.paginateInfo
  );
}

class ChatListClearActionCreator {
  ChatListClearActionCreator();
}

class PostChatSuccessActionCreator {
  final Map chatObj;  
  PostChatSuccessActionCreator(
    this.chatObj
  );
}
