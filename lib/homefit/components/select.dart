import 'package:flutter/material.dart';

class Select extends FormField<dynamic> {
  Select({
    Key key,
    List<Map<String, dynamic>> optionList,
    dynamic initialValue,
    String labelKey = "label",
    String valueKey = "value",
    InputDecoration decoration: const InputDecoration(
      labelText: 'Select a Option',
      hintText: 'Choose an option',
    ),
    TextStyle style,
    bool autovalidate: false,
    ValueChanged<dynamic> onFieldSubmitted,
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    bool enabled,
  })  : assert(optionList.length > 0),
        super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          builder: (FormFieldState<dynamic> field) {
            List<Map<String, dynamic>> options = new List();
            options.addAll(optionList);
            Map<String, dynamic> defaultOption = {};
            defaultOption[valueKey] = null;
            defaultOption[labelKey] = "Select an option";
            options.insert(0, defaultOption);
            final _SelectState state = field;
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return new InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: state.controller.data == null,
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<int>(
                  value: state.controller.data ?? null,
                  isDense: true,
                  onChanged: field.didChange,
                  items: options.map((Map<String, dynamic> option) {
                    return new DropdownMenuItem<int>(
                      key: new ValueKey<dynamic>(option[valueKey]),
                      value: option[valueKey],
                      child: new Text(option[labelKey]),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );

  @override
  _SelectState createState() => new _SelectState();
}

class _SelectState extends FormFieldState<dynamic> {
  SelectEditingController controller;

  @override
  Select get widget => super.widget;

  @override
  void initState() {
    super.initState();
    controller = new SelectEditingController(data: widget.initialValue);
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
class SelectEditingValue {
  const SelectEditingValue({
    this.data,
  });

  final dynamic data;

  SelectEditingValue copyWith({
    dynamic data,
  }) {
    return new SelectEditingValue(
      data: data,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! SelectEditingValue) return false;
    final SelectEditingValue typedOther = other;
    return typedOther.data == data;
  }

  @override
  int get hashCode => hashValues(data.hashCode, "select");
}

class SelectEditingController extends ValueNotifier<SelectEditingValue> {
  SelectEditingController({dynamic data})
      : super(new SelectEditingValue(data: data));

  SelectEditingController.fromValue(SelectEditingValue value) : super(value);

  dynamic get data => value.data;

  set data(dynamic data) {
    value = value.copyWith(data: data);
  }

  void clear() {
    value = null;
  }
}
