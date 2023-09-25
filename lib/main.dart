import 'package:daoniao_music/userInfo/index.dart';
import 'package:flutter/material.dart';
import 'blob/app_config.dart';
import 'blob/app_config_blob.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login/index.dart';
import 'home/index.dart';
import 'splach/index.dart';
import './common/NavigatorKey.dart';
import './sharedPreferences/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Store store = await Store.getInstance();
  String isFiring = await store.getIsFiring('isFiring');
  if (isFiring.isEmpty) {
    await store.setIsFiring('isFiring', '0');
  }
  runApp(
    BlocProvider<AppConfigBloc>(
      create: (context) => AppConfigBloc(
        appConfig: AppConfig.defaultScaffoldkey(index: 0),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        //命名导航路由,
        '/': (BuildContext context) => const SplachPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/userInfo': (BuildContext context) => const UserInfoPage(),
      },
      navigatorKey: Routers.navigatorKey,
    );
  }
}
