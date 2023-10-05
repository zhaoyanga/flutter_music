import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/public_request.dart';
import 'app_config.dart';

class AppConfigBloc extends Cubit<AppConfig> {
  AppConfigBloc({required AppConfig appConfig}) : super(appConfig);

  // 控制是否播放
  void switchPlay(bool isPlaying) {
    if (isPlaying != state.isPlaying) {
      emit(state.copyWith(isPlay: isPlaying));
    }
  }

  // 保存播放歌曲对象
  void switchMusicData(List musicData) {
    emit(state.copyWith(musicData: musicData, isPlayStatus: true));
  }

  // 设置当前播放音乐Url
  void switchMusicUrl(int index, int id) async {
    if (state.playMusicData[index]['url'] != '') return;
    List musicData = List.from(state.playMusicData);
    for (int i = 0; i < musicData.length; i++) {
      if (i == index) {
        String url = await getMusicUrl(id);
        musicData[index]['url'] = url;
      }
    }
    emit(state.copyWith(musicData: musicData));
  }

  // 控制播放栏显示隐藏
  void switchPlayStatus(
    bool playStatus,
  ) {
    if (playStatus != state.playStatus) {
      emit(state.copyWith(isPlayStatus: playStatus));
    }
  }

  // 保存用户信息
  void switchAccountInfo(Map accountInfo) {
    Map test = Map.from(accountInfo);
    if (!mapEquals(test, state.accountInfo)) {
      emit(state.copyWith(accountsInfo: test));
    }
  }

  // 修改当前播放下标
  void switchPlayIndex(int index) {
    emit(state.copyWith(index: index));
  }
}
