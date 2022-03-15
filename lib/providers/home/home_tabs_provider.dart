import 'dart:collection';
import 'package:flutter/material.dart';

class HomeTabsProvider extends ChangeNotifier {
  final List<Widget> _tabs = [];
  late TabController _tabController;

  UnmodifiableListView<Widget> get getTabs => UnmodifiableListView(_tabs);
  TabController get getTabController => _tabController;

  // Setter
  void setTabs(final List<Widget> tabs, final TabController tabController) {
    _tabs.clear();
    _tabs.addAll(tabs);
    _tabController = tabController;
    notifyListeners();
  }

  // Singleton
  static final HomeTabsProvider _HomeTabsProvider =
      HomeTabsProvider._internal();

  factory HomeTabsProvider() {
    return _HomeTabsProvider;
  }

  HomeTabsProvider._internal();
}
