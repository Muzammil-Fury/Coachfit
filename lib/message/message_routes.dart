import 'package:gomotive/message/views/message_list.dart';
import 'package:gomotive/message/views/message_view.dart';
import 'package:gomotive/message/views/message_body_edit.dart';

var messageRoutes = {
	'/message/list': (context) => MessageList(),
  '/message/view': (context) => MessageView(),
  '/message/body/edit': (context) => MessageBodyEdit(),
};
