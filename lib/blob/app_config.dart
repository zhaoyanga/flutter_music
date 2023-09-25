import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AppConfig {
  // 通过 Scaffoldkey 打开侧边栏
  final GlobalKey<ScaffoldState> scaffoldkey;
  // 用户信息
  final Map accountInfo;
  // 播放栏状态
  final bool isPlaying;
  // 播放器
  final AudioPlayer player;
  // 播放模式
  final int playMode = 1;
  // 播放歌曲列表
  final List playMusicData;
  // 是否需要显示播放栏
  final bool playStatus;
  // 当前播放的哪首下标
  final int playIndex;

  AppConfig({
    required this.scaffoldkey,
    required this.accountInfo,
    required this.isPlaying,
    required this.player,
    required this.playStatus,
    required this.playMusicData,
    required this.playIndex,
    int? playMode,
  });

  // 命名构造函数+初始化列表
  AppConfig.defaultScaffoldkey({int index = 0})
      : scaffoldkey = GlobalKey<ScaffoldState>(),
        accountInfo = {},
        isPlaying = false,
        player = AudioPlayer(playerId: 'playId'),
        playStatus = false,
        playMusicData = [
          {
            'id': 1300287,
            'name': "Stan",
            'imgUrl':
                'https://p2.music.126.net/IByr4hGzBvcM5pn2R7-Tyw==/19196373509550751.jpg',
            'url': '',
          },
          {
            'id': 1869271,
            'name': "We Will Rock You",
            'imgUrl':
                'https://p2.music.126.net/dMcDWqZnkWeKd-5BZGHosg==/109951165300702419.jpg',
            'url': '',
          }
        ],
        playIndex = index;

  AppConfig copyWith({
    bool? isPlay,
    GlobalKey<ScaffoldState>? scaffoldkey,
    Map? accountsInfo,
    AudioPlayer? players,
    int? playModes,
    List? musicData,
    bool? isPlayStatus,
    index,
  }) {
    return AppConfig(
        isPlaying: isPlay ?? isPlaying,
        scaffoldkey: scaffoldkey ?? this.scaffoldkey,
        accountInfo: accountsInfo ?? accountInfo,
        player: players ?? player,
        playMode: playModes ?? playMode,
        playMusicData: musicData ?? playMusicData,
        playStatus: isPlayStatus ?? playStatus,
        playIndex: index ?? playIndex);
  }
}
