import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

const String apiKey = '5bafb57b5f3b05aa57808a9d9bcd4e09';

const String apiURL = 'http://api.openweathermap.org/data/2.5/weather?q=';

const String apiKeyString = '&appid=$apiKey&units=metric';

class WeatherAPI {
  Future<Map> getWeatherData(String statesName) async {
//    Network network = Network('$apiURL$statesName&$apiKeyString');

    Response response = await get('$apiURL$statesName&$apiKeyString');

    return json.decode(response.body);
  }
}
