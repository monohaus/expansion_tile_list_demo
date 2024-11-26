import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/multi_view_app.dart';

void main() {
  runWidget(
    MultiViewApp(
      viewBuilder: (BuildContext context) => const App(),
    ),
  );
}
