import 'package:daoniao_music/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../utils/public_request.dart';
import '../Adapt.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import '../ColorUtils.dart';
import '../Header.dart';
import '../LoadStateLayout.dart';
import '../MyButton.dart';
import '../Playbar.dart';
import '../Totas.dart';
import 'all_mask.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../SimpleEasyRefresher.dart';
import '../../blob/app_config.dart';
import '../../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SongSheetPage extends StatefulWidget {
  const SongSheetPage({
    super.key,
    required this.states,
    required this.isNoCachePage,
    required this.songSheetInfo,
  });
  final AppConfig states;
  final bool isNoCachePage;
  final Map songSheetInfo;
  @override
  State<SongSheetPage> createState() => _SongSheetPageState();
}

class _SongSheetPageState extends State<SongSheetPage> {
  // 是否切换标题
  bool headerWhite = false;
  // 歌单详情
  final Map _playListInfo = {
    'coverImgUrl':
        'http://p1.music.126.net/fWQ5EX9BDCvuaKqtZoYs3A==/109951165425855499.jpg'
  };

  /*
    歌曲分页
    传入limit=50&offset=0你会得到第1-50首歌曲
    传入limit=50&offset=50，你会得到第51-100首歌曲
  */
  Map pageQuery = {
    'limit': 9,
    'offset': 0,
  };
  // 歌单歌曲
  final List _playList = [];
  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.loading;

  // 上拉刷新下拉加载控制器
  final EasyRefreshController _controller = EasyRefreshController();
  // 是否没数据了
  bool isRefresh = false;

  // 滚动控制器
  late final ScrollController _scrollController;

  Future<void> _loadMore() async {
    // 模拟加载更多操作
    await Future.delayed(const Duration(milliseconds: 300));
    pageQuery['offset'] += 9;
    setState(() {});
    getPlaylistTrack();
    _controller.finishLoad(IndicatorResult.success, true);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    getDetail();
    getPlaylistTrack();
    super.initState();
  }

