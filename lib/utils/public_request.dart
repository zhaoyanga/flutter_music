import 'package:flutter/material.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'request.dart';

// 获取音乐Url，传入播放对象
// getMusicList(BuildContext context, int id, Map musicDetail) async {
//   Http.get('getMusicList', params: {'id': id}).then((res) {
//     List result = res['data'];
//     Map musicData = {
//       'id': id,
//       'imgUrl': musicDetail['imgUrl'],
//       "url": urlConversion(result[0]['url']),
//       "name": musicDetail['name'],
//     };
//     BlocProvider.of<AppConfigBloc>(context).switchMusicData([musicData]);
//     BlocProvider.of<AppConfigBloc>(context).switchPlay(true);
//   });
// }

// 获取音乐Url，传入id
Future<String> getMusicUrl(int id) async {
  Map result = await Http.get('getMusicList',
      params: {'id': id});
  return result['data'][0]['url'] != null ? urlConversion(result['data'][0]['url']) : '';
}

String urlConversion(String path) {
  if (path.startsWith('https')) return path;
  String newStr = path.replaceAll("http", "https");
  return newStr;
}
