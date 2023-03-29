import 'package:flutter/material.dart';
import 'package:weather/api/api_error_constants.dart';
import 'package:weather/api/result.dart';
import 'package:weather/models/city_lat_lon_model.dart';
import 'package:weather/models/weather_forecast.dart';
import 'package:weather/repository/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {

  bool isLoading = false;
  WeatherRepository weatherRepository = WeatherRepository();
  WeatherForecast? weatherForecast;
  String city = "";

  String errorMsg = APIErrorConstants.dioErrorCancel;

  setLoading(value, {notify = false}) {
    isLoading = value;
    if (notify) notifyListeners();
  }

  Future<bool> getCityLatLon(String cityName) async {
    city = cityName;
    setLoading(true, notify: true);
    Result response = await weatherRepository.getCityLatLon(cityName);
    if (response.isSuccess()) {
      List<CityLatLon> cityLatLon = await response.getValue();
      if (cityLatLon.isNotEmpty) {
        bool forecastResponse = await getWeatherForecast(
            cityLatLon[0].lat, cityLatLon[0].lon);
        setLoading(false, notify: true);
        if (forecastResponse) {
          return true;
        } else {
          return false;
        }
      } else {
        setLoading(false);
        errorMsg = "Please enter valid city name.";
        notifyListeners();
        return false;
      }
    } else {
      setLoading(false);
      DataError error = await response.getErrorMsg();
      errorMsg = error.message.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> getWeatherForecast(lat, lon) async {
    Result response = await weatherRepository.getForeCast(lat, lon);
    if (response.isSuccess()) {
      weatherForecast = await response.getValue();
      notifyListeners();
      return true;
    } else {
      DataError error = await response.getErrorMsg();
      errorMsg = error.message.toString();
      notifyListeners();
      return false;
    }
  }

}