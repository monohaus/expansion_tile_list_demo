import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

typedef TileData = ({String title, IconData icon, List<Widget> children});

enum ControlType {
  numeric_spinner,
  bool_switch,
  dynamic_action,
  dynamic_radio,
  list_toggle_buttons,
  dynamic_custom,
}

class TileControlItem extends StatefulWidget {
  const TileControlItem({
    super.key,
    required this.label,
    this.description,
    this.icon,
    this.controlBuilder,
    this.controlType = ControlType.bool_switch,
    //this.controlName,
    this.controlValue,
    this.controlGroup,
    this.onEvent,
  });

  final String label;
  final String? description;
  final IconData? icon;
  final WidgetBuilder? controlBuilder;
  final ControlType controlType;

  //final String? controlName;
  final dynamic controlValue;
  final dynamic controlGroup;
  final ValueChanged<dynamic>? onEvent;

  @override
  State<TileControlItem> createState() => _TileControlItemState();

  TileControlItem copyWith({
    Key? key,
    String? label,
    String? description,
    WidgetBuilder? controlBuilder,
    ControlType? controlType,
    dynamic controlValue,
    dynamic controlGroup,
    ValueChanged<dynamic>? onEvent,
  }) {
    return TileControlItem(
      key: key ?? this.key,
      label: label ?? this.label,
      description: description ?? this.description,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      controlType: controlType ?? this.controlType,
      controlValue: controlValue ?? this.controlValue,
      controlGroup: controlGroup ?? this.controlGroup,
      onEvent: onEvent ?? this.onEvent,
    );
  }
}

class _TileControlItemState extends State<TileControlItem> {
  dynamic _controlValue;
  FocusNode? _spinBoxFocusNode;

  @override
  void initState() {
    super.initState();
    _updateControlValue();
  }

