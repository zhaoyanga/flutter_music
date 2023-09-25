import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  // static StoreKeys storeKeys;
  final SharedPreferences _store;
  static Future<Store> getInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Store._internal(preferences);
  }

  Store._internal(this._store);

  /// 保存cookie
  getCookie(String key) async {
    return _store.get(key) ?? '';
  }

  setCookie(String key, String value) async {
    return _store.setString(key, value);
  }

  removeCookie(String key) async {
    return _store.remove(key);
  }

  /// 是否第一次启动
  getIsFiring(String key) async {
    return _store.get(key) ?? '';
  }

  setIsFiring(String key, String value) async {
    return _store.setString(key, value);
  }

  removeIsFiring(String key) async {
    return _store.remove(key);
  }

  /// 保存用户信息
  getAccountInfo(String key) async {
    return _store.get(key) ?? '';
  }

  setAccountInfo(String key, Map value) async {
    String accountInfo = json.encode(value);
    return _store.setString(key, accountInfo);
  }

  /// 播放栏动画

  getAnimationValue(String key) {
    return _store.get(key) ?? '0';
  }

  setAnimationValue(String key, String value) async {
    return _store.setString(key, value);
  }

  remove(String key) async {
    return _store.remove(key);
  }
}
