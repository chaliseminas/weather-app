import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:weather/api/api_client.dart';
import 'package:weather/api/result.dart';
import 'package:weather/models/city_lat_lon_model.dart';
import 'package:weather/models/weather_forecast.dart';

class WeatherRepository {

  late ApiClient _apiClient;

  WeatherRepository() {
    _apiClient = ApiClient();
  }

  Future<Result> getCityLatLon(String cityName) async {
    var result = await _apiClient.getLatLong(cityName);
    if (result.isSuccess()) {
      var data = await compute(cityLatLonFromJson, jsonEncode(result.getValue()));
      return Result.success(data);
    } else {
      return Result.error(result.getErrorMsg());
    }
  }

  Future<Result> getForeCast(lat, lon) async {
    var result = await _apiClient.getForeCast(lat, lon);
    if (result.isSuccess()) {
      var data = await compute(weatherForecastFromJson, jsonEncode(result.getValue()));
      return Result.success(data);
    } else {
      return Result.error(result.getErrorMsg());
    }
  }

}