  @override
  void didUpdateWidget(covariant TileControlItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlValue != widget.controlValue ||
        oldWidget.controlType != widget.controlType) {
      _updateControlValue();
    } /*else if (oldWidget.controlType != widget.controlType) {
      _updateControlValue(_controlValue);
    }*/
  }

  void _updateControlValue([dynamic currentValue]) {
    currentValue ??= widget.controlValue;
    if (widget.controlType == ControlType.bool_switch) {
      _controlValue = bool.tryParse(currentValue?.toString() ?? "false",
          caseSensitive: false);
    } else if (widget.controlType == ControlType.numeric_spinner) {
      var value =
          double.tryParse(currentValue?.toString() ?? double.nan.toString());
      _controlValue = [
        double.nan,
        double.maxFinite,
        double.minPositive,
        double.infinity,
        double.negativeInfinity
      ].contains(value)
          ? 1.0
          : value;
    } else if (widget.controlType == ControlType.list_toggle_buttons) {
      int size = widget.controlGroup is List
          ? (widget.controlGroup as List).length
          : 0;
      _controlValue = (currentValue is List<bool> && currentValue.isNotEmpty)
          ? currentValue
          : List<bool>.filled(size, false);
    } else {
      _controlValue = currentValue;
    }
  }

  @override
  void dispose() {
    _spinBoxFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.controlType) {
      case ControlType.bool_switch:
        return _buildSwitchListTile(context);
      case ControlType.numeric_spinner:
        return _buildListTile(context, _buildSpinBox(context), 0.35);
      case ControlType.dynamic_action:
        return _buildListTile(context, _buildActionChip(context), 0.35);
      case ControlType.dynamic_radio:
        return _buildRadioListTile(context);
      case ControlType.list_toggle_buttons:
        return _buildListTile(context, _buildToggleButtons(context),
            max(((_controlValue as List<bool>).length / 10) + 0.20,0.50) );
      case ControlType.dynamic_custom:
        return widget.controlBuilder?.call(context) ?? const SizedBox();
    }
  }

  //************************************************************
  Widget _buildListTile(BuildContext context,
      [Widget? child, widthFactor = 0.50]) {
    return ListTile(
      title: Text(widget.label),
      subtitle: widget.description != null ? Text(widget.description!) : null,
      //trailing: (widget.controlBuilder??defaultControlBuilder)?.call(context),
      trailing: FractionallySizedBox(
        alignment: Alignment.centerRight,
        widthFactor: widthFactor,
        child: Align(alignment: Alignment.centerRight, child: child),
      ),
    );
  }

  Widget _buildSwitchListTile(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.label),
      subtitle: widget.description != null ? Text(widget.description!) : null,
      value: _controlValue is bool ? _controlValue : false,
      onChanged: (value) {
        setState(() {
          _controlValue = value;
        });
        widget.onEvent?.call(value);
      },
    );
  }

  Widget _buildActionChip(BuildContext context) {
    return ActionChip(
      label: widget.icon == null ? Text(widget.label) : Text(""),
      avatar: widget.icon != null ? Icon(widget.icon) : null,
      onPressed: () {
        /*setState(() {
          _controlValue = true;
        });*/
        print("ActionChip onPressed");
        _controlValue = true;
        widget.onEvent?.call(true);
      },
    );
  }

  Widget _buildRadioListTile(BuildContext context) {
    return RadioListTile(
      title: Text(widget.label),
      subtitle: widget.description != null ? Text(widget.description!) : null,
      value: _controlValue,
      groupValue: widget.controlGroup,
      selected: _controlValue == widget.controlGroup,
      controlAffinity: ListTileControlAffinity.trailing,
      onChanged: (value) {
        setState(() {
          _controlValue = value;
        });
        widget.onEvent?.call(value);
      },
    );
  }

  Widget _buildToggleButtons(BuildContext context) {
    var toggleButtons =  ToggleButtons(
      borderRadius: BorderRadius.circular(30),
      borderWidth: 0,
      borderColor: Colors.transparent,
      selectedBorderColor: Colors.transparent, //Theme.of(context).colorScheme.primary,
      isSelected: _controlValue is List<bool> ? _controlValue : [],
      constraints: const BoxConstraints(
        minWidth: 40.0,
        minHeight: 40.0,
      ),
      onPressed: (index) {
        setState(() {
          for (int i = 0; i < _controlValue.length; i++) {
            _controlValue[i] = i == index ? !_controlValue[index] : false;
          }
        });
        widget.onEvent?.call(_controlValue[index] ? index : -1);
      },
      children: [
        ...(widget.controlGroup is List ? (widget.controlGroup as List) : [])
            .map(
          (e) => e is Widget ? e : Text(e.toString()),
        )
      ],
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.black38,
          width: 3,
        ),
      ),
      child: toggleButtons,
    );
  }

  Widget _buildSpinBox(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    var spinBoxBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: Colors.black38,
        width: 3,
      ),
    );

    var spinBox = SpinBox(
      min: 1.0,
      max: 50,
      value: 1.0,
      spacing: 0,
      focusNode: _spinBoxFocusNode ??= FocusNode(),
      enableInteractiveSelection: false,
      readOnly: false,
      showCursor: false,
      keyboardType: TextInputType.none,
      incrementIcon: const Icon(Icons.keyboard_arrow_up, size: 20),
      decrementIcon: const Icon(Icons.keyboard_arrow_down, size: 20),
      onChanged: (value) {
        setState(() {
          _controlValue = value;
        });
        widget.onEvent?.call(value);
      },
      decoration: InputDecoration(
        isDense: true,
        fillColor: Colors.white,
        //border: spinBoxBorder,
        enabledBorder: spinBoxBorder,
        disabledBorder: spinBoxBorder,
        focusedBorder: spinBoxBorder.copyWith(
            borderSide: BorderSide(
          color: primaryColor,
          width: 3,
        )),
        //contentPadding: const EdgeInsets.all(0),
      ),
    );

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: (pointerEvent) {
        if (!(_spinBoxFocusNode?.hasFocus ?? false)) {
          _spinBoxFocusNode?.requestFocus();
        }
      },
      child: TextSelectionTheme(
          data: const TextSelectionThemeData(
            cursorColor: Colors.transparent,
            selectionColor: Colors.transparent,
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: spinBox,
          )),
    );
  }
}
