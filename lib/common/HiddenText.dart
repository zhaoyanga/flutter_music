import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HiddenText extends StatefulWidget {
  final String? text;
  final TextStyle? style;
  final int? maxLines;
  final String expandText;
  final String collapseText;
  final String? leftText;

  const HiddenText(
      {Key? key,
      this.text,
      this.style,
      this.maxLines,
      this.leftText,
      this.collapseText = '    收起',
      this.expandText = ' 展开'})
      : super(key: key);

  @override
  State<HiddenText> createState() => _HiddenTextState();
}

class _HiddenTextState extends State<HiddenText> {
  bool expand = false;
  String linkText = "";
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // 思路： 获取最大行数的尾部的偏移量。
      // 2. 在偏移量的尾部截图 展开或者收起的文字的大小
      //第二种：
      var span = TextSpan(
        text: widget.leftText != null
            ? "${widget.leftText}${widget.text}"
            : widget.text,
        style: widget.style,
      );
      var textPainer = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr);
      textPainer.layout(maxWidth: constraints.maxWidth);
      final textSize = textPainer.size;

      var position = textPainer.getPositionForOffset(Offset(
        textSize.width,
        textSize.height,
      ));
      final endOffset = textPainer.getOffsetBefore(position.offset);
      // if (textPainter.didExceedMaxLines) {
      //超出
      return Text.rich(TextSpan(children: [
        widget.leftText != null
            ? TextSpan(
                text: widget.leftText,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ))
            : const TextSpan(),
        TextSpan(
            text: expand
                ? widget.text
                : '${widget.text!.substring(0, (endOffset! - (widget.leftText != null ? widget.leftText!.length : 0) - (expand ? widget.collapseText.length - 1 : widget.expandText.length - 1)))}...',
            style: widget.style ??
                const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )),
        TextSpan(
            text: expand ? widget.collapseText : widget.expandText,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print("展开");
                setState(() {
                  expand = !expand;
                });
              })
      ]));
      // return RichText(
      //   text: TextSpan(
      //       text: expand
      //           ? widget.text
      //           : widget.text!.substring(
      //               0,
      //               (endOffset! -
      //                   (expand
      //                       ? widget.collapseText.length - 1
      //                       : widget.expandText.length - 3))),
      //       style: const TextStyle(
      //         overflow: TextOverflow.ellipsis,
      //         color: Colors.black,
      //         fontWeight: FontWeight.w500,
      //       ),
      //       children: [
      //         TextSpan(
      //             text: expand ? widget.collapseText : widget.expandText,
      //             style: const TextStyle(
      //               color: Colors.blue,
      //               fontWeight: FontWeight.w500,
      //               fontSize: 14,
      //             ),
      //             recognizer: TapGestureRecognizer()
      //               ..onTap = () {
      //                 print("展开");
      //                 setState(() {
      //                   expand = !expand;
      //                 });
      //               }),
      //       ]),
      // );
      // } else {
      //   return Text(widget.text ?? "");
      // }
    });
  }
}
