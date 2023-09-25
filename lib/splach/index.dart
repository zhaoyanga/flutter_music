import 'dart:convert';
import 'package:flutter/material.dart';
import '../common/Assets_Images.dart';
import '../sharedPreferences/index.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/request.dart';

class SplachPage extends StatefulWidget {
  const SplachPage({super.key});

  @override
  State<SplachPage> createState() => _SplachPageState();
}

class _SplachPageState extends State<SplachPage> {
  // 计数参数
  final duration = 6;
  int num = 0;
  void _countdown() async {
    num = duration;
    for (int i = 0; i < duration; i++) {
      await Future.delayed(const Duration(seconds: 1), () async {
        if (mounted == true) {
          setState(() {
            num--;
          });
          if (num == 0) {
            Store store = await Store.getInstance();
            store.setIsFiring('isFiring', '1');
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    // 获取用户数据
    Store store = await Store.getInstance();
    String cookie = await store.getCookie('cookie');
    String isFiring = await store.getIsFiring('isFiring');
    if (!mounted) return;
    if (isFiring == '0') {
      _countdown();
      return;
    } else {
      if (cookie.isNotEmpty) {
        store.setIsFiring('isFiring', '1');
        setAccountInfo();
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void setAccountInfo() async {
    Store store = await Store.getInstance();
    String accountInfo = await store.getAccountInfo('accountInfo');
    if (accountInfo.isNotEmpty) {
      Map<String, dynamic> userMap = json.decode(accountInfo);
      BlocProvider.of<AppConfigBloc>(context).switchAccountInfo(userMap);
    } else {
      getAccountInfo();
    }
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void getAccountInfo() async {
    Store store = await Store.getInstance();
    Http.post('getAccountInfo',
        pathParams: {'timestamp': DateTime.now().millisecondsSinceEpoch},
        params: {}).then((result) {
      if (result['code'] != 200) return;
      store.setAccountInfo('accountInfo', result['profile']);
      BlocProvider.of<AppConfigBloc>(context)
          .switchAccountInfo(result['profile']);
    });
  }

  // 标题倒计时抽取
  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // logo
  Widget _buildLogo(BuildContext context) {
    return Image.asset(
      AssetsImages.splachJpeg,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.height,
    );
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: _buildLogo(context),
        ),
        Positioned(
          right: 24,
          top: 24,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Center(
              child: _buildText(num > 0 ? "$num" : 'done'),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildView(context),
    );
  }
}
