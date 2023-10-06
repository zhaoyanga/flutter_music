import 'package:flutter/material.dart';

class MyRichText extends StatefulWidget {
  String text;
  int mMaxLine; // 最大显示行数
  bool mIsExpansion; // 全文、收起 的状态
  MyRichText(this.text,
      {this.mMaxLine = 3, this.mIsExpansion = false, Key? key})
      : super(key: key);

  @override
  State<MyRichText> createState() => _RichTextState();
}

class _RichTextState extends State<MyRichText> {
  @override
  Widget build(BuildContext context) {
    if (IsExpansion(widget.text)) {
      //是否截断
      if (widget.mIsExpansion) {
        return Column(
          children: <Widget>[
            Text(
              widget.text,
              textAlign: TextAlign.left,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  _isShowText();
                },
                child: Container(
                  child: const Text(
                    "收起",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: <Widget>[
            Text(
              widget.text,
              maxLines: widget.mMaxLine,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  _isShowText();
                },
                child: Container(
                  child: const Text(
                    "展开",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    } else {
      return Text(
        widget.text,
        maxLines: widget.mMaxLine,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  bool IsExpansion(String text) {
    TextPainter textPainter = TextPainter(
        maxLines: widget.mMaxLine,
        text: TextSpan(
            text: text,
            style: const TextStyle(fontSize: 16.0, color: Colors.black)),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: 100, minWidth: 50);
    if (textPainter.didExceedMaxLines) {
      //判断 文本是否需要截断
      return true;
    } else {
      return false;
    }
  }

  void _isShowText() {
    if (widget.mIsExpansion) {
      //关闭
      setState(() {
        widget.mIsExpansion = false;
      });
    } else {
      //打开
      setState(() {
        widget.mIsExpansion = true;
      });
    }
  }
}
