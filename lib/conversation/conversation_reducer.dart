import 'package:redux/redux.dart';
import 'package:gomotive/conversation/conversation_actions.dart';
import 'package:gomotive/conversation/conversation_state.dart';

Reducer<ConversationState> conversationReducer = combineReducers([
  new TypedReducer<ConversationState, ChatListSuccessActionCreator>(_chatListSuccessActionCreator),    
  new TypedReducer<ConversationState, ChatListClearActionCreator>(_chatListClearActionCreator),    
  new TypedReducer<ConversationState, PostChatSuccessActionCreator>(_postChatSuccessActionCreator),    
]);

ConversationState _getCopy(ConversationState state) {
  return new ConversationState().copyWith( 
    conversationObj: state.conversationObj,
    chatList: state.chatList,
    paginateInfo: state.paginateInfo,
  );
}

ConversationState _chatListSuccessActionCreator(ConversationState state,  ChatListSuccessActionCreator action) {  
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      conversationObj: action.conversationObj,
      chatList: action.chatList,
      paginateInfo: action.paginateInfo
    );  
  } else {
    return _getCopy(state).copyWith(
      conversationObj: action.conversationObj,
      chatList: []..addAll(state.chatList)..addAll(action.chatList),
      paginateInfo: action.paginateInfo,            
    );  
  }
}

ConversationState _postChatSuccessActionCreator(ConversationState state,  PostChatSuccessActionCreator action) {  
  ConversationState newState = _getCopy(state).copyWith();  
  newState.chatList.insert(0, action.chatObj);
  return newState;
}


ConversationState _chatListClearActionCreator(ConversationState state,  ChatListClearActionCreator action) {  
  return _getCopy(state).copyWith(
    conversationObj: new Map(),
    chatList: new List<Map>(),
    paginateInfo: new Map()  
  );  
}


