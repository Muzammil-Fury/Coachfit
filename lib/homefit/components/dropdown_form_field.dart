import 'package:flutter/material.dart';

class DropdownFormField<T> extends FormField<dynamic> {
  DropdownFormField({
    Key key,
    List<Map<String,dynamic>> options,
    dynamic initialValue,
    String labelKey = "label",
    String valueKey = "value",
    InputDecoration decoration,
    bool autovalidate = false,
    bool enabled = true,
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
  }) : super(
    key: key,
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    initialValue: initialValue,
    enabled: enabled,
    builder: (FormFieldState<dynamic> field) {
      final _DropdownFormFieldState state = field;
      final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
          .applyDefaults(Theme.of(field.context).inputDecorationTheme);
      state.controller.data = initialValue;
      return InputDecorator(
        decoration:
            effectiveDecoration.copyWith(errorText: field.hasError ? field.errorText : null),
        isEmpty: state.controller.data == null,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: state.controller.data ?? null,
            isDense: true,
            onChanged: field.didChange,            
            items: options.map((Map<String,dynamic> option) {
              return new DropdownMenuItem<String>(
                key: new ValueKey<dynamic>(option[valueKey]),
                value: option[valueKey].toString(),
                child: new Text(option[labelKey]),
              );
            }).toList(),
          ),
        ),
      );
    },
  );

  @override
  _DropdownFormFieldState createState() => new _DropdownFormFieldState();
}

class _DropdownFormFieldState extends  FormFieldState<dynamic>  {
  DropdownFormFieldController controller;

  @override
  DropdownFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    controller = new DropdownFormFieldController(data: widget.initialValue);
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
class DropdownFormFieldEditingValue {
  const DropdownFormFieldEditingValue({
    this.data,
  });

  final dynamic data;

  DropdownFormFieldEditingValue copyWith({
    dynamic data,
  }) {
    return new DropdownFormFieldEditingValue(
      data: data,
    );
  }

  @override
  bool operator == (dynamic other) {
    if (identical(this, other))
      return true;
    if (other is! DropdownFormFieldEditingValue)
      return false;
    final DropdownFormFieldEditingValue typedOther = other;
    return typedOther.data == data;
  }

  @override
  int get hashCode => hashValues(data.hashCode,"select");
}

class DropdownFormFieldController extends ValueNotifier<DropdownFormFieldEditingValue> {
  DropdownFormFieldController({ dynamic data })
      : super(new DropdownFormFieldEditingValue(data: data));

  DropdownFormFieldController.fromValue(DropdownFormFieldEditingValue value)
      : super(value);

  dynamic get data => value.data;

  set data(dynamic data) {
    value = value.copyWith(data: data);
  }

  void clear() {
    value = null;
  }
}