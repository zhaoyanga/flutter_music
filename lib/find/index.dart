import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../common/Adapt.dart';
import '../common/Playbar.dart';
import '../common/SimpleEasyRefresher.dart';
import 'banner.dart';
import 'dragonBall.dart';
import 'dailyRecommendations.dart';
import '../blob/app_config.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});
  @override
  State<FindPage> createState() => _FindPage();
}

class _FindPage extends State<FindPage> {
  // 上拉刷新下拉加载控制器
  final EasyRefreshController _controller = EasyRefreshController();

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

  List urlList = [];

  // List urlList = [];
  // 音乐列表在外面，playBar只需要对象。由外面控制播放哪首

  getMusicList() async {
    BlocProvider.of<AppConfigBloc>(context).switchPlayStatus(true);
  }

  String urlConversion(String path) {
    if (path.startsWith('https')) return path;
    String newStr = path.replaceAll("http", "https");
    return newStr;
  }

  @override
  void initState() {
    getMusicList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppConfigBloc blob = BlocProvider.of<AppConfigBloc>(context);
    Adapt.initialize(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("发现"),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: Adapt.pt(18)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            blob.state.scaffoldkey.currentState?.openDrawer();
          },
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: const [],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SimpleEasyRefresher(
            easyRefreshController: _controller,
            onRefresh: _refresh,
            onLoad: _loadMore,
            childBuilder: (context, physics) {
              return Container(
                margin: const EdgeInsets.all(12),
                child: ListView(
                  physics: physics,
                  children: [
                    const Banners(),
                    SizedBox(height: Adapt.pt(12)),
                    const DragonBall(),
                    SizedBox(height: Adapt.pt(6)),
                    const DailRecommenDations(),
                  ],
                ),
              );
            },
          ),
          BlocBuilder<AppConfigBloc, AppConfig>(builder: (_, state) {
            return PlayBar(states: state);
          })
        ],
      ),
    );
  }
}
