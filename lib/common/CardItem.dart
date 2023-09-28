import 'package:flutter/material.dart';
import './Adapt.dart';
import './SongSheet/SongSheet.dart';
import '../blob/app_config.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardItemMode extends StatefulWidget {
  const CardItemMode(
      {super.key, required this.songSheetInfo, this.isHeartRate = false});
  final Map songSheetInfo;
  final bool isHeartRate;
  @override
  State<CardItemMode> createState() => _CardItemMode();
}

class _CardItemMode extends State<CardItemMode> {
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return widget.songSheetInfo.isNotEmpty
        ? Container(
            decoration: widget.isHeartRate
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Adapt.pt(12)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: Adapt.pt(10), //阴影范围
                        spreadRadius: 0.1, //阴影浓度
                        color: Colors.grey.withOpacity(0.2), //阴影颜色
                      ),
                    ],
                  )
                : const BoxDecoration(),
            padding: EdgeInsets.symmetric(
                vertical: Adapt.pt(12), horizontal: Adapt.pt(12)),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocBuilder<AppConfigBloc, AppConfig>(
                      builder: (_, state) => SongSheetPage(
                          states: state,
                          isNoCachePage: true,
                          songSheetInfo: widget.songSheetInfo),
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
                          border: Border.all(
                            width: 0.3,
                            color: const Color(0xffff7f7f7f),
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
                          Text(
                              widget.songSheetInfo.isNotEmpty
                                  ? replaceName(widget.songSheetInfo['name'])
                                  : '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                widget.songSheetInfo.isNotEmpty
                                    ? "${widget.songSheetInfo['trackCount']}首"
                                    : '0首',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff8c8e8e)),
                              ),
                              Text(
                                widget.songSheetInfo.isNotEmpty &&
                                        !widget.songSheetInfo['name']
                                            .startsWith('火火鲨')
                                    ? "，by ${widget.songSheetInfo['creator']['nickname']}"
                                    : '',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff8c8e8e)),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  widget.isHeartRate
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: const Color(0xffcccccc),
                            ),
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 6),
                          child: const Row(
                            children: [
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
                      : Container()
                ],
              ),
            ),
          )
        : Container();
  }

  String replaceName(String name) {
    if (!name.endsWith('喜欢的音乐')) return name;
    String newStr = name.replaceAll("火火鲨", "我");
    return newStr;
  }
}
