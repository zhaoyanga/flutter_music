import 'package:flutter/material.dart';
import '../common/Adapt.dart';
import '../common/SongSheet/SongSheet.dart';
import '../blob/app_config.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserILikeIt extends StatefulWidget {
  const UserILikeIt({super.key, required this.songSheetInfo});
  final Map songSheetInfo;
  @override
  State<UserILikeIt> createState() => _UserILikeItState();
}

class _UserILikeItState extends State<UserILikeIt> {
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return widget.songSheetInfo.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Adapt.pt(12)),
              boxShadow: [
                BoxShadow(
                  blurRadius: Adapt.pt(10), //阴影范围
                  spreadRadius: 0.1, //阴影浓度
                  color: Colors.grey.withOpacity(0.2), //阴影颜色
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
                vertical: Adapt.pt(12), horizontal: Adapt.pt(12)),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocBuilder<AppConfigBloc, AppConfig>(
                      builder: (_, state) =>
                          SongSheetPage(states: state, isNoCachePage: true, songSheetInfo : widget.songSheetInfo),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: Adapt.pt(48),
                        height: Adapt.pt(48),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Adapt.pt(12)),
                          image: DecorationImage(
                            image: NetworkImage(widget.songSheetInfo.isNotEmpty
                                ? widget.songSheetInfo['coverImgUrl']
                                : ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // 蒙版爱心
                        // child: Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.black.withOpacity(0.4),
                        //     borderRadius: BorderRadius.circular(Adapt.pt(12)),
                        //   ),
                        //   child: const Icon(
                        //     Icons.favorite,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("我喜欢的音乐",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            widget.songSheetInfo.isNotEmpty
                                ? "${widget.songSheetInfo['trackCount']}首"
                                : '0首',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xffcccccc)),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: const Color(0xffcccccc),
                      ),
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.heart_broken,
                          size: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Text(
                            "心动模式",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
