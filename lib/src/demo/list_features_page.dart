import 'dart:math';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../layout_container.dart';
import 'tile_control_item.dart';

class ListFeaturesPage extends StatefulWidget {
  const ListFeaturesPage({super.key});

  @override
  State<ListFeaturesPage> createState() => _ListFeaturesPageState();
}

class _ListFeaturesPageState extends State<ListFeaturesPage> {
  //late final List<TileData> _tileDataList;
  late final List<GlobalKey?> _tileKeys;
  late final ExpansionTileListController _controller;
  late final ValueNotifier<ExpansionMode> _expansionModeNotifier;
  final int _tileCount = 4;

  double _tileGapSize = 0;
  bool _separatorBuilder = false;
  bool _tileBuilder = false;
  Icon? _trailingIcon;
  bool _enableTrailingAnimation = true;
  bool _trailingAnimation = false;
  bool _customTheme = false;

  @override
  void initState() {
    super.initState();
    _controller = ExpansionTileListController();
    _expansionModeNotifier = ValueNotifier(ExpansionMode.any);
    /*_tileDataList = [
      _initBasicUsageData(),
      _initTrailingData(),
      _initControllerData(),
      _initExpansionModeData()
    ];*/
    _tileKeys = List.filled(_tileCount, null);
  }

  @override
  void dispose() {
    _expansionModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Demo :: List Features'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 30,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(
                child: LayoutContainer(
              child: _buildFeatures(context),
            ))));
  }

  Widget _buildFeatures(BuildContext context) {
    if (_customTheme) {
      return ExpansionTileTheme(
        data: ExpansionTileTheme.of(context).copyWith(
          backgroundColor: Colors.blueAccent.withOpacity(0.2),
          collapsedBackgroundColor: Colors.grey.withOpacity(0.3),
          iconColor: _tileBuilder ? Colors.white : Colors.blueAccent,
          collapsedIconColor: Colors.black54,
          textColor: _tileBuilder ? Colors.white : Colors.blueAccent,
          collapsedTextColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black26, width: 3),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black26, width: 1),
          ),
          //tilePadding: const EdgeInsets.all(8.0),
          //childrenPadding: const EdgeInsets.all(8.0),*/
          expandedAlignment: Alignment.centerLeft,
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: _buildExpansionTileList(context)),
      );
    } else {
      return _buildExpansionTileList(context);
    }
  }
  var  key = GlobalKey();
  Widget _buildExpansionTileList(BuildContext context) {
    var _tileDataList = [
      _initBasicUsageData(),
      _initTrailingData(),
      _initControllerData(),
      _initExpansionModeData()
    ];
    return ExpansionTileList(
      key: key,
      controller: _controller,
      tileGapSize: _tileGapSize,
      enableTrailingAnimation: _enableTrailingAnimation,
      expansionMode: _expansionModeNotifier.value,
      trailing: _trailingIcon ??
          const Icon(CupertinoIcons.chevron_up,
              size: 20, color: Colors.black45),
      trailingAnimation: _trailingAnimation ? _createTrailingAnimation() : null,
      tileBuilder: _tileBuilder ? _buildTileBuilder : null,
      separatorBuilder: _separatorBuilder ? _buildSeparatorBuilder : null,
      children: <ExpansionTile>[
        ..._tileDataList.indexed.map((data) {
          return _buildExpansionTile(data.$1, data.$2);
        })
      ],
    );
  }

  ExpansionTile _buildExpansionTile(int index, TileData data) {
    return ExpansionTile(
      key:_tileKeys[index] ??= GlobalKey(),
      title: Text(data.title,
          style: _customTheme
              ? const TextStyle(fontWeight: FontWeight.bold)
              : null),
      leading: Icon(data.icon),
      maintainState: true,
      shape: _tileBuilder
          ? const Border()
          : _customTheme
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black26, width: 2),
                )
              : Border.all(
                  color: Colors.black26,
                  width: 1,
                ),
      children: <Widget>[
        _customTheme
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Divider(
                  height: 1,
                  thickness: 3,
                  color: Colors.black12,
                ),
              )
            : const SizedBox.shrink(),
        ...data.children.map((child) {
          return child;
        })
      ],
    );
  }

  IndexedExpansionTileAnimation _createTrailingAnimation() {
    return IndexedExpansionTileAnimation(
        animate: Tween<double>(
            begin: 0.0, end: pi / (_trailingIcon?.icon == Icons.add ? 4 : 2)),
        builder: (context, index, value, child) {
          switch (_trailingIcon?.icon) {
            case Icons.remove:
              return Transform.translate(
                offset: Offset(value * 10.0, 0.0),
                child: Transform.rotate(
                  angle: value * 3,
                  child: child,
                ),
              );
            case CupertinoIcons.chevron_up_chevron_down:
              return Transform.scale(
                scale: max(value - 0.3, 0.5),
                child: child,
              );
            default:
              return Transform.rotate(
                angle: value,
                child: child,
              );
          }
        });
  }

  Widget _buildTileBuilder(BuildContext context, int index, Widget? child) {
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              //color: Colors.lime,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black26,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 2,
                  spreadRadius: 4,
                )
              ],
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
              /*RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: <Color>[Colors.yellow, Colors.deepOrange.shade900],
                  tileMode: TileMode.mirror,
                )*/
              ),
          child: child,
        ));
  }

  Widget _buildSeparatorBuilder(BuildContext context, int index) {
    var divider = Divider(
      height: 1,
      thickness: 3,
      color: (index % 2) == 0 ? Colors.orangeAccent : Colors.blueAccent,
    );
    return _tileBuilder
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: divider,
          )
        : divider;
  }

