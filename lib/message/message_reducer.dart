import 'package:redux/redux.dart';
import 'package:gomotive/message/message_actions.dart';
import 'package:gomotive/message/message_state.dart';

Reducer<MessageState> messageReducer = combineReducers([
  new TypedReducer<MessageState, MessageListSuccessActionCreator>(_messageListSuccessActionCreator),  
  new TypedReducer<MessageState, SelectMessageActionCreator>(_selectMessageActionCreator),  
  new TypedReducer<MessageState, ReplaceMessageActionCreator>(_replaceMessageActionCreator),  
  new TypedReducer<MessageState, ClearMessageActionCreator>(_clearMessageActionCreator),
  new TypedReducer<MessageState, CannedMessageGetSuccessActionCreator>(_cannedMessageGetSuccessActionCreator),
]);

MessageState _getCopy(MessageState state) {
  return new MessageState().copyWith( 
    messageList: state.messageList,
    paginateInfo: state.paginateInfo, 
    messageObj: state.messageObj,   
    listIndex: state.listIndex
  );
}


MessageState _messageListSuccessActionCreator(MessageState state,  MessageListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      messageList: action.messageList,
      paginateInfo: action.paginateInfo
    );  
  } else {
    return _getCopy(state).copyWith(
      messageList: []..addAll(state.messageList)..addAll(action.messageList),
      paginateInfo: action.paginateInfo,            
    );  
  }
}


MessageState _selectMessageActionCreator(MessageState state, SelectMessageActionCreator action) {
  return _getCopy(state).copyWith(
    messageObj: action.messageObj,
    listIndex: action.listIndex
  );
}

MessageState _replaceMessageActionCreator(MessageState state, ReplaceMessageActionCreator action) {
  MessageState newState = _getCopy(state).copyWith();
  newState.messageList[newState.listIndex] = action.messageObj;
  return newState;
}


MessageState _clearMessageActionCreator(MessageState state, ClearMessageActionCreator action) {
  return _getCopy(state).copyWith(
    messageObj: null
  );
}



MessageState _cannedMessageGetSuccessActionCreator(MessageState state, CannedMessageGetSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    cannedMessageObj: action.cannedMessageObj
  );
}