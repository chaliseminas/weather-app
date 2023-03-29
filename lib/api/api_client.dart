import 'package:dio/dio.dart';
import 'package:weather/api/api_error_constants.dart';
import 'package:weather/api/api_urls.dart';
import 'package:weather/api/dio_http.dart';
import 'package:weather/api/ihttp.dart';
import 'package:weather/api/result.dart';

class ApiClient extends IHttp {

  late IHttp _iHttp;

  ApiClient() {
    _iHttp = DioHttp();
  }

  Future<Result> getLatLong(String cityName) async {
    try{
      String url = "http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=$apiKey";
      var response = await _iHttp.get(
          url: url);
      return Result.success(response.data);
    } catch (error) {
      return Result.error(_getErrorData(error));
    }
  }

  Future<Result> getForeCast(lat, lon) async {
    try{
      String url = "${baseUrl}forecast?lat=$lat&lon=$lon&appid=$apiKey";
      var response = await _iHttp.get(
        url: url);
      return Result.success(response.data);
    } catch (error) {
      return Result.error(_getErrorData(error));
    }
  }

  ///-------------------------------------------------------------////

  DataError _getErrorData(error) {
    dynamic errorDescription;
    DioError dioError = error;
    switch (dioError.type) {
      case DioErrorType.cancel:
        errorDescription = APIErrorConstants.dioErrorCancel;
        break;
      case DioErrorType.connectionTimeout:
        errorDescription = APIErrorConstants.dioErrorConnectionTimeout;
        break;
      case DioErrorType.unknown:
        errorDescription = APIErrorConstants.dioErrorDefault;
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = APIErrorConstants.dioErrorReceiveTimeout;
        break;
      case DioErrorType.badResponse:
        if (dioError.response != null) {
          errorDescription = error.response?.data != null
              ? () {
            try {
              return error.response?.data["message"];
            } catch
            (e) {
              return error.response?.data["message"];
            }
          }()
              : "${APIErrorConstants.dioErrorReceiveTimeout} ${dioError
              .response?.statusCode}";
        } else {
          errorDescription = dioError.message;
        }
        break;
      case DioErrorType.sendTimeout:
        errorDescription = APIErrorConstants.dioErrorSendTimeout;
        break;
      case DioErrorType.badCertificate:
        errorDescription = APIErrorConstants.dioErrorDefault;
        break;
      case DioErrorType.connectionError:
        errorDescription = APIErrorConstants.connectionError;
        break;
    }
    return DataError(errorDescription, error.response?.statusCode ?? 0);
  }
}