import 'package:flutter/material.dart';
import '../common/Adapt.dart';

class DailRecommenDations extends StatefulWidget {
  const DailRecommenDations({super.key});

  @override
  State<DailRecommenDations> createState() => _DailRecommenDationsState();
}

class _DailRecommenDationsState extends State<DailRecommenDations> {
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Column(
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
              icon: const Icon(Icons.format_align_justify),
            )
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: Adapt.pt(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
                [0, 1, 2, 3, 4, 5].asMap().keys.map(buildResourceitem).toList(),
          ),
        )
      ],
    );
  }

  Widget buildResourceitem(int index) {
    return Padding(
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
                  'https://img1.baidu.com/it/u=3573056321,2239143646&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1692550800&t=95909218443a3c3fe4063928b3ceee50',
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
                            const Text(
                              "164.3亿",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                Positioned(
                  right: Adapt.pt(5),
                  bottom: Adapt.pt(2),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: Adapt.pt(32),
                  ),
                ),
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
          Text(
            "歌单歌单",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: Adapt.pt(14),
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
