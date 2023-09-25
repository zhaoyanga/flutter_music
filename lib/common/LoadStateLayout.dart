import 'package:flutter/material.dart';
import 'Adapt.dart';
import 'Assets_Images.dart';

///四种视图状态
enum LoadState { success, error, loading, empty }

///根据不同状态来展示不同的视图
class LoadStateLayout extends StatefulWidget {
  final LoadState state; //页面状态
  final Widget? successWidget; //成功视图
  final VoidCallback? errorRetry; //错误事件处理

  const LoadStateLayout(
      {super.key,
      this.state = LoadState.loading, //默认为加载状态
      this.successWidget,
      this.errorRetry});

  @override
  _LoadStateLayoutState createState() => _LoadStateLayoutState();
}

class _LoadStateLayoutState extends State<LoadStateLayout> {

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return SizedBox(
      //宽高都充满屏幕剩余空间
      width: double.infinity,
      height: double.infinity,
      child: _buildWidget,
    );
  }

  ///根据不同状态来显示不同的视图
  Widget get _buildWidget {
    switch (widget.state) {
      case LoadState.success:
        return widget.successWidget!;
      case LoadState.error:
        return _errorView;
      case LoadState.loading:
        return _loadingView;
      case LoadState.empty:
        return _emptyView;
      default:
        return Container();
    }
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      alignment: Alignment.center,
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const <Widget>[
            CircularProgressIndicator(
              color: Colors.black,
            ),
            Text('正在加载')
          ],
        ),
      ),
    );
  }

  ///错误视图
  Widget get _errorView {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("加载失败，请重试"),
          ElevatedButton(
            onPressed: widget.errorRetry,
            child: const Text("重新加载"),
          )
        ],
      ),
    );
  }

  ///数据为空的视图
  Widget get _emptyView {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            AssetsImages.emptyPng,
            height: 100,
            width: 100,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('暂无数据'),
          )
        ],
      ),
    );
  }
}
