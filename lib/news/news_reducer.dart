import 'package:redux/redux.dart';
import 'package:gomotive/news/news_actions.dart';
import 'package:gomotive/news/news_state.dart';

Reducer<NewsState> newsReducer = combineReducers([
  new TypedReducer<NewsState, NewsListSuccessActionCreator>(_newsListSuccessActionCreator),
  new TypedReducer<NewsState, NewsGetSuccessActionCreator>(_newsGetSuccessActionCreator),    
  new TypedReducer<NewsState, ClearNewsObjectActionCreator>(_clearNewsObjectActionCreator),    
]);

NewsState _getCopy(NewsState state) {
  return new NewsState().copyWith( 
    newsList: state.newsList,
    paginateInfo: state.paginateInfo,
    newsObj: state.newsObj
  );
}


NewsState _newsListSuccessActionCreator(NewsState state,  NewsListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      newsList: action.newsList,
      paginateInfo: action.paginateInfo
    );  
  } else {
    return _getCopy(state).copyWith(
      newsList: []..addAll(state.newsList)..addAll(action.newsList),
      paginateInfo: action.paginateInfo,            
    );  
  }
}

NewsState _newsGetSuccessActionCreator(NewsState state,  NewsGetSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    newsObj: action.newsObj
  );    
}

NewsState _clearNewsObjectActionCreator(NewsState state,  ClearNewsObjectActionCreator action) {
  return _getCopy(state).copyWith(
    newsObj: null
  );    
}