import 'package:flutter/material.dart';
import '../Adapt.dart';

class ButtomItem {
  final String icon;
  final String activeIcon;
  final String lable;
  final double width;
  const ButtomItem(
      {required this.icon,
      required this.activeIcon,
      required this.lable,
      required this.width});
}

class TableButtom extends StatelessWidget {
  int tabBarIndex;
  Function tabBarTap;
  List<ButtomItem> tabBarList;

  TableButtom(
      {super.key,
      required this.tabBarIndex,
      required this.tabBarTap,
      required this.tabBarList});

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return BottomAppBar(
      child: BottomNavigationBar(
        items: tabBarList.asMap().keys.map(buildItemButton).toList(),
        type: BottomNavigationBarType.fixed,
        onTap: (value) => tabBarTap(value),
        currentIndex: tabBarIndex,
        //选中的颜色
        fixedColor: Colors.red,
        unselectedItemColor: const Color(0xffbfbfbf),
        selectedFontSize: Adapt.pt(10), // 选中字体大小
        unselectedFontSize: Adapt.pt(10), // 未选择字体大小
      ),
    );
  }

  BottomNavigationBarItem buildItemButton(int index) {
    ButtomItem item = tabBarList[index];

    return BottomNavigationBarItem(
        icon: Image.asset(
          item.icon,
          color: const Color(0xffbfbfbf),
          width: Adapt.pt(item.width),
          height: Adapt.pt(item.width),
        ),
        activeIcon: Image.asset(
          item.activeIcon,
          width: Adapt.pt(item.width),
          height: Adapt.pt(item.width),
        ),
        label: item.lable);
  }
}
