import 'dart:ui';
import 'package:daoniao_music/common/Assets_Images.dart';
import 'package:flutter/material.dart';

import '../Adapt.dart';

class SongDetail extends StatelessWidget {
  const SongDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.03,
            child: Image.asset(
              AssetsImages.splachJpeg,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ],
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsImages.splachJpeg,
                    width: Adapt.pt(200),
                    height: Adapt.pt(200),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Adapt.pt(30), bottom: Adapt.pt(30)),
                    child: Text(
                      "华语民谣：治愈。。。",
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
