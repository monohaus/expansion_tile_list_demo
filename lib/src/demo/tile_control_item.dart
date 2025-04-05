import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

typedef TileData = ({String title, IconData icon, List<Widget> children});

enum ControlType {
  numericSpinner,
  boolSwitch,
  dynamicAction,
  dynamicRadio,
  dynamicIconButton,
  listToggleButtons,
  dynamicCustom,
}

class TileControlItem extends StatefulWidget {
  const TileControlItem({
    super.key,
    required this.label,
    this.description,
    this.icon,
    this.controlBuilder,
    this.controlType = ControlType.boolSwitch,
    //this.controlName,
    this.controlValue,
    this.controlGroup,
    this.enabled = true,
    this.onEvent,
  });

  //final bool enable
  final String label;
  final String? description;
  final IconData? icon;
  final WidgetBuilder? controlBuilder;
  final ControlType controlType;

  final bool enabled;

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
    bool? enabled,
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
      enabled: enabled ?? this.enabled,
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
    if (widget.controlType == ControlType.boolSwitch) {
      _controlValue = bool.tryParse(currentValue?.toString() ?? "false",
          caseSensitive: false);
    } else if (widget.controlType == ControlType.numericSpinner) {
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
    } else if (widget.controlType == ControlType.listToggleButtons) {
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
      case ControlType.boolSwitch:
        return _buildSwitchListTile(context);
      case ControlType.numericSpinner:
        return _buildListTile(context, _buildSpinBox(context), 0.35);
      case ControlType.dynamicAction:
        return _buildListTile(context, _buildActionChip(context), 0.35);
      case ControlType.dynamicIconButton:
        return _buildListTile(context, _buildIconButton(context), 0.35);
      case ControlType.dynamicRadio:
        return _buildRadioListTile(context);
      case ControlType.listToggleButtons:
        return _buildListTile(context, _buildToggleButtons(context),
            max(((_controlValue as List<bool>).length / 10) + 0.20, 0.50));
      case ControlType.dynamicCustom:
        return widget.controlBuilder?.call(context) ?? const SizedBox();
    }
  }

  //************************************************************
  Widget _buildListTile(BuildContext context,
      [Widget? child, widthFactor = 0.50]) {
    return ListTile(
      enabled: widget.enabled,
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
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _controlValue = value;
                widget.onEvent?.call(value);
              });
            }
          : null,
    );
  }

  Widget _buildActionChip(BuildContext context) {
    return ActionChip(
      label: widget.icon == null ? Text(widget.label) : const Text(""),
      avatar: widget.icon == null ? null : Icon(widget.icon),
      onPressed: widget.enabled
          ? () {
              /*setState(() {
          _controlValue = true;
        });*/
              _controlValue = true;
              widget.onEvent?.call(true);
            }
          : null,
    );
  }

  Widget _buildIconButton(BuildContext context) {
    const iconSize = 22.0;
    return IconButton(
      icon: widget.icon != null ? Icon(widget.icon) : const Icon(Icons.build),
      iconSize: iconSize,
      tooltip: widget.label,
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        foregroundColor: const WidgetStatePropertyAll(Colors.blueAccent),
        minimumSize:
            const WidgetStatePropertyAll(Size(iconSize * 3, iconSize * 2)),
        // Background color
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: Colors.black12, width: 3);
          }
          if (states.contains(WidgetState.pressed)) {
            return const BorderSide(color: Colors.blue, width: 3);
          }
          return const BorderSide(color: Colors.black26, width: 3);
        }),
      ),
      onPressed: widget.enabled
          ? () {
              _controlValue = true;
              widget.onEvent?.call(true);
            }
          : null,
    );
  }

  Widget _buildRadioListTile(BuildContext context) {
    return RadioListTile<dynamic>(
      title: Text(widget.label),
      subtitle: widget.description != null ? Text(widget.description!) : null,
      value: _controlValue,
      groupValue: widget.controlGroup,
      selected: _controlValue == widget.controlGroup,
      controlAffinity: ListTileControlAffinity.trailing,
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _controlValue = value;
                widget.onEvent?.call(value);
              });
            }
          : null,
    );
  }

  Widget _buildToggleButtons(BuildContext context) {
    var toggleButtons = ToggleButtons(
      borderRadius: BorderRadius.circular(30),
      borderWidth: 5,
      selectedBorderColor: Colors.blueAccent,
      //Theme.of(context).colorScheme.primary,
      //selectedBorderColor: const Color(0x30000000),
      disabledBorderColor: const Color(0x14000000),
      isSelected: _controlValue is List<bool> ? _controlValue : [],
      constraints: const BoxConstraints(
        minWidth: 40.0,
        minHeight: 40.0,
      ),
      onPressed: widget.enabled
          ? (index) {
              setState(() {
                for (int i = 0; i < _controlValue.length; i++) {
                  _controlValue[i] = i == index ? !_controlValue[index] : false;
                }
                widget.onEvent?.call(_controlValue[index] ? index : -1);
              });
            }
          : null,
      children: [
        ...(widget.controlGroup is List ? (widget.controlGroup as List) : [])
            .map(
          (e) => e is Widget ? e : Text(e.toString()),
        )
      ],
    );

    return toggleButtons;
    /*return Container(
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
    );*/
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
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _controlValue = value;
              });
              widget.onEvent?.call(value);
            }
          : null,
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
