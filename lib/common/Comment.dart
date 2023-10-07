import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blob/app_config.dart';
import '../blob/app_config_blob.dart';
import '../utils/public_request.dart';
import 'Assets_Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/Adapt.dart';
import '../utils/request.dart';
import 'HiddenText.dart';
import 'Lickbutton/index.dart';
import 'LoadStateLayout.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'SimpleEasyRefresher.dart';
import 'SongSheet/SongSheet.dart';

class CommentModalBottomSheet {
  static void showBottomModal(
    BuildContext context, {
    required Function fn,
    required Map songSheetInfo,
    required int commentCount,
    required int type,
    required String title,
    required List modalList,
    int? id,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
                  "$title($commentCount)",
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
                child: title == '评论'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: Adapt.pt(72),
                                  height: Adapt.pt(72),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Adapt.pt(6)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          songSheetInfo['coverImgUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: Adapt.pt(12)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Adapt.pt(3),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: Adapt.pt(4)),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocBuilder<AppConfigBloc, AppConfig>(
                                    builder: (_, state) => SongSheetPage(
                                      states: state,
                                      isNoCachePage: true,
                                      songSheetInfo: songSheetInfo,
                                      modalList: modalList,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: Adapt.pt(14),
                              color: const Color(
                                0xffcccccc,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: Adapt.pt(36),
                                height: Adapt.pt(36),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(urlConversion(
                                        songSheetInfo['user']['avatarUrl'])),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: Adapt.pt(12)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(songSheetInfo['user']['nickname']),
                                      SizedBox(width: Adapt.pt(3)),
                                      songSheetInfo['user']['vipRights'] !=
                                                  null &&
                                              songSheetInfo['user']['vipRights']
                                                      ['associator'] !=
                                                  null
                                          ? Image.network(
                                              urlConversion(
                                                  songSheetInfo['user']
                                                              ['vipRights']
                                                          ['associator']
                                                      ['iconUrl']),
                                              height: Adapt.pt(13),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  SizedBox(height: Adapt.pt(3)),
                                  Text(
                                    "${songSheetInfo['timeStr']} ${songSheetInfo['ipLocation']['location']}",
                                    style: TextStyle(
                                      fontSize: Adapt.pt(8),
                                      color: const Color(0xffa6a6a6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: Adapt.pt(12)),
                          Text(
                            songSheetInfo['content'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
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
                  songSheetInfo: songSheetInfo.isNotEmpty ? songSheetInfo : {},
                  commentCount: commentCount,
                  type: type,
                  title: title,
                  id: id,
                  modalList: modalList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  const CommentList({
    super.key,
    required this.songSheetInfo,
    required this.commentCount,
    required this.type,
    required this.title,
    required this.modalList,
    this.id,
  });
  final Map songSheetInfo;
  final int commentCount;
  final int type;
  final String title;
  final int? id;
  final List modalList;
  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  // 上拉刷新下拉加载控制器
  final EasyRefreshController _controller = EasyRefreshController();
  // 是否可以滚动
  bool isScroll = true;
  // 点击的选项
  int sortType = 1;
  // 评论列表
  List commentList = [];
  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.loading;
  // 选项
  List options = [
    {'name': "推荐", 'isActive': true},
    {'name': "最新", 'isActive': false},
    {'name': "最热", 'isActive': false},
  ];
  /*
    评论分页
  */
  Map pageQuery = {
    'pageSize': 20,
    'pageNo': 1,
  };
  // 评论的评论
  int limit = 20;
  // 是否没数据了
  bool isRefresh = false;
  // 总数
  int totalCount = 0;

  // 获取歌单评论
  void getSongComment() async {
    _layoutState = LoadState.loading;
    Map queryParams = {
      'type': widget.type,
      'id': widget.title == '评论' ? widget.songSheetInfo['id'] : widget.id,
      // 'timestamp': DateTime.now().millisecondsSinceEpoch
    };
    if (widget.title == '评论') {
      queryParams['pageNo'] = sortType == 1 ? 1 : pageQuery['pageNo'];
      queryParams['pageSize'] = sortType == 1 ? 9999 : pageQuery['pageSize'];
      queryParams['sortType'] = sortType;
      sortType == 3 && commentList.isNotEmpty
          ? queryParams['cursor'] = commentList[commentList.length - 1]['time']
          : null;
    } else {
      queryParams['limit'] = limit;
      queryParams['parentCommentId'] = widget.songSheetInfo['commentId'];
      commentList.isNotEmpty
          ? queryParams['time'] = commentList[commentList.length - 1]['time']
          : null;
    }
    Http.post(widget.title == '评论' ? 'getSongComment' : 'getCommentFloor',
        pathParams: queryParams, params: {}).then((res) {
      Future.delayed(const Duration(milliseconds: 1000));
      if (res['code'] != 200) return;
      Map result = res['data'];
      if (commentList.isEmpty && result['comments'].isEmpty) {
        _layoutState = LoadState.empty;
      } else {
        if (widget.title == '评论' &&
            widget.commentCount <=
                (pageQuery['pageNo'] * pageQuery['pageSize'])) {
          isRefresh = true;
        }
        if (widget.title == '回复' && widget.commentCount <= limit) {
          isRefresh = true;
        }
        commentList.addAll(result['comments']);
        widget.title == '回复' ? totalCount = result['totalCount'] : null;
        _layoutState = LoadState.success;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getSongComment();
    super.initState();
  }

  Future<void> _loadMore() async {
    // 模拟加载更多操作
    await Future.delayed(const Duration(milliseconds: 300));
    widget.title == '评论' ? pageQuery['pageNo'] += 1 : limit += 20;
    getSongComment();
    _controller.finishLoad(IndicatorResult.success, true);
  }

  Widget _buildOptionItem(int index) {
    return InkWell(
      onTap: () {
        for (int i = 0; i < options.length; i++) {
          if (i == index) {
            options[index]['isActive'] = true;
            sortType = index + 1;
            pageQuery = {
              'pageSize': 20,
              'pageNo': 1,
            };
            commentList = [];
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
      child: _buildComment(),
    );
  }

  Widget _buildComment() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: Adapt.pt(6), horizontal: Adapt.pt(12)),
          child: widget.commentCount != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title == '评论' ? "评论区" : "全部回复 $totalCount",
                      style: TextStyle(
                        fontSize: Adapt.pt(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: widget.title == '评论'
                          ? [
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
                            ]
                          : [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    commentList = commentList.reversed.toList();
                                  });
                                },
                                child: const Icon(Icons.unfold_more),
                              )
                            ],
                    ),
                  ],
                )
              : Container(),
        ),
        Expanded(
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
        ),
      ],
    );
  }

  Widget _buildCommentList() {
    return SimpleEasyRefresher(
      easyRefreshController: _controller,
      onLoad: (widget.title == '评论' && sortType == 1) || isRefresh
          ? null
          : _loadMore,
      childBuilder: (context, physics) {
        return _buildCommentItem(physics);
      },
    );
  }

  Widget _buildCommentItem(physics) {
    return ListView.builder(
      itemCount: commentList.length,
      physics: physics,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: Adapt.pt(6), horizontal: Adapt.pt(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            image: NetworkImage(urlConversion(
                                commentList[index]['user']['avatarUrl'])),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: Adapt.pt(12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(commentList[index]['user']['nickname']),
                              SizedBox(width: Adapt.pt(3)),
                              commentList[index]['user']['vipRights'] != null &&
                                      commentList[index]['user']['vipRights']
                                              ['associator'] !=
                                          null
                                  ? Image.network(
                                      urlConversion(commentList[index]['user']
                                              ['vipRights']['associator']
                                          ['iconUrl']),
                                      height: Adapt.pt(13),
                                    )
                                  : Container(),
                            ],
                          ),
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
                  LikeButton(
                    likedCount: commentList[index]['likedCount'],
                    liked: commentList[index]['liked'],
                    fn: lickButtonClick,
                    index: index,
                  ),
                ],
              ),
              SizedBox(height: Adapt.pt(6)),
              Row(
                children: [
                  SizedBox(width: Adapt.pt(48)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commentList[index]['content'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        commentList[index]['beReplied'] != null &&
                                widget.songSheetInfo['content'] !=
                                    commentList[index]['beReplied'][0]
                                        ['content']
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: Adapt.pt(12), bottom: Adapt.pt(3)),
                                padding: EdgeInsets.only(
                                    top: Adapt.pt(3),
                                    bottom: Adapt.pt(3),
                                    right: Adapt.pt(6)),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: Adapt.pt(2),
                                      color: const Color(
                                        0xffcccccc,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: Adapt.pt(6)),
                                    Expanded(
                                      child: HiddenText(
                                        leftText:
                                            "@${commentList[index]['beReplied'][0]['user']['nickname']}: ",
                                        text:
                                            "${commentList[index]['beReplied'][0]['content']}",
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: Adapt.pt(14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              commentList[index]['replyCount'] != null &&
                      commentList[index]['replyCount'] != 0
                  ? Column(
                      children: [
                        SizedBox(height: Adapt.pt(6)),
                        InkWell(
                          onTap: () {
                            CommentModalBottomSheet.showBottomModal(
                              context,
                              fn: () {},
                              id: widget.songSheetInfo['id'],
                              songSheetInfo: commentList[index],
                              commentCount:
                                  commentList[index]['replyCount'] ?? 0,
                              type: 2,
                              title: "回复",
                              modalList: widget.modalList,
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(width: Adapt.pt(48)),
                              Flexible(
                                child: Text(
                                  "${commentList[index]['replyCount']} 条回复",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: Adapt.pt(12),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: Adapt.pt(12),
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
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
    );
  }

  void lickButtonClick(int j) {
    commentList[j]['liked'] = !commentList[j]['liked'];
    commentList[j]['likedCount'] = commentList[j]['liked']
        ? commentList[j]['likedCount'] + 1
        : commentList[j]['likedCount'] - 1;
    setState(() {});
    // 点赞
    Http.post('setCommentLike', params: {}, pathParams: {
      'type': widget.type,
      'id': widget.title == '评论' ? widget.songSheetInfo['id'] : widget.id,
      't': commentList[j]['liked'] ? 1 : 0,
      'cid': commentList[j]['commentId']
    });
  }
}
