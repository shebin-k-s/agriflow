import 'package:agriflow/domain/entities/field/field.dart';
import 'package:agriflow/presentation/dashboard/widgets/parameter_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FieldCard extends StatelessWidget {
  const FieldCard({super.key, required this.field});

  final FieldData field;

  @override
  Widget build(BuildContext context) {
    String formattedDate = field.sensorReadingsLastUpdated != null
        ? DateFormat('MMM dd, yyyy • hh:mm a')
            .format(field.sensorReadingsLastUpdated!)
        : "Not updated yet";

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
                      field.fieldName,
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
                Expanded(
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right, // Align to the right
                    softWrap: true, // Allow text to wrap
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
                  value: '${field.sensorReadings.moisture}%',
                  icon: Icons.water_drop,
                  color: Colors.blue,
                ),
                ParameterCard(
                  title: 'Temperature',
                  value: '${field.sensorReadings.temperature}°C',
                  icon: Icons.thermostat,
                  color: Colors.orange,
                ),
                ParameterCard(
                  title: 'pH',
                  value: '${field.sensorReadings.pH}',
                  icon: Icons.science,
                  color: Colors.purple,
                ),
                ParameterCard(
                  title: 'Nitrogen',
                  value: '${field.sensorReadings.nitrogen} mg/kg',
                  icon: Icons.grass,
                  color: Colors.green,
                ),
                ParameterCard(
                  title: 'Phosphorus',
                  value: '${field.sensorReadings.phosphorus} mg/kg',
                  icon: Icons.grass,
                  color: Colors.green,
                ),
                ParameterCard(
                  title: 'Potassium',
                  value: '${field.sensorReadings.potassium} mg/kg',
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
