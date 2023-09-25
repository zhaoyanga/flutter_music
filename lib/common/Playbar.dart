import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../blob/app_config.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/playBarControllers.dart';
import 'Adapt.dart';

class PlayBar extends StatefulWidget {
  const PlayBar({super.key, required this.states, this.isNoCachePage = false});
  final AppConfig states;
  final bool isNoCachePage;
  @override
  State<PlayBar> createState() => _PlayBarState();
}

class _PlayBarState extends State<PlayBar> {
  // 是否需要重置动画
  bool isReset = false;
  // 当前播放的对象
  Map playObj = {};
  // 播放下标
  int index = 0;
  @override
  void initState() {
    setState(() {
      index = widget.states.playIndex;
    });
    // 暂停播放时触发
    widget.states.player.onPlayerStateChanged.listen((state) {
      // 处理不同的状态
    });
    // 播放完毕
    widget.states.player.onPlayerComplete.listen((event) async {
      widget.states.player.pause();
      playbackMode(widget.states.playMode);
      BlocProvider.of<AppConfigBloc>(context).switchPlay(false);
      Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      BlocProvider.of<AppConfigBloc>(context).switchPlay(true);
      widget.states.player.resume();
      // int id = widget.states.playMusicData[index]['id'];
      // String url = await getMusicUrl(id);
      // widget.states.player.setSource(UrlSource(url));
      // widget.states.player.resume();
      // if (!mounted) return;
      // BlocProvider.of<AppConfigBloc>(context).switchPlay(true);
    });
    super.initState();
  }

  // 播放模式
  void playbackMode(mode) {
    switch (mode) {
      case 1:
        if (index == (widget.states.playMusicData.length - 1)) {
          index = 0;
          setState(() {});
        } else {
          index++;
          setState(() {});
        }
        BlocProvider.of<AppConfigBloc>(context).switchPlayIndex(index);
        break;
      case 2:
        BlocProvider.of<AppConfigBloc>(context)
            .switchPlayIndex(randomGen(0, widget.states.playMusicData.length));
        break;
    }
    setState(() {});
  }

  randomGen(min, max) {
    // nextDouble() 方法返回一个介于 0（包括）和 1（不包括）之间的随机数
    var x = Random().nextDouble() * (max - min) + min;

    // 如果您不想返回整数，只需删除 floor() 方法
    return x.floor();
  }

  switchMusic() {
    int id = widget.states.playMusicData[index]['id'];
    BlocProvider.of<AppConfigBloc>(context).switchMusicUrl(index, id);
    widget.states.player
        .setSource(UrlSource(widget.states.playMusicData[index]['url']));
    // BlocProvider.of<AppConfigBloc>(context).switchPlay(true);
    // widget.states.player.resume();
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    setState(() {
      index = widget.states.playIndex;
    });
    if (!widget.isNoCachePage &&
        widget.states.playStatus &&
        widget.states.playMusicData.isNotEmpty) {
      if (widget.states.playMusicData[index]['url'] != '') {
        widget.states.player
            .setSource(UrlSource(widget.states.playMusicData[index]['url']));
        // BlocProvider.of<AppConfigBloc>(context).switchPlay(true);
        // widget.states.player.resume();
      } else {
        switchMusic();
      }

      if (widget.states.isPlaying) {
        widget.states.player.resume();
      }
    }
    return widget.states.playStatus
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            width: MediaQuery.of(context).size.width,
            height: Adapt.pt(48),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // 阴影的颜色
                  offset: const Offset(0, 20), // 阴影与容器的距离
                  blurRadius: Adapt.pt(20), // 高斯的标准偏差与盒子的形状卷积。
                  spreadRadius: 0.0, // 在应用模糊之前，框应该膨胀的量。
                ),
              ],
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  // flex: 3,
                  child: Row(
                    children: [
                      PlayBarController(
                        imgUrl: widget.states
                            .playMusicData[widget.states.playIndex]['imgUrl'],
                      ),
                      SizedBox(width: Adapt.pt(8)),
                      Expanded(
                        child: Text(
                          widget.states.playMusicData[widget.states.playIndex]
                              ['name'],
                          style: TextStyle(
                            fontSize: Adapt.pt(12),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            playbackMode(widget.states.playMode);
                            BlocProvider.of<AppConfigBloc>(context)
                                .switchPlay(false);
                            Future.delayed(const Duration(milliseconds: 300));
                            switchMusic();
                            BlocProvider.of<AppConfigBloc>(context)
                                .switchPlay(true);
                            widget.states.player.resume();
                          },
                          child: const Text("下一首")),
                      Padding(
                        padding: EdgeInsets.only(left: Adapt.pt(12)),
                        child: InkWell(
                          onTap: () {
                            if (widget.states.isPlaying) {
                              widget.states.player.pause();
                            } else {
                              widget.states.player.resume();
                            }
                            var copy = widget.states.isPlaying ? false : true;
                            BlocProvider.of<AppConfigBloc>(context)
                                .switchPlay(copy);
                          },
                          child: Container(
                            width: Adapt.pt(24),
                            height: Adapt.pt(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Adapt.pt(50)),
                              border: const Border.fromBorderSide(
                                BorderSide(width: 1, color: Color(0xFFcccccc)),
                              ),
                            ),
                            child: Icon(
                              widget.states.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: Adapt.pt(16),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.reorder,
                        size: Adapt.pt(24),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        : Container();
  }
}
