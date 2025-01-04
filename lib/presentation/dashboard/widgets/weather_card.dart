import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherItem('Today', Icons.wb_sunny, '25°C'),
                _buildWeatherItem('Tomorrow', Icons.cloud, '23°C'),
                _buildWeatherItem('Day After', Icons.water_drop, '22°C'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherItem(String day, IconData icon, String temp) {
    return Column(
      children: [
        Text(day),
        Icon(icon, color: Colors.blue),
        Text(temp),
      ],
    );
  }
}
