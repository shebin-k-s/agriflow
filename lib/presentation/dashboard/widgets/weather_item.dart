import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  const WeatherItem({
    super.key,
    required this.day,
    required this.icon,
    required this.temp,
  });

  final String day;
  final IconData icon;
  final String temp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day),
        Icon(icon, color: Colors.blue),
        Text(temp),
      ],
    );
  }
}
