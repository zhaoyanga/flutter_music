import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../utils/request.dart';
import '../common/Adapt.dart';

class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  List imgList = [];

  @override
  void initState() {
    super.initState();
    getBanner();
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Container(
      height: Adapt.pt(160),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.pt(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imgList[index]['pic'],
                fit: BoxFit.cover,
              ),
              Positioned(
                right: Adapt.pt(4.0),
                bottom: Adapt.pt(4.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Adapt.pt(6))),
                  padding: EdgeInsets.symmetric(
                      vertical: Adapt.pt(2), horizontal: Adapt.pt(8)),
                  child: Text(
                    imgList[index]['typeTitle'],
                    style: TextStyle(
                        fontSize: Adapt.pt(10),
                        fontWeight: FontWeight.w500,
                        color: getColor(imgList[index]['titleColor'])),
                  ),
                ),
              )
            ],
          );
        },
        itemCount: imgList.length,
        pagination: const SwiperPagination(),
        autoplay: true,
      ),
    );
  }

  void getBanner() {
    Http.get('banner', params: {'type': 2}).then((res) {
      setState(() {
        imgList = res['banners'];
      });
    });
  }

  Color getColor(String color) {
    switch (color) {
      //add more color as your wish
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "yellow":
        return Colors.yellow;
      case "orange":
        return Colors.orange;
      case "green":
        return Colors.green;
      case "pink":
        return Colors.pink;
      case "purple":
        return Colors.purple;
      default:
        return Colors.transparent;
    }
  }
}
