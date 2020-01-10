import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Thumbnail extends StatefulWidget {
  final String url;
  final String defaultImage;

  Thumbnail({
    this.url,
    this.defaultImage,
  });

  @override
  _ThumbnailState createState() => new _ThumbnailState();
}
class _ThumbnailState extends State<Thumbnail> {
    
  @override
  Widget build(BuildContext context) {    
    if(widget.url != null && widget.url != "") {
      return new Container(
        child: new CachedNetworkImage(
          imageUrl: widget.url,          
        )
      );
    } else {
      return new Container(
        child: new Image(
          image: new AssetImage(widget.defaultImage)
        )
      );
    }
  }
}
