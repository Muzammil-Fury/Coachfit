import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:homefit/utils/gomotive_icons.dart';


class MultiSelect extends FormField<dynamic> {
  MultiSelect({
    Key key,
    BuildContext context,
    List<Map<String,dynamic>> optionList,
    dynamic initialValue,
    String labelKey = "label",
    String valueKey = "value",
    InputDecoration decoration:  const InputDecoration(
      labelText: 'Select a Option',
      hintText: 'Choose an option',
    ),
    TextStyle style,
    bool autovalidate: false,
    ValueChanged<dynamic> onFieldSubmitted,
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    bool enabled,
  }):   assert(optionList.length > 0),
        assert(context != null),
        super(
        key: key,
        initialValue: initialValue,
        onSaved: onSaved,
        validator: validator,
        autovalidate: autovalidate,
        enabled: enabled,
        builder: (FormFieldState<dynamic> field) {
          final _MultiSelectState state = field;
          final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
              .applyDefaults(Theme.of(field.context).inputDecorationTheme);


          return  new InputDecorator(
            decoration: effectiveDecoration.copyWith(errorText: field.errorText),
            isEmpty: state.controller.data.length == 0,
            child: new _ChipsTile(
              context:context,
              options: optionList,
              valueList: state.controller.data,
              onChanged: field.didChange,
              onSubmitted: onFieldSubmitted,
              labelKey:labelKey,
              valueKey:valueKey
            )
          );
        },
      );


  @override
  _MultiSelectState createState() => new _MultiSelectState();

}

class _MultiSelectState extends  FormFieldState<dynamic>  {
  MultiSelectEditingController controller;


  @override
  MultiSelect get widget => super.widget;

  @override
  void initState() {
    super.initState();
    controller = new MultiSelectEditingController(data: widget.initialValue);
  }

  @override
  void didChange(value) {
    super.didChange(value);
    controller.data = value;
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      controller.data = widget.initialValue;
    });
  }

}




@immutable
class MultiSelectEditingValue {
  const MultiSelectEditingValue({
    this.data: const [],
  });

  final List<dynamic> data;


  MultiSelectEditingValue copyWith({
    List<dynamic> data,
  }) {
    return new MultiSelectEditingValue(
      data: data,
    );
  }

  @override
  bool operator == (dynamic other) {
    if (identical(this, other))
      return true;
    if (other is! MultiSelectEditingValue)
      return false;
    final MultiSelectEditingValue typedOther = other;
    Function eq = const ListEquality().equals;
    return eq(typedOther.data, data);
  }

  @override
  int get hashCode => hashValues(data.hashCode,"multiselect");
}

class MultiSelectEditingController extends ValueNotifier<MultiSelectEditingValue> {

  MultiSelectEditingController({ List<dynamic> data })
      : super(data == null ?  new MultiSelectEditingValue() : new MultiSelectEditingValue(data: data));


  MultiSelectEditingController.fromValue(MultiSelectEditingValue value)
      : super(value);


  List get data => value.data;


  set data(dynamic data) {
    value = value.copyWith(data: data);
  }

  void clear() {
    value = MultiSelectEditingValue();
  }

}


class _ChipsTile extends StatelessWidget {
  const _ChipsTile({
    Key key,
    this.context,
    this.options,
    this.valueList,
    this.onChanged,
    this.onSubmitted,
    this.labelKey,
    this.valueKey,
  }) : super(key: key);


  final BuildContext context;
  final List<Map<String,dynamic>> options;
  final List<dynamic> valueList;
  final ValueChanged<dynamic> onChanged;
  final ValueChanged<dynamic> onSubmitted;
  final String labelKey;
  final String valueKey;

  @override
  Widget build(BuildContext context) {

    final List<Map<String,dynamic>> selectedData = options.where((Map option) {
      if(valueList.contains(option[valueKey])){
        return true;
      }else{
        return false;
      }
    }).toList();

    final List<Widget> chips = selectedData.map<Widget>((Map option) {
      return new Chip(
        key: new ValueKey<dynamic>(option[valueKey]),
        label: new Text(option[labelKey]),
      );
    }).toList();


    return new GestureDetector(
      onTap: () {
        _pushSelection();
      },
      child: new ListTile(
        title: chips.isEmpty
            ? new Center(
          child: new Padding(
            padding: const EdgeInsets.all(2.0),
            child: new Text(
              'Select an option',
              style: Theme.of(context).textTheme.caption.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ) : new Wrap(
          children: chips
              .map((Widget chip) => new Padding(
            padding: const EdgeInsets.all(1.0),
            child: chip,
          ))
              .toList(),
        ),
      )
    );
  }

  void _pushSelection() async{
    var selectedList = new List();
    selectedList.addAll(valueList);
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => new OptionList(
          options:options,
          valueList:valueList,
          labelKey: labelKey,
          valueKey: valueKey,
      )),
    );
    if (results != null && results.containsKey('selection')) {
      this.onChanged(results['selection']);
    }



  }
}


class OptionList extends StatefulWidget {
  final List<Map<String,dynamic>> options;
  final List<dynamic> valueList;
  final String labelKey;
  final String valueKey;

  OptionList({this.options,this.valueList,this.labelKey = "label",this.valueKey = "value" });

  @override
  createState() => new OptionListState();
}

class OptionListState extends State<OptionList> {
  List<Map<String,dynamic>> _options =  <Map<String,dynamic>>[];
  List<dynamic> valueList;
  String labelKey = "label";
  String valueKey = "value";

  @override
  void initState() {
    super.initState();
    _options = widget.options;
    valueList = widget.valueList;
    labelKey = widget.labelKey;
    valueKey = widget.valueKey;
  }

  doSelect(){
    Navigator.of(context).pop({'selection':valueList});
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _options.map(
          (pair) {
        return new CheckboxListTile(
          title: new Text(pair[labelKey]),
          value:(valueList.contains(pair[valueKey])),
          onChanged: (bool value) {
            setState(() {
              if(value){
                valueList.add(pair[valueKey]);
              }else{
                valueList.remove(pair[valueKey]);
              }
            });
          },
        );
      },
    );
    final divided = ListTile
        .divideTiles(
      context: context,
      tiles: tiles,
    )
        .toList();

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            'Select Options'
          )
        ),
        leading: IconButton(                  
          icon: Icon(
            GomotiveIcons.back,
            size: 30.0,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              GomotiveIcons.select,
              size: 20.0,
              color: Colors.black87,
            ), 
            onPressed: doSelect
          )
        ],
      ),
      body: new ListView(children: divided),
    );
  }


}







