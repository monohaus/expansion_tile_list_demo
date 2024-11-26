import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'demo/item_features_page.dart';
import 'demo/list_features_page.dart';
import 'layout_container.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expansion Tile List',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: AppTheme.fontFamily,
            ),
        secondaryHeaderColor: Colors.black,
        brightness: Brightness.light,
        primaryColor: AppTheme.primary,
        fontFamily: AppTheme.fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.format_list_numbered_rtl, size: 30),
          title: const Text('Expansion Tile List'),
        ),
        body: SafeArea(
          child: LayoutContainer(
            scrollable: false,
            child: _buildPage(context),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    const pages = {
      'List Features Demo': ListFeaturesPage(),
      'Item Features Demo': ItemFeaturesPage(),
    };

    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(pages.keys.elementAt(index)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => pages.values.elementAt(index)));
            },
          );
        },
        itemCount: pages.length);
  }
}
