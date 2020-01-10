import 'package:flutter/material.dart';
import 'package:gomotive/utils/color_utils.dart';

class Avatar extends StatefulWidget {
  final String url;
  final String name;
  final double maxRadius;
  Avatar({
    this.url,
    this.name,
    this.maxRadius
  });

  @override
  _AvatarState createState() => new _AvatarState();
}
class _AvatarState extends State<Avatar> {
      
  @override
  Widget build(BuildContext context) {    
    if(widget.url != null && widget.url != "") {
      return new CircleAvatar(
        backgroundImage: NetworkImage(widget.url),
        maxRadius: widget.maxRadius,
        backgroundColor: Colors.transparent,
      );
    } else {
      List<String> nameArray = widget.name.split(" ");
      String shortName;
      if(nameArray.length >= 2) {
        shortName = nameArray[0].substring(0,1).toUpperCase() + nameArray[1].substring(0,1).toUpperCase();
      } else {
        shortName = widget.name.substring(0,2).toUpperCase();
      }
      return new CircleAvatar(
        backgroundColor: ColorUtils.getDynamicBackgroundColor(shortName.substring(1,2)),
        child: new Text(
          shortName,
          style: TextStyle(
            fontSize: widget.maxRadius
          )
        ),
        maxRadius: widget.maxRadius,
      );
    }    
  }
}
