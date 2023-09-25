import 'package:flutter/material.dart';
import '../common/Adapt.dart';

class UserToolBar extends StatefulWidget {
  const UserToolBar({super.key});

  @override
  State<UserToolBar> createState() => _UserToolBarState();
}

class _UserToolBarState extends State<UserToolBar> {
  List<Map> toolBars = [
    {"icon": Icons.play_circle_filled, "text": "最近播放"},
    {"icon": Icons.library_music, "text": "本地下载"},
    {"icon": Icons.backup, "text": "云盘"},
    {"icon": Icons.local_mall, "text": "已购"},
  ];
  List<Map> toolBars1 = [
    {"icon": Icons.people_alt, "text": "我的好友"},
    {"icon": Icons.star, "text": "收藏和赞"},
    {"icon": Icons.podcasts, "text": "我的播客"},
    {"icon": Icons.interests, "text": "乐迷团"},
  ];

  bool addBar = false;

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Container(
      width: MediaQuery.of(context).size.width,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Adapt.pt(24), horizontal: Adapt.pt(24)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: toolBars.asMap().keys.map(buildItem).toList(),
                ),
                SizedBox(height: Adapt.pt(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: toolBars1.asMap().keys.map(buildItem1).toList(),
                )
              ],
            ),
          ),
          const Divider(
            height: 2,
            color: Color(
              0xffaeaeae,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Adapt.pt(6), horizontal: Adapt.pt(12)),
            child: Row(
              mainAxisAlignment: addBar
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: addBar
                  ? [
                      InkWell(
                        onTap: () {
                          setState(() {
                            addBar = false;
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.add,
                              size: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Text(
                                "音乐应用",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                  : [
                      Row(
                        children: [
                          Container(
                            width: Adapt.pt(24),
                            height: Adapt.pt(24),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://img1.baidu.com/it/u=3573056321,2239143646&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1692550800&t=95909218443a3c3fe4063928b3ceee50'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: Adapt.pt(6)),
                          Text(
                            "Ta和你绝配",
                            style: TextStyle(
                              fontSize: Adapt.pt(12),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: Adapt.pt(0.5),
                                horizontal: Adapt.pt(8)),
                            child: Text(
                              "·Live",
                              style: TextStyle(
                                fontSize: Adapt.pt(8),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: Adapt.pt(12)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                addBar = true;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: const Color(0xffcccccc),
                              size: Adapt.pt(18),
                            ),
                          ),
                        ],
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 0,
            left: Adapt.pt(18),
            right: Adapt.pt(18),
            bottom: 0,
          ),
          child: Icon(
            toolBars[index]['icon'],
            color: Colors.red,
          ),
        ),
        Text(
          toolBars[index]['text'],
          style: TextStyle(fontSize: Adapt.pt(12), fontWeight: FontWeight.w400),
        )
      ],
    );
  }

  Widget buildItem1(int index) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 0,
            left: Adapt.pt(18),
            right: Adapt.pt(18),
            bottom: 0,
          ),
          child: Icon(
            toolBars1[index]['icon'],
            color: Colors.red,
          ),
        ),
        Text(
          toolBars1[index]['text'],
          style: TextStyle(fontSize: Adapt.pt(12), fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
