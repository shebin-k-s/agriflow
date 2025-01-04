import 'package:agriflow/presentation/dashboard/pages/dashboard_screen.dart';
import 'package:agriflow/presentation/dashboard/widgets/parameter_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FieldCard extends StatelessWidget {
  const FieldCard({super.key, required this.field});

  final Field field;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current Crop: ${field.currentCrop}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Last Updated: ${DateFormat('hh:mm a').format(DateTime.now())}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ParameterCard(
                  title: 'Moisture',
                  value: '${field.moisture}%',
                  icon: Icons.water_drop,
                  color: Colors.blue,
                ),
                ParameterCard(
                  title: 'Temperature',
                  value: '${field.temperature}°C',
                  icon: Icons.thermostat,
                  color: Colors.orange,
                ),
                ParameterCard(
                  title: 'pH',
                  value: '${field.pH}',
                  icon: Icons.science,
                  color: Colors.purple,
                ),
                ParameterCard(
                  title: 'Nitrogen',
                  value: '${field.nitrogen} mg/kg',
                  icon: Icons.grass,
                  color: Colors.green,
                ),
                ParameterCard(
                  title: 'Phosphorus',
                  value: '${field.phosphorus} mg/kg',
                  icon: Icons.grass,
                  color: Colors.green,
                ),
                ParameterCard(
                  title: 'Potassium',
                  value: '${field.potassium} mg/kg',
                  icon: Icons.grass,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
