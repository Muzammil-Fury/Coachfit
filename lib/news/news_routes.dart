import 'package:gomotive/news/views/client_news_list.dart';
import 'package:gomotive/news/views/practitioner_news_list.dart';

var newsRoutes = {
	'/client/news/list': (context) => ClientNewsList(),
  '/practitioner/news/list': (context) => PractitionerNewsList(),
};
