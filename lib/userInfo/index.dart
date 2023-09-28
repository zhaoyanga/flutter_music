import 'dart:convert';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import '../blob/app_config.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/Adapt.dart';
import '../common/Assets_Images.dart';
import '../common/CardItem.dart';
import '../common/Playbar.dart';
import '../sharedPreferences/index.dart';
import '../utils/request.dart';
import 'userPresentation.dart';
import 'userToolbar.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  // 我的歌单信息
  List songSheetInfo = [];

  // 获取本地用户信息
  Future<Map> getAccountInfo() async {
    Store store = await Store.getInstance();
    String accountInfo = await store.getAccountInfo('accountInfo');
    Map<String, dynamic> userMap = json.decode(accountInfo);
    return userMap;
  }

  // 获取我的歌单
  void getPlaylist() async {
    Map userInfo = await getAccountInfo();
    Http.post('getPlaylist', pathParams: {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'uid': userInfo['userId']
    }, params: {}).then((result) {
      if (result['code'] != 200) return;
      setState(() {
        songSheetInfo = result['playlist'];
      });
    });
  }

  List urlList = [];
  // 音乐列表在外面，playBar只需要对象。由外面控制播放哪首,需要抽成全局函数，需要就调用

  @override
  void initState() {
    getPlaylist();
    primaryTC = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  late double pinnedHeaderHeight;

  late TabController primaryTC;

  // 滚动控制器
  final ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    pinnedHeaderHeight =
        //statusBar height
        statusBarHeight;
    // statusBarHeight +
    //     //pinned SliverAppBar height in header
    //     kToolbarHeight 这个高度如果没使用他的SliverAppBar组件可以不用加，否则定位会错误;
    AppConfigBloc blob = BlocProvider.of<AppConfigBloc>(context);
    Adapt.initialize(context);
    return blob.state.accountInfo.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  blob.state.scaffoldkey.currentState?.openDrawer();
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Adapt.pt(24),
                    height: Adapt.pt(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:
                            NetworkImage(blob.state.accountInfo['avatarUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Adapt.pt(6),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: Adapt.pt(3)),
                    child: Text(
                      blob.state.accountInfo['nickname'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Adapt.pt(16),
                      ),
                    ),
                  )
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            drawer: const Drawer(
              backgroundColor: Colors.red,
              child: Center(
                child: Text("你点击了筛选"),
              ),
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ExtendedNestedScrollView(
                  headerSliverBuilder: (BuildContext c, bool f) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: Adapt.pt(18)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UserPresentation(
                                  accountInfo: blob.state.accountInfo),
                              SizedBox(height: Adapt.pt(24)),
                              const UserToolBar(),
                              SizedBox(height: Adapt.pt(18)),
                              CardItemMode(
                                songSheetInfo: songSheetInfo.isNotEmpty
                                    ? songSheetInfo[0]
                                    : {},
                                isHeartRate: true,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  pinnedHeaderSliverHeightBuilder: () {
                    return pinnedHeaderHeight;
                  },
                  onlyOneScrollInBody: true,
                  body: Container(
                    padding: EdgeInsets.symmetric(horizontal: Adapt.pt(18)),
                    child: Column(
                      children: <Widget>[
                        TabBar(
                          // 0xfff44336
                          controller: primaryTC,
                          labelColor: Colors.black,
                          unselectedLabelColor: const Color(0xff8d929c),
                          // 选择的样式
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          // 未选中的样式
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: Color(0xfff44336),
                              width: 4.0, // 指示器厚度
                            ),
                            insets: EdgeInsets.symmetric(
                                vertical: 6.0), // 设置指示器的水平间距
                          ),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          tabs: const <Tab>[
                            Tab(text: '创建歌单'),
                            Tab(text: '收藏歌单'),
                            Tab(text: '歌单助手'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: primaryTC,
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              ExtendedVisibilityDetector(
                                uniqueKey: const Key('Tab0'),
                                child: Container(
                                  child: _setListData(),
                                ),
                              ),
                              ExtendedVisibilityDetector(
                                uniqueKey: const Key('Tab1'),
                                child: Container(
                                  child: _setListData(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Adapt.pt(48),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<AppConfigBloc, AppConfig>(
                  builder: (_, state) => PlayBar(states: state),
                ),
              ],
            ),
          )
        : Container();
  }

  int getSongCount(bool my) {
    List info = List.from(songSheetInfo);
    int count = 0;
    for (var item in info) {
      if (!my) {
        if (item['subscribed']) {
          count++;
        }
      } else {
        if (!item['subscribed']) {
          count++;
        }
      }
    }
    return my ? count - 1 : count;
  }

  //tabarView里边的列表展示
  Widget _setListData() {
    return ListView(
      key: const PageStorageKey<String>('二手房'),
      children: [
        const SizedBox(height: 6),
        buildCard("创建歌单(${getSongCount(true)}个)", songSheetInfo[1]),
        const SizedBox(height: 18),
        buildCard("收藏歌单(${getSongCount(false)}个)",
            songSheetInfo.where((e) => e['subscribed']).toList()),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildCard(String name, info) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Color(0xffa6a5aa)),
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.more_vert,
                      color: Color(0xffa6a5aa),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (info is Map)
            Column(
              children: [
                CardItemMode(songSheetInfo: info.isNotEmpty ? info : {}),
                Row(
                  children: [
                    Container(
                      width: Adapt.pt(42),
                      height: Adapt.pt(42),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Adapt.pt(12)),
                        image: const DecorationImage(
                          image: AssetImage(AssetsImages.myImportPng),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "一键导入外部音乐",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )
          else
            for (int i = 0; i < info.length; i++)
              CardItemMode(songSheetInfo: info.isNotEmpty ? info[i] : {})
        ],
      ),
    );
  }
}
