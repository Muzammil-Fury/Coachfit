import 'package:flutter/material.dart';
import 'package:homefit/utils/utils.dart';
import 'dart:async';

typedef void GetSelectedDateValue(String selectedDateStr);

class DateField extends StatefulWidget {
  final String dateTitle;
  final String dateValue;
  final GetSelectedDateValue getSelectedDateValue;

  DateField(
      {this.dateTitle, this.dateValue, @required this.getSelectedDateValue});

  @override
  DateFieldState createState() => new DateFieldState();
}

class DateFieldState extends State<DateField> {
  final TextEditingController _dateController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.dateValue != null) {
      setState(() {
        _dateController.text =
            Utils.convertDateToDisplayString(DateTime.parse(widget.dateValue));
      });
    }
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = Utils.convertStringToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: new DateTime(1900),
      lastDate: new DateTime.now(),
    );

    if (result != null) {
      setState(() {
        _dateController.text = Utils.convertDateToDisplayString(result);
      });
      widget.getSelectedDateValue(Utils.convertDateToValueString(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: GestureDetector(
        onTap: () {
          _chooseDate(context, _dateController.text);
        },
        child: InputDecorator(
          child: new Text(_dateController.text),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            labelText: widget.dateTitle,
            border: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.black38),
            ),
          ),
        ),
      ),
    );
  }
}
