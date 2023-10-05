import 'package:flutter/material.dart';
import '../common/Adapt.dart';
import '../utils/request.dart';

class DailRecommenDations extends StatefulWidget {
  const DailRecommenDations({super.key});

  @override
  State<DailRecommenDations> createState() => _DailRecommenDationsState();
}

class _DailRecommenDationsState extends State<DailRecommenDations> {
  List recommendSongs = [];

  @override
  void initState() {
    getRecommendResource();
    super.initState();
  }

  void getRecommendResource() {
    Http.post('getRecommendResource', params: {}).then((res) {
      setState(() {
        recommendSongs = res['recommend'];
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
    return recommendSongs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "推荐歌单",
                        style: TextStyle(
                          fontSize: Adapt.pt(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Adapt.pt(2)),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: Adapt.pt(16),
                        ),
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xffa6a5aa),
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(bottom: Adapt.pt(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: recommendSongs
                      .asMap()
                      .keys
                      .map(buildResourceitem)
                      .toList(),
                ),
              )
            ],
          )
        : Container();
  }

  Widget buildResourceitem(int index) {
    return Container(
      padding: EdgeInsets.only(right: Adapt.pt(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Adapt.pt(16)),
            ),
            child: Stack(
              children: [
                Image.network(
                  recommendSongs[index]['picUrl'],
                  height: Adapt.pt(120.0),
                  width: Adapt.pt(120.0),
                  fit: BoxFit.fill,
                ),
                index == 0
                    ? Positioned(
                        right: Adapt.pt(10),
                        top: Adapt.pt(2),
                        child: const Icon(
                          Icons.all_inclusive,
                          color: Colors.white,
                        ),
                      )
                    : Positioned(
                        right: Adapt.pt(8),
                        top: Adapt.pt(2),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: Adapt.pt(3)),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: Adapt.pt(12),
                              ),
                            ),
                            Text(
                              "${recommendSongs[index]['trackCount']}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                index != 0
                    ? Positioned(
                        right: Adapt.pt(5),
                        bottom: Adapt.pt(2),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: Adapt.pt(32),
                        ),
                      )
                    : Container(),
                index != 0
                    ? Positioned(
                        left: Adapt.pt(5),
                        top: Adapt.pt(2),
                        child: Icon(
                          Icons.music_note_outlined,
                          color: Colors.white,
                          size: Adapt.pt(22),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            width: Adapt.pt(120.0),
            height: Adapt.pt(40.0),
            child: Text(
              breakWord(recommendSongs[index]['name']),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: Adapt.pt(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
