import 'package:flutter/material.dart';
import '../Adapt.dart';
import '../Assets_Images.dart';

class ListInfo extends StatelessWidget {
  // final Map info;
  const ListInfo({
    super.key,
  });

  static final List<Map> _bottom = [
    {'icon': Icons.play_arrow, 'text': 'playCount'},
    {'icon': Icons.sms, 'text': 'commentCount'},
    {'icon': Icons.add, 'text': 'subscribedCount'}
  ];

  List<Widget> _createBottom(double width) {
    List<Widget> arr = [];
    for (var element in _bottom) {
      arr.add(
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(element['icon'], color: Colors.white),
              SizedBox(width: Adapt.pt(5)),
              Text(
                '111万',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adapt.pt(14),
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Adapt.pt(20)),
      padding: EdgeInsets.all(Adapt.pt(5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.pt(10)),
        // color: Colors.black.withOpacity(.2),
      ),
      child: Column(
        children: [
          Text(
            '昭阳',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: Adapt.pt(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(Adapt.pt(2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Adapt.pt(10)),
                    child: Image.asset(
                      AssetsImages.splachJpeg,
                      fit: BoxFit.fill,
                      width: Adapt.pt(25),
                      height: Adapt.pt(25),
                    ),
                  ),
                   SizedBox(width: Adapt.pt(5)),
                   Text(
                    "火火鲨",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Adapt.pt(14),
                      height: 1,
                    ),
                  ),
                   SizedBox(width: Adapt.pt(5)),
                  InkWell(
                    highlightColor: Colors.transparent,
                    radius: 0.0,
                    onTap: () {
                      print('播放');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Adapt.pt(5)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Adapt.pt(10)),
                        color: Colors.grey.withOpacity(.4),
                      ),
                      child: Icon(
                        Icons.add,
                        size: Adapt.pt(16),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 底部数据展示
          Container(
            margin: EdgeInsets.only(left: Adapt.pt(20), right: Adapt.pt(20), bottom: Adapt.pt(10)),
            padding: EdgeInsets.all(Adapt.pt(5)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Adapt.pt(20)),
              color: Colors.white.withOpacity(.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _createBottom((size.width - 100) / 3),
            ),
          )
        ],
      ),
    );
  }
}

class DayInfo extends StatelessWidget {
  const DayInfo({
    super.key,
  });

  static final List<String> _day = [
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
    '七',
    '八',
    '九'
  ];

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String month = '';
    if (now.month.toString().length == 1) {
      month = _day[now.month - 1];
    } else {
      switch (now.month % 10) {
        case 0:
          month = '十';
          break;
        case 1:
          month = '十一';
          break;
        case 2:
          month = '十二';
          break;
        default:
      }
    }

    return Column(
      children: [
         Text(
          '根据你的口味推荐',
          style: TextStyle(
            color: Colors.white,
            fontSize: Adapt.pt(18),
            fontWeight: FontWeight.bold,
          ),
        ),
         SizedBox(height: Adapt.pt(5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${now.day} / ',
              style:  TextStyle(
                color: Colors.white,
                fontSize: Adapt.pt(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$month月',
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.pt(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
