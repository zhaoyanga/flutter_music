import 'package:flutter/material.dart';
import '../common/Adapt.dart';
import '../utils/request.dart';

class DragonBall extends StatefulWidget {
  const DragonBall({super.key});

  @override
  State<DragonBall> createState() => _DragonBallState();
}

class _DragonBallState extends State<DragonBall> {
  // 圆形图标
  List dragonBall = [];

  @override
  void initState() {
    super.initState();
    getHomepageDragonBall();
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: Adapt.pt(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: dragonBall.asMap().keys.map(dragonBallitemBuild).toList(),
        ),
      ),
    );
  }

  Widget dragonBallitemBuild(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adapt.pt(12)),
      child: InkWell(
        onTap: () {
          print(1);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              dragonBall[index]['iconUrl'],
              color: Colors.red,
              height: Adapt.pt(60.0),
            ),
            Text(
              dragonBall[index]['name'],
              style: TextStyle(height: Adapt.pt(0.5)),
            )
          ],
        ),
      ),
    );
  }

  void getHomepageDragonBall() {
    Http.get('homepageDragonBall', params: {}).then((res) {
      setState(() {
        dragonBall = res['data'];
      });
    });
  }
}
