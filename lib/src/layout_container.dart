import 'package:flutter/cupertino.dart';

class LayoutContainer extends StatelessWidget {
  final Widget child;
  final bool scrollable;

  const LayoutContainer(
      {super.key, required this.child, this.scrollable = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        DeviceType deviceType = DeviceType.getDeviceType(context);
        var view = Center(
            child: SizedBox(
          width: (deviceType.isDesktop) ? 600 : null,
          //  height: (isPortrait && deviceType.isDesktop) ? 800 : null,
          child: child,
        ));
        if (scrollable) {
          return SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(parent: ClampingScrollPhysics()),
            child: view,
          );
        } else {
          return view;
        }
      },
    );
  }
}

enum DeviceType {
  phone,
  tablet,
  desktop;

  get isPhone => this == DeviceType.phone;

  get isTablet => this == DeviceType.tablet;

  get isDesktop => this == DeviceType.desktop;

  static DeviceType getDeviceType(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;
    DeviceType deviceType = DeviceType.desktop;
    if (size < 600) {
      deviceType = DeviceType.phone;
    } else if (size < 1100) {
      deviceType = DeviceType.tablet;
    }
    return deviceType;

    //final double smallestDimension = MediaQuery.of(context).size.shortestSide;
    /* final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double size = isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    print('orientationSize: $size');
    print('isPortrait: $isPortrait');
    DeviceType deviceType = DeviceType.desktop;
    if (size < 600) {
      deviceType = DeviceType.phone;
    } else if (size < 1100) {
      deviceType = DeviceType.tablet;
    }
    return deviceType;*/
  }
}
