import 'package:flutter/material.dart';


typedef void DidCancel();

class UploadProgress extends StatefulWidget {
  UploadProgress({Key key,this.progressState,@required this.doCancel}) : super(key: key);

  final UploadProgressState progressState;
  final DidCancel doCancel;

  @override
  UploadProgressState createState() => progressState;
}

class UploadProgressState extends State<UploadProgress>{
  double progress = 0.0;

  @override
  Widget build(BuildContext context){
    return new AlertDialog(
      title: new Text("Upload Progress"),
      content: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new LinearProgressIndicator(value: progress)
      ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                widget.doCancel();
                Navigator.pop(context);
              }
          ),
        ]
    );
  }
}