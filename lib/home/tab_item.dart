import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum TabItem { feed, info }

class TabItemData {
  final IconData icon;
  final IconData iconOutline;

  const TabItemData({@required this.iconOutline, @required this.icon});

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.feed: TabItemData(
        icon: MdiIcons.homeVariant, iconOutline: MdiIcons.homeVariantOutline),
    TabItem.info: TabItemData(
        icon: MdiIcons.account, iconOutline: MdiIcons.accountOutline),
  };
}
