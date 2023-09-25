import 'package:flutter/material.dart';
import 'dart:ui';
import 'Adapt.dart';

// 头部
class HeaderWidget extends StatelessWidget {
  final IconData back;
  final Widget content;
  final Widget? rightWidget;
  final Function? callback;
  const HeaderWidget({
    super.key,
    required this.back,
    required this.content,
    this.rightWidget,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Adapt.initialize(context);
    return SizedBox(
      height: 60,
      width: size.width,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              back,
              color: Colors.white,
            ),
            onPressed: () {
              if (callback != null) {
                callback!();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          Expanded(
            child: content,
          ),
          rightWidget ?? Container(width: Adapt.pt(40)),
        ],
      ),
    );
  }
}
