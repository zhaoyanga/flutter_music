import 'package:flutter/material.dart';

class Toast {
  static void show(
      {required BuildContext context,
      required String message,
      Color? color,
      Color? textColor}) {
    //建立一个OverlayEntry对象
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      //外层使用Positioned进行定位，控制在Overlay中的位置
      return Positioned(
          top: MediaQuery.of(context).size.height * 0.42,
          // top: 70,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: color ?? const Color(0xffB9B9BD),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ));
    });
    //往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry);
    //两秒后，移除Toast
    Future.delayed(const Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }
}
