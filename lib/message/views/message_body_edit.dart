import 'package:flutter/material.dart';
// import 'package:zefyr/zefyr.dart';
import 'package:gomotive/core/app_config.dart';

class MessageBodyEdit extends StatelessWidget {
  final String title;
  final String body;
  MessageBodyEdit({
    this.title,
    this.body
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(  
        backgroundColor: Colors.white,
        title: new Text(
          this.title,                       
          style: TextStyle(
            color: Colors.black87
          )   
        ),                    
      ),
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _MessageBodyEdit(
          body: this.body
        ),
      ),
    );
  }
}
class _MessageBodyEdit extends StatefulWidget {
  final String body;
  _MessageBodyEdit({
    this.body
  });
  @override
  _MessageBodyEditState createState() => new _MessageBodyEditState();
}

class _MessageBodyEditState extends State<_MessageBodyEdit> {
  // ZefyrController _controller;
  // FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Create an empty document or load existing if you have one.
    // Here we create an empty document:
    // final document = new NotusDocument();
    // _controller = new ZefyrController(document);
    // _focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return Container();
    // return ZefyrScaffold(
    //   child: ZefyrEditor(
    //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    //     controller: _controller,
    //     focusNode: _focusNode,
    //   ),
    // );
  }
}