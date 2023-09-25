import 'dart:convert';
import 'package:flutter/material.dart';
import '../blob/app_config.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/Adapt.dart';
import '../common/Playbar.dart';
import '../common/SimpleEasyRefresher.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../sharedPreferences/index.dart';
import '../utils/request.dart';
import 'userILikeIt.dart';
import 'userPresentation.dart';
import 'userToolbar.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  // 上拉刷新下拉加载控制器
  final EasyRefreshController _controller = EasyRefreshController();
  // 我的歌单信息
  List songSheetInfo = [];

  Future<void> _refresh() async {
    // 模拟刷新操作
    await Future.delayed(const Duration(seconds: 2));
    _controller.finishRefresh(IndicatorResult.success, true);
  }

  Future<void> _loadMore() async {
    // 模拟加载更多操作
    await Future.delayed(const Duration(seconds: 2));
    // setState(() {
    //   _dataList.addAll(List.generate(10, (index) => 'Item ${_dataList.length + index + 1}'));
    // });
    _controller.finishLoad(IndicatorResult.success, true);
  }

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                SimpleEasyRefresher(
                  easyRefreshController: _controller,
                  onRefresh: _refresh,
                  onLoad: _loadMore,
                  childBuilder: (context, physics) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Adapt.pt(18)),
                      child: ListView(
                        physics: physics,
                        children: [
                          Column(
                            children: [
                              UserPresentation(
                                  accountInfo: blob.state.accountInfo),
                              SizedBox(height: Adapt.pt(24)),
                              const UserToolBar(),
                              SizedBox(height: Adapt.pt(12)),
                              UserILikeIt(
                                songSheetInfo: songSheetInfo.isNotEmpty
                                    ? songSheetInfo[0]
                                    : {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<AppConfigBloc, AppConfig>(
                  builder: (_, state) => PlayBar(states: state),
                ),
              ],
            ),
          )
        : Container();
  }
}
