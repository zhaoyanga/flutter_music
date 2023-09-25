import 'package:flutter/material.dart';
import '../find/index.dart';
import '../userInfo/index.dart';
import '../common/Table_Buttom/index.dart';
import '../common/Assets_Images.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  int tableIndex = 0;

  List<ButtomItem> tabList = [
    const ButtomItem(
        icon: AssetsImages.findPng,
        activeIcon: AssetsImages.findActivePng,
        lable: "发现",
        width: 28),
    const ButtomItem(
        icon: AssetsImages.discoverPodcastsPng,
        activeIcon: AssetsImages.discoverPodcastsActivePng,
        lable: "播客",
        width: 28),
    const ButtomItem(
        icon: AssetsImages.myPng,
        activeIcon: AssetsImages.myActivePng,
        lable: "我的",
        width: 28),
    const ButtomItem(
        icon: AssetsImages.communityPng,
        activeIcon: AssetsImages.communityActivePng,
        lable: "社区",
        width: 28)
  ];

  List<Widget> homePageList = [
    const FindPage(),
    const FindPage(),
    const UserInfoPage(),
    const FindPage(),
  ];

  @override
  Widget build(BuildContext context) {
    AppConfigBloc blob = BlocProvider.of<AppConfigBloc>(context);
    return MaterialApp(
      home: Scaffold(
        key: blob.state.scaffoldkey,
        body: IndexedStack(
          index: tableIndex,
          children: homePageList,
        ),
        bottomNavigationBar: TableButtom(
          tabBarIndex: tableIndex,
          tabBarList: tabList,
          tabBarTap: tabBarTap,
        ),
        drawer: const Drawer(
          backgroundColor: Colors.red,
          child: Center(
            child: Text("你点击了筛选"),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          highlightColor: Colors.transparent, splashColor: Colors.transparent),
    );
  }

  void tabBarTap(value) {
    setState(() {
      tableIndex = value;
    });
  }
}
