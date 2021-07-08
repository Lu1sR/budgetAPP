import 'package:budget/home/material_home_scaffold.dart';
import 'package:budget/home/tab_item.dart';
import 'package:budget/services/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final AuthBase auth;

  const HomePage({Key key, this.auth}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.feed;
  @override
  Widget build(BuildContext context) {
    return MaterialHomeScaffold(
        auth: widget.auth, currentTab: _currentTab, onSelectedTab: _select);
  }

  void _select(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }
}
