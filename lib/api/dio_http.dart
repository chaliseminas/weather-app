import 'package:dio/dio.dart';
import 'ihttp.dart';

class DioHttp implements IHttp {
  late Dio dio;

  DioHttp._privateConstructor();
  static final DioHttp _instance = DioHttp._privateConstructor();

  factory DioHttp() {
    _instance.dio = Dio();
    _instance.dio.options = BaseOptions(connectTimeout: const Duration(milliseconds: 2500), receiveTimeout: const Duration(milliseconds: 2500));
    return _instance;
  }

  @override
  delete({String? url}) async {
    dio.options.headers["User-Agent"] = "okhttp";
    return dio.delete(url!);
  }

  @override
  patch({String? url, Map? data}) async {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["User-Agent"] = "okhttp";
    return dio.patch(url!, data: data);
  }

  @override
  get({String? url}) async {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["User-Agent"] = "okhttp";
    return dio.get(url!);
  }

  @override
  post({String? url, Map? data, Map? query}) async {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["User-Agent"] = "okhttp";
    if (data !=null && query != null) {
      return dio.post(url!, data: data, queryParameters: query as Map<String, dynamic>?);
    } else if (data != null) {
      return dio.post(url!, data: data);
    } else if (query != null){
      return dio.post(url!, queryParameters: data as Map<String, dynamic>?);
    } else {
      return dio.post(url!, data: data);
    }
  }

  @override
  put({String? url, Map? data}) async {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["User-Agent"] = "okhttp";
    return dio.put(url!, data: data);
  }
}
