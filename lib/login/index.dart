import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../common/Adapt.dart';
import '../sharedPreferences/index.dart';
import '../utils/request.dart';
import '../common/Totas.dart';
import '../blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String qrImg = '';
  late Timer? timer;
  String text = '';
  bool isEmpower = true;
  Map userInfo = {"nickname": "", "avatarUrl": ""};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("二维码登录"),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: Adapt.pt(18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isEmpower
              ? Center(
                  child: qrImg.isNotEmpty
                      ? Image.memory(
                          getBase(qrImg),
                          //防止重绘
                          gaplessPlayback: true,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                )
              : Center(
                  child: Column(
                    children: [
                      Container(
                        width: Adapt.pt(180),
                        height: Adapt.pt(180),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(userInfo['avatarUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(userInfo['nickname']),
                    ],
                  ),
                ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    login();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void login() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Store store = await Store.getInstance();
    String unikey = '';

    await Http.get('getQrCodeKeyGenerate', params: {'timestamp': timestamp})
        .then((result) {
      if (result['code'] != 200) return;
      unikey = result['data']['unikey'];
    });
    Http.get('getQrCodeGenerate',
            params: {'key': unikey, 'qrimg': true, 'timestamp': timestamp})
        .then((result) {
      if (result['code'] != 200) return;
      qrImg = result['data']['qrimg'];
      setState(() {});
    });
    if (mounted) {
      timer = Timer.periodic(const Duration(milliseconds: 3000), ((time) async {
        Map statusRes = await checkStatus(unikey);
        if (statusRes['code'] == 801) {
          text = statusRes['message'];
        }
        if (statusRes['code'] == 802) {
          isEmpower = false;
          userInfo = {
            "nickname": statusRes['nickname'],
            "avatarUrl": statusRes['avatarUrl']
          };
          text = statusRes['message'];
        }
        if (statusRes['code'] == 800) {
          Toast.show(context: context, message: "二维码已过期,请重新获取");
          text = "二维码已过期,请重新获取";
          timer?.cancel();
        }
        if (statusRes['code'] == 803) {
          // 这一步会返回cookie
          timer?.cancel();
          Toast.show(context: context, message: "授权登录成功");
          store.setCookie('cookie', statusRes['cookie']);
          getAccountInfo();
        }
        setState(() {});
      }));
    }
  }

  void getAccountInfo() async {
    Store store = await Store.getInstance();
    Http.post('getAccountInfo',
        pathParams: {'timestamp': DateTime.now().millisecondsSinceEpoch},
        params: {}).then((result) {
      if (result['code'] != 200) return;
      Http.post('getUserDetail', pathParams: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'uid': result['profile']['userId']
      }, params: {}).then((result) {
        Map profile = result['profile'];
        profile['leval'] = result['level'];
        store.setAccountInfo('accountInfo', profile);
        BlocProvider.of<AppConfigBloc>(context)
            .switchAccountInfo(result['profile']);
        Navigator.pushReplacementNamed(context, "/home");
      });
    });
  }

  Future<Map> checkStatus(key) async {
    Map res = {};
    await Http.get('getQrCodeDetection', params: {
      'key': key,
      'noCookie': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    }).then((result) {
      res = result;
    });
    return res;
  }

  Uint8List getBase(String? str) {
    String newstr = str!.split(',')[1];
    Uint8List bytes = const Base64Decoder().convert(newstr);
    return bytes;
  }
}
