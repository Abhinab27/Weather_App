import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {

  testWidgets('Weather app loads correctly', (WidgetTester tester) async {

    // Build the app
    await tester.pumpWidget(const WeatherApp());

    // Verify that Weather App title appears
    expect(find.text('Weather App'), findsOneWidget);

  });

}