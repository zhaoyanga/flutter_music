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
import '../utils/ShowModalBottomSheet.dart';
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
                                  modalList: likeModalList),
                              SizedBox(height: Adapt.pt(12)),
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
                          labelStyle: TextStyle(
                            fontSize: Adapt.pt(16),
                            fontWeight: FontWeight.bold,
                          ),
                          // 未选中的样式
                          unselectedLabelStyle: TextStyle(
                            fontSize: Adapt.pt(16),
                          ),
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: const Color(0xfff44336),
                              width: Adapt.pt(4), // 指示器厚度
                            ),
                            insets: EdgeInsets.symmetric(
                                vertical: Adapt.pt(6)), // 设置指示器的水平间距
                          ),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: Adapt.pt(24)),
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
                                uniqueKey: const Key('创建歌单'),
                                child: Container(
                                  child: _setListData('创建歌单'),
                                ),
                              ),
                              ExtendedVisibilityDetector(
                                uniqueKey: const Key('收藏歌单'),
                                child: Container(
                                  child: _setListData('收藏歌单'),
                                ),
                              ),
                              ExtendedVisibilityDetector(
                                uniqueKey: const Key('歌单助手'),
                                child: Container(
                                  child: _setListData('歌单助手'),
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
  Widget _setListData(String key) {
    return ListView(
      key: PageStorageKey<String>(key),
      children: [
        if (key == '创建歌单') SizedBox(height: Adapt.pt(6)),
        if (key == '创建歌单')
          buildCard("创建歌单(${getSongCount(true)}个)",
              songSheetInfo.isNotEmpty ? songSheetInfo[1] : {}),
        if (key == '收藏歌单' || key == '创建歌单') SizedBox(height: Adapt.pt(12)),
        if (key == '收藏歌单' || key == '创建歌单')
          buildCard("收藏歌单(${getSongCount(false)}个)",
              songSheetInfo.where((e) => e['subscribed']).toList()),
        SizedBox(height: Adapt.pt(18)),
      ],
    );
  }

  Widget buildCard(String name, info) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.pt(12)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: Adapt.pt(12), left: Adapt.pt(12), right: Adapt.pt(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Color(0xffa6a5aa)),
                ),
                Row(
                  children: [
                    info is Map
                        ? InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.add,
                              color: Color(0xffa6a5aa),
                            ),
                          )
                        : Container(),
                    SizedBox(width: Adapt.pt(12)),
                    InkWell(
                      onTap: () {
                        ShowModalBottomSheet.showBottomModal(context,
                            modalList: info is Map
                                ? [
                                    {
                                      "name": "新建歌单",
                                      "icon": Icons.add_circle,
                                    },
                                    {
                                      "name": "管理歌单",
                                      "icon": Icons.edit_note,
                                    },
                                    {
                                      "name": "一键导入外部音乐",
                                      "icon": Icons.change_circle,
                                    },
                                    {
                                      "name": "恢复歌单",
                                      "icon": Icons.history,
                                    },
                                  ]
                                : [
                                    {
                                      "name": "管理歌单",
                                      "icon": Icons.edit_note,
                                    },
                                  ], fn: (int index, Map item) {
                          print('111111111,$item');
                        }, name: name);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Color(0xffa6a5aa),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          if (info is Map)
            Column(
              children: [
                CardItemMode(
                    songSheetInfo: info.isNotEmpty ? info : {},
                    modalList: modalList),
                Container(
                  padding: EdgeInsets.only(
                      left: Adapt.pt(12),
                      right: Adapt.pt(12),
                      bottom: Adapt.pt(12)),
                  child: Row(
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
                      SizedBox(width: Adapt.pt(12)),
                      const Text(
                        "一键导入外部音乐",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            for (int i = 0; i < info.length; i++)
              CardItemMode(
                  songSheetInfo: info.isNotEmpty ? info[i] : {},
                  modalList: otherModalList)
        ],
      ),
    );
  }

  // 我喜欢底部弹出数据
  List likeModalList = [
    {
      "name": "Wifi下自动下载歌曲",
      "description": "下载会员歌曲将占用当月付费下载额度",
      "icon": Icons.arrow_circle_down,
      "isSwitch": false,
      "switchChange": (bool val) {
        print('11111111111,$val');
      },
    },
    {
      "name": "添加歌曲",
      "icon": Icons.add_circle,
    },
    {
      "name": "编辑歌曲排序",
      "icon": Icons.change_circle,
    },
    {"name": "清空下载文件", "icon": Icons.delete, "mark": 'empty'},
    {
      "name": "恢复歌单",
      "icon": Icons.history,
    },
  ];

  // 年度歌单底部弹出数据
  List modalList = [
    {
      "name": "Wifi下自动下载歌曲",
      "description": "下载会员歌曲将占用当月付费下载额度",
      "icon": Icons.arrow_circle_down,
      "isSwitch": false,
      "switchChange": (bool val) {
        print('11111111111,$val');
      },
    },
    {
      "name": "添加歌曲",
      "icon": Icons.add_circle,
    },
    {
      "name": "编辑歌单信息",
      "icon": Icons.edit_note,
    },
    {
      "name": "更改歌曲排序",
      "icon": Icons.change_circle,
    },
    {"name": "清空下载文件", "icon": Icons.delete, "mark": 'empty'},
    {
      "name": "删除歌单",
      "icon": Icons.delete_sweep,
    },
    {
      "name": "恢复歌单",
      "icon": Icons.history,
    },
  ];

  // 其他歌单底部弹出数据
  List otherModalList = [
    {
      "name": "选择歌曲排序",
      "icon": Icons.change_circle,
    },
    {"name": "清空下载文件", "icon": Icons.delete, "mark": 'empty'},
    {
      "name": "举报",
      "icon": Icons.warning,
    },
  ];
}
