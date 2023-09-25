import 'package:flutter/material.dart';
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
              const SizedBox(width: 5),
              const Text(
                '111万',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // color: Colors.black.withOpacity(.2),
      ),
      child: Column(
        children: [
          const Text(
            '昭阳',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      AssetsImages.splachJpeg,
                      fit: BoxFit.fill,
                      width: 25,
                      height: 25,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "火火鲨",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    highlightColor: Colors.transparent,
                    radius: 0.0,
                    onTap: () {
                      print('播放');
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(.4),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
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
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
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
        const Text(
          '根据你的口味推荐',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${now.day} / ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$month月',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
