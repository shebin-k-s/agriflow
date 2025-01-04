import 'package:agriflow/presentation/dashboard/widgets/weather_item.dart';
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WeatherItem(
                  day: 'Today',
                  icon: Icons.wb_sunny,
                  temp: '25°C',
                ),
                WeatherItem(
                  day: 'Tomorrow',
                  icon: Icons.cloud,
                  temp: '23°C',
                ),
                WeatherItem(
                  day: 'Day After',
                  icon: Icons.water_drop,
                  temp: '22°C',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
