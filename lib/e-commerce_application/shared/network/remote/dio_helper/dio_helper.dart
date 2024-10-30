import 'package:dio/dio.dart';

abstract class DioHelper{
  static Dio? _dio;

  static Future<void> initializeDio()async{
    _dio ??= Dio(
      BaseOptions(
        baseUrl: "https://student.valuxapps.com/api/",
        receiveDataWhenStatusError: true,
        validateStatus: (status) => status! <= 500,
        headers: {
          'lang':'en'
        }
      ),
    );
  }

  static Future<Response> getRequest({
    required String endPoint,
    String? token,
    Map<String,dynamic>? queryParameters
  })async{
    _dio!.options.headers = {
      "Authorization": token,
      'lang':'en',
    };
    return await _dio!.get(endPoint,queryParameters: queryParameters);
  }
  static Future<Response> postRequest({
    required String endPoint,
    String? token,
    Map<String,dynamic>? queryParameters,
    Map<String,dynamic>? data
  })async{
    _dio!.options.headers = {
      "Authorization": token,
      'lang':'en'
    };
    return await _dio!.post(endPoint,queryParameters: queryParameters,data: data);
  }
}