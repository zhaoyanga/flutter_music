import 'package:daoniao_music/blob/app_config.dart';
import 'package:flutter/material.dart';
import '../common/Adapt.dart';

class PlayBarController extends StatefulWidget {
  PlayBarController({
    super.key,
    required this.imgUrl,
  });
  String imgUrl;
  @override
  State<PlayBarController> createState() => _PlayBarControllerState();
}

class _PlayBarControllerState extends State<PlayBarController> {

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Container(
      width: Adapt.pt(42),
      height: Adapt.pt(42),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(width: Adapt.pt(6), color: Colors.black),
        ),
        image: DecorationImage(
          image: NetworkImage(widget.imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
    //   );
  }
}
