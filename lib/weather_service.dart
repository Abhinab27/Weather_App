import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  final String apiKey = "26cc7d64e36b18a898195857b2ae0ea8";

  Future<Map<String, dynamic>> getWeather(String city) async {

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getForecast(String city) async {

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    return jsonDecode(response.body);
  }
}