//***********************************************************
//***********************************************************
  ValueChanged<dynamic> _onUpdateState<T>(ValueChanged<T>? onUpdate) {
    return (value) {
      if (value is T) {
        setState(() => onUpdate?.call(value));
      }
    };
  }

  TileData _initBasicUsageData() {
    return (
      title: "Basic Usage",
      icon: Icons.library_books,
      children: [
        TileControlItem(
          label: "Custom Theme",
          description: "Make it look pretty",
          controlType: ControlType.bool_switch,
          controlValue: _customTheme,
          onEvent: _onUpdateState<bool>((value) => _customTheme = value),
        ),
        TileControlItem(
          label: "Tile Gap Size",
          description: "The gap between tiles",
          controlType: ControlType.numeric_spinner,
          controlValue: _tileGapSize,
          onEvent: _onUpdateState<double>((value) => _tileGapSize = value),
        ),
        TileControlItem(
          label: "Separator Builder",
          description: "Customize the separator between tiles",
          controlType: ControlType.bool_switch,
          controlValue: _separatorBuilder,
          onEvent: _onUpdateState<bool>((value) => _separatorBuilder = value),
        ),
        TileControlItem(
          label: "Tile Builder",
          description: "Customize the tiles before rendering",
          controlType: ControlType.bool_switch,
          controlValue: _tileBuilder,
          onEvent: _onUpdateState<bool>((value) => _tileBuilder = value),
        ),
      ]
    );
  }

  TileData _initTrailingData() {
    //exposure_minus_2_rounded
    var trailingIcons = [
      Icons.add,
      Icons.remove,
      CupertinoIcons.chevron_up_chevron_down,
      //Icons.keyboard_double_arrow_left_sharp,
    ].map((icon) => Icon(icon, size: 25, color: Colors.blueAccent)).toList();

    return (
      title: "Trailing",
      icon: Icons.tune,
      children: [
        TileControlItem(
          label: "Trailing Icon",
          description: "change the trailing icon",
          controlType: ControlType.list_toggle_buttons,
          controlGroup: trailingIcons,
          onEvent: _onUpdateState<int>((index) =>
              _trailingIcon = index < 0 ? null : trailingIcons[index]),
        ),
        TileControlItem(
          label: "Trailing Animation",
          description:
              "Customize the trailing animation sequence, duration and an optional builder",
          controlType: ControlType.bool_switch,
          controlValue: _trailingAnimation,
          onEvent: _onUpdateState<bool>((value) => _trailingAnimation = value),
        ),
        TileControlItem(
          label: "Enable Trailing Animation",
          description: "Disable or enable trailing animation",
          controlType: ControlType.bool_switch,
          controlValue: _enableTrailingAnimation,
          onEvent:
              _onUpdateState<bool>((value) => _enableTrailingAnimation = value),
        )
      ]
    );
  }

  TileData _initControllerData() {
    var rand = Random();
    return (
      title: "Controller",
      icon: Icons.settings,
      children: [
        TileControlItem(
          label: "Collapse All",
          description: "Collapse all tiles",
          controlType: ControlType.dynamic_action,
          onEvent: (_) => _controller.collapseAll(),
        ),
        TileControlItem(
          label: "Expand All",
          description: "Expand all tiles",
          controlType: ControlType.dynamic_action,
          onEvent: (_) => _controller.expandAll(),
        ),
        TileControlItem(
            label: "Toggle All",
            description: "Toggle all tiles",
            controlType: ControlType.dynamic_action,
            onEvent: (value) => List.generate(
                _tileCount, (index) => _controller.toggle(index))),
        TileControlItem(
          label: "Toggle First",
          description: "Toggle the first tile",
          controlType: ControlType.dynamic_action,
          onEvent: (_) => _controller.toggle(0),
        ),
        TileControlItem(
          label: "Toggle Last",
          description: "Toggle the last tile",
          controlType: ControlType.dynamic_action,
          onEvent: (_) => _controller.toggle(_tileCount - 1),
        ),
        TileControlItem(
          label: "Toggle Random",
          description: "Toggle a random tile",
          controlType: ControlType.dynamic_action,
          onEvent: (_) => _controller.toggle(rand.nextInt(4)),
        ),
      ]
    );
  }

  TileData _initExpansionModeData() {
    return (
      title: "Expansion Mode",
      icon: Icons.expand,
      children: const [
        (
          label: "At most one",
          description: "Only one tile can be expanded at a time",
          controlValue: ExpansionMode.atMostOne,
        ),
        (
          label: "At least one",
          description: "At least one tile must be expanded",
          controlValue: ExpansionMode.atLeastOne,
        ),
        (
          label: "Exactly one",
          description: "Exactly one tile will always be expanded",
          controlValue: ExpansionMode.exactlyOne,
        ),
        (
          label: "Any",
          description: "All tiles can be expanded and collapsed",
          controlValue: ExpansionMode.any,
        ),
      ].map((item) {
        return ValueListenableBuilder<ExpansionMode>(
          valueListenable: _expansionModeNotifier,
          builder: (context, value, child) {
            return TileControlItem(
                label: item.label,
                description: item.description,
                controlValue: item.controlValue,
                controlType: ControlType.dynamic_radio,
                controlGroup: value,
                onEvent: _onUpdateState<ExpansionMode>(
                    (value) => _expansionModeNotifier.value = value));
          },
        );
      }).toList()
    );
  }
}
