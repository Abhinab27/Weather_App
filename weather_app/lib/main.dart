import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'weather_service.dart';
import 'splash_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with SingleTickerProviderStateMixin {

  final WeatherService service = WeatherService();

  Map<String, dynamic>? weather;
  Map<String, dynamic>? forecast;

  TextEditingController controller = TextEditingController();

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    loadWeather("London");
  }

  void loadWeather(String city) async {

    final w = await service.getWeather(city);
    final f = await service.getForecast(city);

    setState(() {
      weather = w;
      forecast = f;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: AnimatedBuilder(

        animation: animationController,

        builder: (context, child) {

          return Container(

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [
                  Colors.blue,
                  Colors.lightBlueAccent,
                  Colors.blueAccent,
                ],

                stops: [
                  animationController.value,
                  animationController.value + 0.3,
                  animationController.value + 0.6
                ],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

              ),
            ),

            child: SafeArea(

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: weather == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(

                  children: [

                    const Text(
                      "Weather App",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    TextField(

                      controller: controller,

                      decoration: InputDecoration(
                        hintText: "Enter city",
                        filled: true,
                        fillColor: Colors.white,

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            loadWeather(controller.text);
                          },
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      weather!["name"],
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 10),

                    Image.network(
                      "https://openweathermap.org/img/wn/${weather!['weather'][0]['icon']}@2x.png",
                    ),

                    Text(
                      "${weather!['main']['temp']}°C",
                      style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),

                    Text(
                      weather!['weather'][0]['description'],
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                      children: [

                        Column(
                          children: [

                            const Icon(Icons.water_drop,
                                color: Colors.white),

                            const Text(
                              "Humidity",
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              "${weather!['main']['humidity']}%",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16),
                            )
                          ],
                        ),

                        Column(
                          children: [

                            const Icon(Icons.air,
                                color: Colors.white),

                            const Text(
                              "Wind",
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              "${weather!['wind']['speed']} m/s",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16),
                            )
                          ],
                        )

                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "5 Day Forecast",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: List.generate(5, (index) {

                        final item =
                        forecast!["list"][index * 8];

                        final date = DateTime.parse(
                            item["dt_txt"]);

                        final day =
                        DateFormat('EEE').format(date);

                        return Expanded(

                          child: Container(

                            margin: const EdgeInsets.symmetric(horizontal: 5),

                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: Column(
                              children: [

                                Text(
                                  day,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 5),

                                Image.network(
                                  "https://openweathermap.org/img/wn/${item['weather'][0]['icon']}@2x.png",
                                  width: 40,
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "${item['main']['temp']}°C",
                                ),

                              ],
                            ),
                          ),
                        );
                      }),
                    )

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}