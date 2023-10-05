import 'dart:ui';
import 'package:daoniao_music/common/Assets_Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/Adapt.dart';
import '../utils/request.dart';
import 'LoadStateLayout.dart';

class CommentModalBottomSheet {
  static void showBottomModal(BuildContext context,
      {required Function fn,
      required Map songSheetInfo,
      required int commentCount}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Adapt.pt(18)),
              topRight: Radius.circular(Adapt.pt(18)))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SizedBox(
          height: MediaQuery.of(context).size.height - 60,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "评论($commentCount)",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Adapt.pt(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: Adapt.pt(12), bottom: Adapt.pt(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: Adapt.pt(72),
                            height: Adapt.pt(72),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Adapt.pt(6)),
                              image: DecorationImage(
                                image:
                                    NetworkImage(songSheetInfo['coverImgUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: Adapt.pt(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Adapt.pt(3),
                                      ),
                                      margin: EdgeInsets.only(top: Adapt.pt(4)),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.red),
                                        borderRadius: BorderRadius.circular(
                                          Adapt.pt(3),
                                        ),
                                      ),
                                      child: Text(
                                        "歌单",
                                        style: TextStyle(
                                          fontSize: Adapt.pt(8),
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    songSheetInfo['name'].startsWith("【")
                                        ? Container()
                                        : SizedBox(width: Adapt.pt(6)),
                                    Expanded(
                                      child: Text(
                                        songSheetInfo['name'],
                                        style: TextStyle(
                                          fontSize: Adapt.pt(14),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Adapt.pt(6)),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontSize: Adapt.pt(12),
                                    ),
                                    children: [
                                      const TextSpan(text: "by "),
                                      TextSpan(
                                        text: songSheetInfo['creator']
                                            ['nickname'],
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              Container(
                height: Adapt.pt(6),
                width: double.infinity,
                color: const Color(
                  0xffcccccc,
                ),
              ),
              Expanded(
                child: CommentList(
                    songSheetInfo:
                        songSheetInfo.isNotEmpty ? songSheetInfo : {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  const CommentList({super.key, required this.songSheetInfo});
  final Map songSheetInfo;
  @override
  State<CommentList> createState() => _CommentListState();
}

// 选项
List options = [
  {'name': "推荐", 'isActive': true},
  {'name': "最新", 'isActive': false},
  {'name': "最热", 'isActive': false},
];

class _CommentListState extends State<CommentList> {
  final ScrollController _scrollController = ScrollController();
  // 是否可以滚动
  bool isScroll = true;
  // 点击的选项
  int sortType = 1;
  // 评论列表
  List commentList = [];
  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.loading;

  // 获取歌单评论
  void getSongComment() async {
    // setState(() {
    _layoutState = LoadState.loading;
    // });
    Http.post('getSongComment', pathParams: {
      'type': 2,
      'id': widget.songSheetInfo['id'],
      'sortType': sortType,
    }, params: {}).then((res) {
      Future.delayed(const Duration(milliseconds: 1000));
      if (res['code'] != 200) return;
      Map result = res['data'];
      if (result.isEmpty) {
        _layoutState = LoadState.empty;
      } else {
        commentList = result['comments'];
        _layoutState = LoadState.success;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      int offset = _scrollController.position.pixels.toInt();
      if (offset <= 0) {
        isScroll = false;
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else {
        isScroll = true;
      }
      setState(() {});
    });
    getSongComment();
    super.initState();
  }

  Widget _buildOptionItem(int index) {
    return InkWell(
      onTap: () {
        for (int i = 0; i < options.length; i++) {
          if (i == index) {
            options[index]['isActive'] = true;
            sortType = index + 1;
            getSongComment();
          } else {
            options[i]['isActive'] = false;
          }
        }
        setState(() {});
      },
      child: Text(
        options[index]['name'],
        style: TextStyle(
          color: options[index]['isActive']
              ? Colors.black
              : const Color(0xffa6a6a6),
          fontWeight:
              options[index]['isActive'] ? FontWeight.bold : FontWeight.w100,
        ),
      ),
    );
  }

  //手指移动的位置
  double _lastMoveY = 0.0;
  //手指按下的位置
  double _downY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        //手指按下的距离
        _downY = event.position.distance;
      },
      onPointerMove: (PointerMoveEvent event) {
        //手指移动的距离
        var position = event.position.distance;
        //判断距离差
        var detal = position - _lastMoveY;
        if (detal > 0) {
          //手指移动的距离
          double pos = (position - _downY);
          isScroll = true;
          setState(() {});
          // print("================向下移动================");
        }
        _lastMoveY = position;
      },
      child: LoadStateLayout(
        state: _layoutState,
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.loading;
          });
          getSongComment();
        }, //错误按钮点击过后进行重新加载
        successWidget: _buildCommentList(),
      ),
    );
  }

  Widget _buildCommentList() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: Adapt.pt(6), horizontal: Adapt.pt(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "评论区",
                style: TextStyle(
                  fontSize: Adapt.pt(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < options.length; i++)
                    Row(
                      children: [
                        _buildOptionItem(i),
                        SizedBox(width: Adapt.pt(6)),
                        i == 2
                            ? Container()
                            : Row(
                                children: [
                                  const Text("|"),
                                  SizedBox(width: Adapt.pt(6)),
                                ],
                              ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: commentList.length,
            physics: isScroll
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(
                    vertical: Adapt.pt(6), horizontal: Adapt.pt(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: Adapt.pt(36),
                              height: Adapt.pt(36),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      commentList[index]['user']['avatarUrl']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: Adapt.pt(12)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(commentList[index]['user']['nickname']),
                                SizedBox(height: Adapt.pt(3)),
                                Text(
                                  "${commentList[index]['timeStr']} ${commentList[index]['ipLocation']['location']}",
                                  style: TextStyle(
                                    fontSize: Adapt.pt(8),
                                    color: const Color(0xffa6a6a6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: Adapt.pt(48)),
                        Expanded(
                          child: Text(
                            commentList[index]['content'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Adapt.pt(12)),
                    index != commentList.length - 1
                        ? Row(
                            children: [
                              SizedBox(width: Adapt.pt(48)),
                              Expanded(
                                child: Container(
                                  height: Adapt.pt(1),
                                  color: const Color(
                                    0xffcccccc,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
