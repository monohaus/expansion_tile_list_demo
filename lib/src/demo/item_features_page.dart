import 'dart:math';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../layout_container.dart';
import 'tile_control_item.dart';

class ItemFeaturesPage extends StatefulWidget {
  const ItemFeaturesPage({super.key});

  @override
  State<ItemFeaturesPage> createState() => _ItemFeaturesPageState();
}

class _ItemFeaturesPageState extends State<ItemFeaturesPage> {
  late final List<GlobalKey?> _tileKeys;
  late final List<ExpansionTileController?> _controllers;
  final int _tileCount = 1;

  //
  Icon? _trailingIcon;
  bool _enableTrailingAnimation = true;
  bool _trailingAnimation = false;
  bool _customTheme = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.filled(_tileCount, null);
    _tileKeys = List.filled(_tileCount, null);
  }

  @override
  void dispose() {
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
              title: const Text('Demo :: Item Features'),
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
              scrollable: false,
              child: _buildFeatures(context),
            ))));
  }

  Widget _buildFeatures(BuildContext context) {
    if (_customTheme) {
      return ExpansionTileTheme(
        data: ExpansionTileTheme.of(context).copyWith(
          backgroundColor: Colors.blueAccent.withOpacity(0.2),
          collapsedBackgroundColor: Colors.grey.withOpacity(0.3),
          iconColor: Colors.blueAccent,
          collapsedIconColor: Colors.black54,
          textColor: Colors.blueAccent,
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
        child: _buildExpansionTileItem(),
      );
    } else {
      return _buildExpansionTileItem();
    }
  }

  Widget _buildExpansionTileItem() {
    final tileDataList = [
      _initAllFeatures(),
    ];
    return Column(
      children: <Widget>[
        ...tileDataList.indexed.map((data) {
          return _buildExpansionTile(data.$1, data.$2);
        })
      ],
    );
  }

  ExpansionTile _buildExpansionTile(int index, TileData data) {
    return ExpansionTileItem(
      key: _tileKeys[index] ??= GlobalKey(),
      title: Text(data.title,
          style: _customTheme
              ? const TextStyle(fontWeight: FontWeight.bold)
              : null),
      leading: Icon(data.icon),
      controller: _controllers[index] ??= ExpansionTileController(),
      enableTrailingAnimation: _enableTrailingAnimation,
      trailingAnimation: _trailingAnimation ? _createTrailingAnimation() : null,
      initiallyExpanded: true,
      trailing: _trailingIcon ??
          const Icon(CupertinoIcons.chevron_up,
              size: 20, color: Colors.black45),
      shape: _customTheme
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black26, width: 2),
            )
          : Border.all(
              color: Colors.black26,
              width: 1,
            ),
      maintainState: true,
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

  ValueExpansionTileAnimation _createTrailingAnimation() {
    return ValueExpansionTileAnimation(
        animate: Tween<double>(
            begin: 0.0, end: pi / (_trailingIcon?.icon == Icons.add ? 4 : 2)),
        builder: (context, value, child) {
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

  //************* Helper function to update the state
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
          controlType: ControlType.boolSwitch,
          onEvent: _onUpdateState<bool>((value) => _customTheme = value),
        )
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
          controlType: ControlType.listToggleButtons,
          controlGroup: trailingIcons,
          onEvent: _onUpdateState<int>((index) =>
              _trailingIcon = index < 0 ? null : trailingIcons[index]),
        ),
        TileControlItem(
          label: "Trailing Animation",
          description:
              "Customize the trailing animation sequence, duration and an optional builder",
          controlType: ControlType.boolSwitch,
          controlValue: _trailingAnimation,
          onEvent: _onUpdateState<bool>((value) => _trailingAnimation = value),
        ),
        TileControlItem(
          label: "Enable Trailing Animation",
          description: "Disable or enable trailing animation",
          controlType: ControlType.boolSwitch,
          controlValue: _enableTrailingAnimation,
          onEvent:
              _onUpdateState<bool>((value) => _enableTrailingAnimation = value),
        )
      ]
    );
  }

  TileData _initAllFeatures() {
    return (
      title: "Expansion Tile Item",
      icon: Icons.tune,
      children: [
        ..._initBasicUsageData().children,
        ..._initTrailingData().children
      ]
    );
  }
}
