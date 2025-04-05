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
  late final ValueNotifier<ExpansionMode> _expansionModeNotifier;
  late final ValueNotifier<(int, int)> _reorderNotifier;
  late final ValueNotifier<(int, bool)> _expansionNotifier;
  final int _tileCount = 6;

  double _tileGapSize = 0;
  bool _separatorBuilder = false;
  bool _tileBuilder = false;
  Icon? _trailingIcon;
  bool _enableTrailingAnimation = true;
  bool _trailingAnimation = false;
  bool _customTheme = false;

  //
  bool _reorderable = false;
  int _canReorder = -1;
  bool _onReorder = false;
  bool _customProxyDecorator = false;

  //bool _customDragHandle = false;
  bool _useDelayedDrag = false;
  Icon? _dragHandleIcon;
  Icon? _customDragHandleIcon;
  DragHandlePlacement _dragHandlePlacement = DragHandlePlacement.none;
  HorizontalAlignment? _dragHandleAlignment;

  //
  late final ExpansionTileListController _controller;
  var key = GlobalKey();
  late final List<GlobalKey?> _tileKeys;

  @override
  void initState() {
    super.initState();
    _controller = ExpansionTileListController();
    _expansionModeNotifier = ValueNotifier(ExpansionMode.any);
    _reorderNotifier = ValueNotifier((-1, -1));
    _expansionNotifier = ValueNotifier((-1, false));
    _tileKeys = List.filled(_tileCount, null);
  }

  @override
  void didUpdateWidget(covariant ListFeaturesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reorderNotifier.value = (-1, -1);
  }

  @override
  void dispose() {
    _expansionModeNotifier.dispose();
    _reorderNotifier.dispose();
    _expansionNotifier.dispose();
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
            body: /*SafeArea(child: _buildEx(),)*/
                SafeArea(
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

  Widget _buildExpansionTileList(BuildContext context) {
    var tileDataList = [
      _initBasicUsageData,
      _initTrailingData,
      _initControllerData,
      _initExpansionModeData,
      _initReorderableData,
      _initDragHandleData,
    ].indexed.map((fxn) => fxn.$2(fxn.$1)).toList();
    if (_reorderable) {
      return _buildReorderableExpansionTileList(tileDataList);
    }
    return _buildDefaultExpansionTileList(tileDataList);
  }

  Widget _buildReorderableExpansionTileList(List<TileData> tileDataList) {
    final customDragHandle = _customDragHandleIcon != null;
    return ExpansionTileList.reorderable(
      key: key,
      controller: _controller,
      itemGapSize: _tileGapSize,
      enableTrailingAnimation: _enableTrailingAnimation,
      expansionMode: _expansionModeNotifier.value,
      trailing: _buildTrailing(),
      trailingAnimation: _trailingAnimation ? _createTrailingAnimation() : null,
      itemBuilder: _tileBuilder /*|| customDragHandle*/
          ? _buildItemBuilder
          : null,
      separatorBuilder: _separatorBuilder ? _buildSeparatorBuilder : null,
      enableDefaultDragHandles: !customDragHandle,
      useDelayedDrag: _useDelayedDrag,
      dragHandlePlacement: _dragHandlePlacement,
      dragHandleAlignment:
          _dragHandleAlignment ?? HorizontalAlignment.centerLeft,
      dragHandleBuilder: !customDragHandle && _dragHandleIcon != null
          ? (context, index) => _dragHandleIcon
          : null,
      canReorder: _canReorder > -1
          ? (oldIndex, newIndex) {
              return _canReorder == 0
                  ? oldIndex > newIndex
                  : newIndex > oldIndex;
            }
          : null,
      onReorder: (oldIndex, newIndex) {
        _reorderNotifier.value = (oldIndex, newIndex);
        if (_onReorder) {
          var title = tileDataList[_controller.currentPosition(oldIndex)].title;
          showSnackBar(context, '$title at index $oldIndex moved to $newIndex');
        }
      },
      onExpansionChanged: (index, expanded) {
        _expansionNotifier.value = (index, expanded);
      },
      proxyDecorator: _customProxyDecorator
          ? (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Material(
                    elevation: 30,
                    color: Colors.lightBlueAccent,
                    child: Opacity(
                      opacity: animation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: child,
                ),
              );
            }
          : null,
      children: <ExpansionTile>[
        ...tileDataList.indexed.map((data) {
          return _buildExpansionTile(
            data.$1,
            data.$2,
            /*leading: customDragHandle &&
                      _dragHandlePlacement == DragHandlePlacement.leading
                  ? _buildRowLayout(Icon(data.$2.icon), prependWidgets: [
                      _buildDragHandle(data.$1, _customDragHandleIcon!)
                    ])
                  : null,
              trailing: customDragHandle &&
                      _dragHandlePlacement == DragHandlePlacement.trailing
                  ? _buildRowLayout(_buildTrailing(), prependWidgets: [
                      _buildDragHandle(data.$1, _customDragHandleIcon!)
                    ])
                  : null,
              title: customDragHandle &&
                      (_dragHandlePlacement == DragHandlePlacement.title ||
                          _dragHandlePlacement == DragHandlePlacement.none)
                  ? _buildRowLayout(_buildTitle(data.$2.title),
                      prependWidgets: [
                          if (_dragHandlePlacement == DragHandlePlacement.title)
                            _buildDragHandle(data.$1, _customDragHandleIcon!)
                        ],
                      appendWidgets: [
                          if (_dragHandlePlacement == DragHandlePlacement.none)
                            _buildDragHandle(data.$1, _customDragHandleIcon!)
                        ])
                  : null*/
          );
        })
      ],
    );
  }

  Widget _buildDefaultExpansionTileList(List<TileData> tileDataList) {
    return ExpansionTileList(
      key: key,
      controller: _controller,
      itemGapSize: _tileGapSize,
      enableTrailingAnimation: _enableTrailingAnimation,
      expansionMode: _expansionModeNotifier.value,
      trailing: _buildTrailing(),
      trailingAnimation: _trailingAnimation ? _createTrailingAnimation() : null,
      itemBuilder: _tileBuilder ? _buildItemBuilder : null,
      separatorBuilder: _separatorBuilder ? _buildSeparatorBuilder : null,
      children: <ExpansionTile>[
        ...tileDataList.indexed.map((data) {
          return _buildExpansionTile(data.$1, data.$2);
        })
      ],
    );
  }

  ExpansionTile _buildExpansionTile(int index, TileData data,
      {Widget? title, Widget? leading, Widget? trailing}) {
    return ExpansionTile(
      key: _tileKeys[index] ??= GlobalKey(),
      title: title ?? _buildTitle(index, data.title),
      leading: leading ?? Icon(data.icon),
      trailing: trailing,
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

  Widget _buildTitle(int index, String title) {
    final titleWidget = Text(title,
        style:
            _customTheme ? const TextStyle(fontWeight: FontWeight.bold) : null);
    if (_customDragHandleIcon != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomDragHandle(index, false, _customDragHandleIcon!),
          titleWidget,
          _buildCustomDragHandle(index, true, _customDragHandleIcon!),
        ],
      );
    }
    return titleWidget;
  }

  Widget _buildTrailing() {
    return _trailingIcon ??
        const Icon(CupertinoIcons.chevron_up, size: 20, color: Colors.black45);
  }

  /*Widget _buildRowLayout(
    Widget widget, {
    List<Widget> appendWidgets = const [],
    List<Widget> prependWidgets = const [],
  }) {
    if (appendWidgets.isNotEmpty || prependWidgets.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [...prependWidgets, widget, ...appendWidgets],
      );
    }
    return widget;
  }*/

  Widget _buildCustomDragHandle(int index, bool expandedAware, Widget child) {
    customDragHandle(index) {
      return Container(
        alignment: _dragHandleAlignment?.alignment ??
            HorizontalAlignment.center.alignment,
        child: _buildDragHandle(index, child),
      );
    }

    final invisibleChild = Visibility.maintain(visible: false, child: child);
    Widget? currentDragHandle;
    return ValueListenableBuilder<(int, bool)>(
        valueListenable: _expansionNotifier,
        builder: (context, value, _) {
          final i = _controller.currentPosition(index);
          if (value.$1 > -1 && value.$1 == i) {
            currentDragHandle = expandedAware == _controller.isExpanded(i)
                ? customDragHandle(index)
                : invisibleChild;
          }
          currentDragHandle =
              (value.$1 > -1 && value.$1 == i) || currentDragHandle == null
                  ? (expandedAware == _controller.isExpanded(i)
                      ? customDragHandle(index)
                      : invisibleChild)
                  : currentDragHandle;
          return currentDragHandle!;
        });
  }

  /*Widget _buildDragHandlex(int index, Widget child) {
    return _useDelayedDrag
        ? ReorderableDelayedDragStartListener(
            key: PageStorageKey(index),
            index: index,
            child: child,
          )
        : ReorderableDragStartListener(
            key: PageStorageKey(index),
            index: index,
            child: child,
          );
  }*/

  Widget _buildDragHandle(int valueIndex, Widget childHandle) {
    dragHandle(int index, Widget child) {
      return _useDelayedDrag
          ? ReorderableDelayedDragStartListener(
              key: PageStorageKey(index),
              index: index,
              child: child,
            )
          : ReorderableDragStartListener(
              key: PageStorageKey(index),
              index: index,
              child: child,
            );
    }

    Widget? currentDragHandle;
    return ValueListenableBuilder<(int, int)>(
      valueListenable: _reorderNotifier,
      builder: (context, (int, int) value, child) {
        var minIndex = min(value.$1, value.$2);
        var maxIndex = max(value.$1, value.$2);
        var index = _controller.currentPosition(valueIndex);
        if (minIndex < 0 || (index >= minIndex && index <= maxIndex)) {
          currentDragHandle = (index == valueIndex ? child : null) ??
              dragHandle(index, childHandle);
        }
        return currentDragHandle ?? dragHandle(index, childHandle);
      },
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // duration: const Duration(seconds: 3), // Duration before it disappears
        // behavior: SnackBarBehavior.floating, // Optional: floating style
        action: SnackBarAction(
          label: '✕',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  IndexedValueExpansionTileAnimation _createTrailingAnimation() {
    return IndexedValueExpansionTileAnimation(
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

  /*Widget _buildReorderableTileBuilder(
      BuildContext context, int index, Widget? child) {
    Widget? customDragHandle = _customDragHandleIcon;
    if (customDragHandle != null) {
      customDragHandle = _buildCustomDragHandle(
          _controller.initialPosition(index), false, customDragHandle);
      child = child != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [customDragHandle, child],
            )
          : customDragHandle;
    }
    return _tileBuilder
        ? _buildTileBuilder(context, index, child)
        : Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                child: child));
  }*/

  Widget _buildItemBuilder(BuildContext context, int index, Widget? child) {
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
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
              )),
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

  TileData _initBasicUsageData(int index) {
    return (
      title: "Basic Usage",
      icon: Icons.library_books,
      children: [
        TileControlItem(
          label: "Custom Theme",
          description: "Make it look pretty",
          controlType: ControlType.boolSwitch,
          controlValue: _customTheme,
          onEvent: _onUpdateState<bool>((value) => _customTheme = value),
        ),
        TileControlItem(
          label: "Tile Gap Size",
          description: "The gap between tiles",
          controlType: ControlType.numericSpinner,
          controlValue: _tileGapSize,
          onEvent: _onUpdateState<double>((value) => _tileGapSize = value),
        ),
        TileControlItem(
          label: "Separator Builder",
          description: "Customize the separator between tiles",
          controlType: ControlType.boolSwitch,
          controlValue: _separatorBuilder,
          onEvent: _onUpdateState<bool>((value) => _separatorBuilder = value),
        ),
        TileControlItem(
          label: "Tile Builder",
          description: "Customize the tiles before rendering",
          controlType: ControlType.boolSwitch,
          controlValue: _tileBuilder,
          onEvent: _onUpdateState<bool>((value) => _tileBuilder = value),
        ),
      ]
    );
  }

  TileData _initTrailingData(int index) {
    var iconColor = _tileBuilder ? Colors.white : Colors.blueAccent;
    var trailingIcons = [
      Icons.add,
      Icons.remove,
      CupertinoIcons.chevron_up_chevron_down,
    ].map((icon) => Icon(icon, size: 25, color: iconColor)).toList();

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

  TileData _initControllerData(int index) {
    var rand = Random();
    return (
      title: "Controller",
      icon: Icons.settings,
      children: [
        TileControlItem(
          label: "Collapse All",
          icon: Icons.keyboard_arrow_up_sharp,
          description: "Collapse all tiles",
          controlType: ControlType.dynamicIconButton,
          onEvent: (_) => _controller.collapseAll(),
        ),
        TileControlItem(
          label: "Expand All",
          icon: Icons.keyboard_arrow_down_sharp,
          description: "Expand all tiles",
          controlType: ControlType.dynamicIconButton,
          onEvent: (_) => _controller.expandAll(),
        ),
        TileControlItem(
            label: "Toggle All",
            icon: Icons.unfold_more,
            description: "Toggle all tiles",
            controlType: ControlType.dynamicIconButton,
            onEvent: (value) => List.generate(
                _tileCount, (index) => _controller.toggle(index))),
        TileControlItem(
          label: "Toggle First",
          icon: Icons.first_page,
          description: "Toggle the first tile",
          controlType: ControlType.dynamicIconButton,
          onEvent: (_) => _controller.toggle(0),
        ),
        TileControlItem(
          label: "Toggle Last",
          icon: Icons.last_page,
          description: "Toggle the last tile",
          controlType: ControlType.dynamicIconButton,
          onEvent: (_) => _controller.toggle(_tileCount - 1),
        ),
        TileControlItem(
          label: "Toggle Random",
          icon: Icons.shuffle,
          description: "Toggle a random tile",
          controlType: ControlType.dynamicIconButton,
          onEvent: (_) => _controller.toggle(rand.nextInt(_tileCount)),
        ),
      ]
    );
  }

  TileData _initExpansionModeData(int index) {
    return (
      title: "Expansion Mode",
      icon: Icons.expand,
      children: const [
        (
          label: "At most one",
          description: "One or zero tile can be expanded at a time",
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
                controlType: ControlType.dynamicRadio,
                controlGroup: value,
                onEvent: _onUpdateState<ExpansionMode>(
                    (value) => _expansionModeNotifier.value = value));
          },
        );
      }).toList()
    );
  }

  Icon getIconForDragHandlePlacement(DragHandlePlacement placement) {
    switch (placement) {
      case DragHandlePlacement.leading:
        return const Icon(Icons
            .drag_handle_rounded); // Or Icons.chevron_right_rounded if it is horizontal drag
      case DragHandlePlacement.title:
        return const Icon(Icons
            .more_vert_rounded); // Or Icons.drag_indicator_rounded if it is horizontal drag
      case DragHandlePlacement.trailing:
        return const Icon(Icons.drag_handle_rounded,
            textDirection: TextDirection
                .rtl); // Or Icons.chevron_left_rounded if it is horizontal drag
      default:
        return const Icon(
            Icons.help_outline_rounded); // Default icon, just in case
    }
  }

  TileData _initReorderableData(int index) {
    var iconColor = _reorderable
        ? _tileBuilder
            ? Colors.white
            : Colors.blueAccent
        : null;
    var canReorderIcons = [
      CupertinoIcons.up_arrow,
      CupertinoIcons.down_arrow,
    ].map((icon) => Icon(icon, size: 22, color: iconColor)).toList();

    return (
      title: "Reorderable",
      icon: CupertinoIcons.arrow_up_arrow_down, //Icons.drag_indicator,
      children: [
        TileControlItem(
          label: "Enable Reorderable",
          description: "Make it draggable",
          controlType: ControlType.boolSwitch,
          controlValue: _reorderable,
          onEvent: _onUpdateState<bool>((value) => _reorderable = value),
        ),
        TileControlItem(
          label: "On Reorder",
          description: "Alert when an item is reordered",
          controlType: ControlType.boolSwitch,
          controlValue: _onReorder,
          enabled: _reorderable,
          onEvent: (value) => _onReorder = value,
        ),
        TileControlItem(
          label: "Can Reorder",
          description: "Drag only in one direction (up or down)",
          controlType: ControlType.listToggleButtons,
          controlGroup: canReorderIcons,
          enabled: _reorderable,
          onEvent: _onUpdateState<int>((value) => _canReorder = value),
        ),
        TileControlItem(
          label: "Delayed Drag",
          description: "Drag starts after a long press",
          controlType: ControlType.boolSwitch,
          controlValue: _useDelayedDrag,
          enabled: _reorderable,
          onEvent: _onUpdateState<bool>((value) => _useDelayedDrag = value),
        ),
        TileControlItem(
          label: "Custom Proxy Decorator",
          description: "Customize the drag proxy widget",
          controlType: ControlType.boolSwitch,
          controlValue: _customProxyDecorator,
          enabled: _reorderable,
          onEvent:
              _onUpdateState<bool>((value) => _customProxyDecorator = value),
        ),
      ]
    );
  }

  TileData _initDragHandleData(int index) {
    var iconColor = _reorderable
        ? _tileBuilder
            ? Colors.white
            : Colors.blueAccent
        : null;
    iconColorIf(bool status) => status ? iconColor : null;
    var dragHandleIcons = [
      Icons.drag_handle,
      Icons.drag_indicator,
      Icons.dns_rounded,
    ]
        .map((icon) => Icon(icon,
            size: 22, color: iconColorIf(_customDragHandleIcon == null)))
        .toList();

    var customDragHandleIcons = [
      Icons.linear_scale,
      Icons.drag_handle,
      // Icons.dns_rounded,
    ].map((icon) => Icon(icon, size: 22, color: iconColor)).toList();

    iconMapEntry(key, icon, Color? color) => MapEntry(
        key,
        Icon(
          icon,
          size: 22,
          color: color,
          semanticLabel: key is Enum ? key.name : null,
        ));
    final dragHandlePlacementIcons = {
      DragHandlePlacement.leading: Icons.swipe_left_outlined,
      DragHandlePlacement.title: Icons.title_outlined,
      DragHandlePlacement.trailing: Icons.swipe_right_outlined,
    }.map((key, icon) =>
        iconMapEntry(key, icon, iconColorIf(_customDragHandleIcon == null)));

    final dragHandleAlignmentIcons = {
      HorizontalAlignment.centerLeft: Icons.align_horizontal_left,
      //HorizontalAlignment.center: Icons.align_horizontal_center,
      HorizontalAlignment.centerRight: Icons.align_horizontal_right,
    }.map((key, icon) => iconMapEntry(key, icon, iconColor));

    if (_dragHandleIcon?.icon != null) {
      _dragHandleIcon = dragHandleIcons.firstWhere(
          (icon) => icon.icon == _dragHandleIcon?.icon,
          orElse: () => _dragHandleIcon!);
    }

    if (_customDragHandleIcon?.icon != null) {
      _customDragHandleIcon = customDragHandleIcons.firstWhere(
          (icon) => icon.icon == _customDragHandleIcon?.icon,
          orElse: () => _customDragHandleIcon!);
    }

    return (
      title: "Drag Handle",
      icon: Icons.horizontal_split,
      children: [
        TileControlItem(
          label: "Drag Handle Placement",
          description: "Position the drag handle (leading, title, trailing)",
          controlType: ControlType.listToggleButtons,
          controlGroup: dragHandlePlacementIcons.values.toList(),
          enabled: _reorderable && _customDragHandleIcon == null,
          onEvent: _onUpdateState<int>((index) {
            _dragHandlePlacement = index < 0
                ? DragHandlePlacement.none
                : dragHandlePlacementIcons.keys.elementAt(index);
          }),
        ),
        TileControlItem(
          label: "Drag Handler Builder",
          description: "Customize the drag handle using builder",
          controlType: ControlType.listToggleButtons,
          controlGroup: dragHandleIcons,
          enabled: _reorderable && _customDragHandleIcon == null,
          onEvent: _onUpdateState<int>((index) {
            _dragHandleIcon = index < 0 ? null : dragHandleIcons[index];
          }),
        ),
        TileControlItem(
          label: "Drag Handle Alignment",
          description:
              "Align (left, right) the drag handle relative to placement position",
          controlType: ControlType.listToggleButtons,
          controlGroup: dragHandleAlignmentIcons.values.toList(),
          enabled: _reorderable,
          onEvent: _onUpdateState<int>((index) {
            _dragHandleAlignment = index < 0
                ? null
                : dragHandleAlignmentIcons.keys.elementAt(index);
          }),
        ),
        TileControlItem(
          label: "Custom Drag Handle",
          description: "Manually customize the drag handle, place it anywhere",
          controlType: ControlType.listToggleButtons,
          controlGroup: customDragHandleIcons,
          enabled: _reorderable,
          onEvent: _onUpdateState<int>((index) {
            _customDragHandleIcon =
                index < 0 ? null : customDragHandleIcons[index];
          }),
        ),
      ]
    );
  }
}
