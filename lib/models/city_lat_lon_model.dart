// To parse this JSON data, do
//
//     final cityLatLon = cityLatLonFromJson(jsonString);

import 'dart:convert';

List<CityLatLon> cityLatLonFromJson(String str) => List<CityLatLon>.from(json.decode(str).map((x) => CityLatLon.fromJson(x)));

String cityLatLonToJson(List<CityLatLon> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityLatLon {
  CityLatLon({
    this.name,
    // this.localNames,
    this.lat,
    this.lon,
    this.country,
  });

  String? name;
  // Map<String, String>? localNames;
  double? lat;
  double? lon;
  String? country;

  factory CityLatLon.fromJson(Map<String, dynamic> json) => CityLatLon(
    name: json["name"],
    // localNames: Map.from(json["local_names"]!).map((k, v) => MapEntry<String, String>(k, v)),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    // "local_names": Map.from(localNames!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "lat": lat,
    "lon": lon,
    "country": country,
  };
}
