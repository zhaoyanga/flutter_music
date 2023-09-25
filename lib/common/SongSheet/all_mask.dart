import 'package:flutter/material.dart';

import '../ColorUtils.dart';

class AllPlay extends StatelessWidget {
  final int count;

  const AllPlay({
    super.key,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      radius: 0.0,
      onTap: () {
        print('播放');
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.play_arrow,
                  size: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '播放全部 ($count)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Mask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.width / 1.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorUtils.getRandomColor(true),
            ColorUtils.getRandomColor(true),
            ColorUtils.getRandomColor(true),
            ColorUtils.getRandomColor(true),
            ColorUtils.getRandomColor(true),
            ColorUtils.getRandomColor(true)
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}