  static String breakWord(String word) {
    if (word.isEmpty) {
      return word;
    }
    String breakWord = ' ';
    for (var element in word.runes) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    }
    return breakWord;
  }

  // 获取歌单详情
  void getDetail() {
    Http.get('getPlaylistDynamic', params: {'id': 798027839}).then((res) {
      if (res['code'] != 200) return;
      // 评论
      _playListInfo['commentCount'] = res['commentCount'];
      // 播放次数
      _playListInfo['playCount'] = res['playCount'];
      // 分享次数
      _playListInfo['shareCount'] = res['shareCount'];
      setState(() {});
    });
  }

  bool aaa = true;

  void getPlaylistTrack() {
    pageQuery['id'] = widget.songSheetInfo['id'];
    Http.get('getPlaylistTrack', params: pageQuery).then((res) {
      Future.delayed(const Duration(milliseconds: 1000));
      if (res is Map && res['code'] == 200) {
        if (_playList.isNotEmpty && res['songs'].isEmpty) {
          return;
        }
        if (res['songs'].isEmpty) {
          _layoutState = LoadState.empty;
        } else {
          if (widget.songSheetInfo['trackCount'] <=
              (pageQuery['offset'] + pageQuery['limit'])) {
            isRefresh = true;
          }
          _playList.addAll(res['songs']);
          _layoutState = LoadState.success;
        }
        setState(() {});
        /* 
          如果请求的歌曲和总歌曲一样，则不滚动
        
          如果下面还有歌曲，就让滚动到最下面
         */
        if ((pageQuery['offset'] + pageQuery['limit']) <
            widget.songSheetInfo['trackCount']) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeOut,
            );
          });
        }
        return;
      }
      Toast.show(context: context, message: breakWord(res.toString()));
      _layoutState = LoadState.error;
      setState(() {});
    });
  }

  Widget buildMusicList() {
    return SimpleEasyRefresher(
      easyRefreshController: _controller,
      onLoad: isRefresh ? null : _loadMore,
      childBuilder: (context, physics) {
        return ListView(
          controller: _scrollController,
          itemExtent: 50.0 + 10 * 2,
          physics: physics,
          children: _playList.asMap().keys.map(musicItem).toList(),
        );
      },
    );
  }

  Widget musicItem(int index) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Adapt.pt(12), horizontal: Adapt.pt(12)),
      child: Row(
        children: [
          Text("${index + 1}"),
          SizedBox(width: Adapt.pt(12)),
          Container(
            width: Adapt.pt(42),
            height: Adapt.pt(42),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(_playList[index]['al']['picUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: Adapt.pt(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  breakWord(_playList[index]['name']),
                  style: TextStyle(
                      fontSize: Adapt.pt(16), fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    // const Text("数字专辑"),
                    Expanded(
                      child: Text(
                          breakWord(_playList[index]['ar'][0]['name'] +
                              '-' +
                              _playList[index]['al']['name']),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: Adapt.pt(12))),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              _playList[index]['mv'] > 0
                  ? const Icon(Icons.play_arrow, color: Color(0xffb4b4b4))
                  : Container(),
              const Icon(Icons.more_vert, color: Color(0xffb4b4b4)),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    final barHeight = MediaQueryData.fromWindow(window).padding.top; // 获取状态栏高度
    final size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: widget.states.playStatus
            ? BlocBuilder<AppConfigBloc, AppConfig>(
                builder: (_, state) => PlayBar(
                  states: state,
                  isNoCachePage: widget.isNoCachePage,
                ),
              )
            : null,
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.width / 1.4,
                  child: Image.network(
                    "http://p1.music.126.net/fWQ5EX9BDCvuaKqtZoYs3A==/109951165425855499.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Mask(),
                Positioned(
                  top: barHeight,
                  child: HeaderWidget(
                    back: Icons.arrow_back_ios_outlined,
                    content: Text(
                      '歌单',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Adapt.pt(18),
                      ),
                    ),
                    rightWidget: buildRightIcon(),
                  ),
                ),
                Positioned(
                  top: barHeight + 60,
                  height: size.width / 1.4 - 60 - barHeight,
                  width: size.width,
                  // child: _playListInfo['playCount'] == null
                  // child: const DayInfo()
                  // : ListInfo(info: _playListInfo),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: Adapt.pt(12), right: Adapt.pt(12)),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: Adapt.pt(106),
                                  height: Adapt.pt(106),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Adapt.pt(12)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.songSheetInfo['coverImgUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                _playListInfo['playCount'] != 0 &&
                                        _playListInfo['playCount'] != null
                                    ? Positioned(
                                        right: Adapt.pt(6),
                                        top: Adapt.pt(6),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.play_arrow,
                                              size: Adapt.pt(14),
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "${_playListInfo['playCount']}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: Adapt.pt(6), left: Adapt.pt(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "我喜欢的音乐",
                                      style: TextStyle(
                                        fontSize: Adapt.pt(14),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: Adapt.pt(6)),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            print('gogogo');
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: Adapt.pt(2)),
                                                child: Container(
                                                  width: Adapt.pt(24),
                                                  height: Adapt.pt(24),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          widget.songSheetInfo[
                                                                  'creator']
                                                              ['avatarUrl']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: Adapt.pt(6)),
                                              Text(
                                                "${widget.songSheetInfo['creator']['nickname']}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xffe1d8d9),
                                                  fontSize: Adapt.pt(12),
                                                ),
                                              ),
                                              SizedBox(width: Adapt.pt(4)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: Adapt.pt(1)),
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xffe1d8d9),
                                                  size: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Adapt.pt(24)),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: MyButton(
                                fn: _onShare,
                                icon: Icons.reply,
                                text:
                                    "${_playListInfo['shareCount'] != 0 && _playListInfo['shareCount'] != null ? _playListInfo['shareCount'] : '分享'}",
                                style: buttonStyle,
                              ),
                            ),
                            SizedBox(width: Adapt.pt(12)),
                            Expanded(
                              flex: 1,
                              child: MyButton(
                                fn: (context) {},
                                icon: Icons.textsms,
                                text:
                                    "${_playListInfo['commentCount'] != 0 && _playListInfo['commentCount'] != null ? _playListInfo['commentCount'] : '评论'}",
                                style: buttonStyle,
                              ),
                            ),
                            SizedBox(width: Adapt.pt(12)),
                            Expanded(
                              flex: 1,
                              child: MyButton(
                                fn: (context) {},
                                icon: Icons.library_add_check,
                                text: "收藏",
                                style: buttonStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Adapt.pt(12), horizontal: Adapt.pt(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        List musicData = [];
                        // String url = await getMusicUrl(_playList[1]['id']);
                        for (int i = 0; i < _playList.length; i++) {
                          String url = await getMusicUrl(_playList[i]['id']);
                          musicData.add({
                            'id': _playList[i]['id'],
                            'imgUrl': _playList[i]['al']['picUrl'],
                            "url": url,
                            // "url": i == 1 ? url : '',
                            "name": _playList[i]['name'],
                          });
                        }
                        if (!mounted) return;
                        BlocProvider.of<AppConfigBloc>(context)
                            .switchPlayIndex(1);
                        BlocProvider.of<AppConfigBloc>(context)
                            .switchMusicData(musicData);
                        BlocProvider.of<AppConfigBloc>(context)
                            .switchPlay(true);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: Adapt.pt(24),
                            height: Adapt.pt(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Adapt.pt(50)),
                              color: Colors.red,
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              size: Adapt.pt(16),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: Adapt.pt(12)),
                          Text("播放全部",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Adapt.pt(16))),
                          SizedBox(width: Adapt.pt(6)),
                          Text("${widget.songSheetInfo['trackCount']}",
                              style: TextStyle(fontSize: Adapt.pt(10))),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.audiotrack),
                        SizedBox(width: Adapt.pt(12)),
                        const Icon(Icons.downloading),
                        SizedBox(width: Adapt.pt(12)),
                        const Icon(Icons.more_vert),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              height: 2.0,
              color: Colors.black,
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: LoadStateLayout(
                  state: _layoutState,
                  errorRetry: () {
                    setState(() {
                      _layoutState = LoadState.loading;
                    });
                    getPlaylistTrack();
                  }, //错误按钮点击过后进行重新加载
                  successWidget: buildMusicList(),
                ),
              ),
            ),
          ],
        ));
  }

  final buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Adapt.pt(50)),
      ),
    ),
    backgroundColor: MaterialStatePropertyAll(
      ColorUtils.getRandomColor(false),
    ),
    overlayColor: MaterialStatePropertyAll(
      ColorUtils.getRandomColor(false),
    ),
    foregroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.focused) &&
            !states.contains(MaterialState.pressed)) {
          //获取焦点时的颜色
          return Colors.white.withOpacity(0.8);
        } else if (states.contains(MaterialState.pressed)) {
          //按下时的颜色
          return Colors.white.withOpacity(0.8);
        }
        //默认状态使用灰色
        return Colors.white;
      },
    ),
  );

  Widget buildRightIcon() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  void _onShare(BuildContext context) async {
    Share.share('check out my website https://example.com',
        subject: 'Look what I made!');
  }
}
