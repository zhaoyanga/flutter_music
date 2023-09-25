import 'package:flutter/material.dart';
import 'Adapt.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import '../blob/app_config.dart';
import 'package:share_plus/share_plus.dart';
import 'MyButton.dart';

class SongSheetPage extends StatefulWidget {
  const SongSheetPage({
    super.key,
    required this.states,
    required this.isNoCachePage,
  });
  final AppConfig states;
  final bool isNoCachePage;
  @override
  State<SongSheetPage> createState() => _SongSheetPageState();
}

class _SongSheetPageState extends State<SongSheetPage>
    with SingleTickerProviderStateMixin {
  // 滚动控制器
  final ScrollController sc = ScrollController();
  // 是否切换标题
  bool headerWhite = false;
  @override
  void initState() {
    super.initState();
    sc.addListener(() {
      ///监听滚动位置设置文字变化
      setState(() {
        headerWhite = sc.offset > 180 ? true : false;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
      body: _buildScaffoldBody(widget.states),
    );
  }

  late double pinnedHeaderHeight;
  final buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Adapt.pt(50)),
      ),
    ),
    backgroundColor: const MaterialStatePropertyAll(
      Color(0xff9b9293),
    ),
    overlayColor: const MaterialStatePropertyAll(
      Color(0xff978d8b),
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
  Widget _buildScaffoldBody(AppConfig state) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight;
    return ExtendedNestedScrollView(
      controller: sc,
      headerSliverBuilder: (BuildContext c, bool f) {
        return <Widget>[
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: Adapt.pt(240),
            backgroundColor: const Color(0xff796d6d),
            elevation: 0,
            title: SizedBox(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: headerWhite
                        ? Text(
                            breakWord("火火鲨喜欢的音乐火火鲨喜欢的音乐火火鲨喜欢的音乐"),
                            style: TextStyle(
                              fontSize: Adapt.pt(18),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 40),
                            child: const Center(
                              child: Text("歌单"),
                            ),
                          ),
                  ),
                  Row(
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
                  )
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xff685e5e),
                        Color(0xff827575),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: Adapt.pt(78),
                        left: Adapt.pt(18),
                        right: Adapt.pt(18),
                        bottom: Adapt.pt(18)),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Adapt.pt(90),
                              height: Adapt.pt(90),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Adapt.pt(12)),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                      "http://p1.music.126.net/sDWdh0lejhHL57ZDG6gmcg==/109951165453702483.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                                        fontSize: Adapt.pt(12),
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
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: Adapt.pt(2)),
                                                  child: Container(
                                                    width: Adapt.pt(18),
                                                    height: Adapt.pt(18),
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            "http://p1.music.126.net/sDWdh0lejhHL57ZDG6gmcg==/109951165453702483.jpg"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: Adapt.pt(6)),
                                                Text(
                                                  "火火鲨",
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffe1d8d9),
                                                    fontSize: Adapt.pt(10),
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
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Adapt.pt(18)),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: MyButton(
                                fn: _onShare,
                                icon: Icons.reply,
                                text: "分享",
                                style: buttonStyle,
                              ),
                            ),
                            SizedBox(width: Adapt.pt(12)),
                            Expanded(
                              flex: 1,
                              child: MyButton(
                                fn: () {},
                                icon: Icons.textsms,
                                text: "评论",
                                style: buttonStyle,
                              ),
                            ),
                            SizedBox(width: Adapt.pt(12)),
                            Expanded(
                              flex: 1,
                              child: MyButton(
                                fn: () {},
                                icon: Icons.library_add_check,
                                text: "收藏",
                                style: buttonStyle,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ),
            ),
          )
        ];
      },
      //1.[pinned sliver header issue](https://github.com/flutter/flutter/issues/22393)
      pinnedHeaderSliverHeightBuilder: () {
        return pinnedHeaderHeight;
      },
      onlyOneScrollInBody: true,
      body: Column(
        children: [
          Container(
            decoration: headerWhite
                ? const BoxDecoration(color: Color(0xff796d6d))
                : const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff685e5e),
                        Color(0xff827575),
                      ],
                    ),
                  ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffeae8e9),
                    Color(0xfff2f2f2),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Adapt.pt(12), horizontal: Adapt.pt(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                                fontSize: Adapt.pt(14))),
                        SizedBox(width: Adapt.pt(6)),
                        Text("(9)", style: TextStyle(fontSize: Adapt.pt(10))),
                      ],
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
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 200,
                    child: Text("$index"),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _onShare(BuildContext context) async {
    Share.share('check out my website https://example.com',
        subject: 'Look what I made!');
  }
}
