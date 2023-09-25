import 'package:dio/dio.dart';
// 引入请求的公共配置，例如 baseUrl等
import 'http_config.dart';
// 引入本地缓存插件，用来获取本地缓存中的用户信息
import '../sharedPreferences/index.dart';
// 跳转key

// 封装 dio 请求类
class Http {
  // dio 的 options 配置
  static final BaseOptions _options = BaseOptions(
    baseUrl: baseUrl, // 请求的baseUrl
    connectTimeout: 10000, // 连接超时时间
    receiveTimeout: 15000, // 响应超时时间
    contentType: contentType['json'],
  );

  // 获取用户数据

  // get 请求
  static get(url, {pathParams, params, needCode = false, cancelToken}) async {
    return await request(
        url, pathParams, params, 'GET', null, needCode, cancelToken);
  }

  // post 请求
  static post(url, {pathParams, params, needCode = false, cancelToken}) async {
    Store store = await Store.getInstance();
    String cookie = await store.getCookie('cookie');
    params['cookie'] = cookie;
    return await request(
        url, pathParams, params, 'POST', null, needCode, cancelToken);
  }

  // put 请求
  static put(url, {pathParams, params, needCode = false, cancelToken}) async {
    return await request(
        url, pathParams, params, 'PUT', null, needCode, cancelToken);
  }

  // delete 请求
  static delete(urlName,
      {pathParams, params, needCode = false, cancelToken}) async {
    return await request(
        urlName, pathParams, params, 'DELETE', null, needCode, cancelToken);
  }

  /*
        * @description: 封装请求
        * @param {type} 
        * url          请求主路径连接
        * pathParams   连接请求参数类型为：https://test_api.com/user/:id/:name
        * params       请求参数在 body 中，或者为：https://test_api.com/user?id=123&name=zhangsan 
        * method       请求方法
        * header       请求头重置
        * needCode     是否需要状态码
        * @return {type}   返回响应数据
        */
  static request(urlName, pathParams, params, method, header, needCode,
      cancelToken) async {
    // 处理URL ，通过 urlName 在 urlPath 中匹配相应的 url 路径地址
    String url = urlPath[urlName];

    // get请求处理
    if (method == 'GET') {
      if (pathParams != null) {
        // 处理  https://test_api.com/user/:id/:name => https://test_api.com/user/123/zhangsan  请求连接
        pathParams.forEach((key, value) {
          if (url.contains(key)) {
            url = url.replaceAll(":$key", value.toString());
          }
        });
      } else if (pathParams == null) {
        // 处理 https://test_api.com/user?id=123&name=zhangsan 请求连接
        url += '?';
        params.forEach((key, value) {
          url += '$key=$value&';
        });
      }
    }

    if (method == 'POST') {
      // 处理 https://test_api.com/user?id=123&name=zhangsan 请求连接
      url += '?';
      pathParams.forEach((key, value) {
        url += '$key=$value&';
      });
    }

    Map headers = {};
    // // 存储 请求头 参数
    if (header != null) {
      headers.addAll(header);
    }
    //  授权信息 Authorization / token
    // if (cookie == null) {
    // Routers.navigatorKey.currentState?.pushNamed('/login');
    // print("!!!!!!!!!!!!!!!!!,$cookie");
    // Routers.navigatorKey.currentState
    //     ?.pushNamedAndRemoveUntil("/login", ModalRoute.withName("/home"));
    // Navigator.pushNamed(context, '/hlogin')
    // 处理授权信息不存在的逻辑，即 重新登录 或者 获取授权信息
    // } else {
    // headers['cookie'] = cookie;
    // Routers.navigatorKey.currentState?.pushNamed('/home');
    // 获取授权信息（ token、Authorization 一般出现一个或者两都存在）

    // if (sp.get('Authorization') != null) {
    //   headers['Authorization'] = sp.get('Authorization');
    // }
    // }

    // 设置请求头
    _options.headers = Map<String, dynamic>.from(headers);
    // print("3333333333333,${_options.headers}");
    // 初始化 Dio
    Dio dio = Dio(_options);

    Response? response;
    // dio 请求处理
    try {
      response = await dio.request(url,
          data: params,
          options: Options(method: method),
          cancelToken: cancelToken);
    } on DioError catch (e) {
      // 请求错误处理  ,错误码 e.response.statusCode
      if (e.response?.statusCode == 404) {
        return HttpException(message: "请求失败，请稍后重试", code: 404);
      } else if (e.type == DioErrorType.connectTimeout) {
        return HttpException(message: "连接超时，请重试");
      } else if (e.type == DioErrorType.sendTimeout) {
        return HttpException(message: "请求超时，请稍后重试");
      }
      // switch (exception.type) {
      //   case DioErrorType.connectTimeout:
      //     return HttpException(message: "连接超时，请重试");
      //   case DioErrorType.sendTimeout:
      //     return HttpException(message: "请求超时，请稍后重试");
      //   case DioErrorType.receiveTimeout:
      //     print(exception.type);
      //     return HttpException(message: "请求失败，请稍后重试");
      //   case DioErrorType.cancel: //请求被取消
      //     return HttpException(message: exception.message);
      //   default: //未知异常
      //     return HttpException(
      //         message: exception.message, code: exception.hashCode);
      // }
      // print('请求错误处理： ${e.response?.statusCode}');
      // return HttpException(message: e.message);
      // // handleHttpError(e.response!.statusCode!);
      // if (CancelToken.isCancel(e)) {
      //   print('请求取消! ${e.message}');
      // } else {
      //   // 请求发生错误处理
      //   if (e.type == DioErrorType.connectTimeout) {
      //     print('连接超时');
      //   }
      // }
    }

    // 对相应code的处理
    if (response == null) {
      print("响应错误");
    } else if (needCode) {
      // 需要返回code
      return response.data;
    } else if (!needCode) {
      // 不需要返回 code ，统一处理不同 code 的情况
      if (response.data != '' && response.data != null) {
        // 可对其他不同值的 code 做额外处理
        return response.data;
      } else {
        print('其他数据类型处理');
        return response;
      }
    }
  }
}

class HttpException implements Exception {
  final String? message;
  final int? code;

  HttpException({this.message, this.code});

  @override
  String toString() {
    return "code: $code\nmessage: $message";
  }

  Map aaa() {
    return {
      "code":code,
      "message":message
    };
  }
}
