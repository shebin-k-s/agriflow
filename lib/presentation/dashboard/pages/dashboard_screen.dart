import 'package:agriflow/presentation/dashboard/widgets/field_card.dart';
import 'package:agriflow/presentation/dashboard/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Field {
  final String name;
  final String currentCrop;
  final String cropStage;
  final double moisture;
  final double temperature;
  final double pH;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final bool isWateringRecommended;
  final String nextWateringTime;
  final String location;
  final String deviceId;

  Field({
    required this.name,
    required this.currentCrop,
    required this.cropStage,
    required this.moisture,
    required this.temperature,
    required this.pH,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.isWateringRecommended,
    required this.nextWateringTime,
    required this.location,
    required this.deviceId,
  });
}

// Mock data
final List<Field> mockFields = [
  Field(
    name: 'Field 1',
    currentCrop: 'Cotton',
    cropStage: 'Flowering',
    moisture: 75,
    temperature: 25,
    pH: 6.5,
    nitrogen: 45,
    phosphorus: 35,
    potassium: 40,
    isWateringRecommended: true,
    nextWateringTime: '2 hours',
    location: 'North Plot',
    deviceId: 'DEV001',
  ),
  Field(
    name: 'Field 2',
    currentCrop: 'Wheat',
    cropStage: 'Vegetative',
    moisture: 65,
    temperature: 23,
    pH: 6.8,
    nitrogen: 50,
    phosphorus: 30,
    potassium: 45,
    isWateringRecommended: false,
    nextWateringTime: '8 hours',
    location: 'South Plot',
    deviceId: 'DEV002',
  ),
  Field(
    name: 'Field 3',
    currentCrop: 'Rice',
    cropStage: 'Maturity',
    moisture: 80,
    temperature: 26,
    pH: 6.2,
    nitrogen: 55,
    phosphorus: 40,
    potassium: 50,
    isWateringRecommended: false,
    nextWateringTime: '12 hours',
    location: 'East Plot',
    deviceId: 'DEV003',
  ),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WeatherCard(),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Field Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return FieldCard(
                field: mockFields[index],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16,
              );
            },
            itemCount: mockFields.length,
          ),
        ),
      ],
    );
  }
}
