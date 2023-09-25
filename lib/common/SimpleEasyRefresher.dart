import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class SimpleEasyRefresher extends StatefulWidget {
  const SimpleEasyRefresher({
    super.key,
    required this.easyRefreshController,
    this.onLoad,
    this.onRefresh,
    required this.childBuilder,
    this.indicatorPosition = IndicatorPosition.above,
  });

  // EasyRefreshController实例，用于控制刷新和加载的状态
  final EasyRefreshController? easyRefreshController;
  // 加载回调函数
  final FutureOr<dynamic> Function()? onLoad;

  // 刷新回调函数
  final FutureOr<dynamic> Function()? onRefresh;

  // 构建子组件的回调函数
  final Widget Function(BuildContext context, ScrollPhysics physics)?
      childBuilder;

  // 指示器的位置，默认为上方
  final IndicatorPosition indicatorPosition;

  @override
  State<SimpleEasyRefresher> createState() => _SimpleEasyRefresherState();
}

class _SimpleEasyRefresherState extends State<SimpleEasyRefresher> {
  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      // 在开始刷新时立即触发刷新
      refreshOnStart: false,
      // 刷新完成后重置刷新状态
      resetAfterRefresh: true,
      // 同时触发刷新和加载的回调函数
      simultaneously: true,
      // 加载回调函数
      onLoad: widget.onLoad != null
          ? () async {
              await widget.onLoad?.call();
              setState(() {});
            }
          : null,
      // 刷新回调函数
      onRefresh: widget.onRefresh != null
          ? () async {
              await widget.onRefresh?.call();
              setState(() {});
            }
          : null,
      // 指定刷新时的头部组件
      header: ClassicHeader(
        hitOver: true,
        safeArea: false,
        processedDuration: Duration.zero,
        showMessage: false,
        showText: true,
        position: widget.indicatorPosition,
        // 下面是一些文本配置
        processingText: "正在刷新...",
        readyText: "正在刷新...",
        armedText: "释放以刷新",
        dragText: "下拉刷新",
        processedText: "刷新成功",
        failedText: "刷新失败",
      ),
      // 指定加载时的底部组件
      footer: ClassicFooter(
        processedDuration: Duration.zero,
        showMessage: false,
        showText: true,
        // infiniteOffset: null, 回弹
        maxOverOffset: 200,
        position: widget.indicatorPosition,
        // 下面是一些文本配置
        processingText: "加载中...",
        processedText: "加载成功",
        readyText: "加载中...",
        armedText: "释放以加载更多",
        dragText: "上拉加载",
        failedText: "加载失败",
        noMoreText: "没有更多内容",
      ),
      controller: widget.easyRefreshController,
      childBuilder: widget.childBuilder,
    );
  }
}
