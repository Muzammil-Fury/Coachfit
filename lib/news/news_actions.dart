
class NewsListSuccessActionCreator {
  final List<Map> newsList;
  final Map paginateInfo;
  NewsListSuccessActionCreator(
    this.newsList,
    this.paginateInfo
  );
}

class NewsGetSuccessActionCreator {
  final Map newsObj;
  NewsGetSuccessActionCreator(
    this.newsObj
  );
}

class ClearNewsObjectActionCreator {
  ClearNewsObjectActionCreator();
}
