import 'package:agriflow/presentation/crops/pages/crops_screen.dart';
import 'package:flutter/material.dart';

class Field {
  final String name;
  final List<CropRecommendation> recommendations;

  Field({required this.name, required this.recommendations});
}

class FieldSelector extends StatelessWidget {
  FieldSelector({super.key});
  int selectedFieldIndex = 0;
  final List<Field> fields = [
    Field(
      name: 'Field 1',
      recommendations: [
        CropRecommendation(
            cropName: 'Cotton',
            percentage: 95,
            description: 'Ideal soil pH and moisture'),
        CropRecommendation(
            cropName: 'Wheat',
            percentage: 85,
            description: 'Good nitrogen levels'),
        CropRecommendation(
            cropName: 'Soybeans',
            percentage: 75,
            description: 'Suitable soil texture'),
      ],
    ),
    Field(
      name: 'Field 2',
      recommendations: [
        CropRecommendation(
            cropName: 'Corn',
            percentage: 90,
            description: 'Based on current soil condition'),
        CropRecommendation(
            cropName: 'Rice',
            percentage: 80,
            description: 'Based on current soil condition'),
        CropRecommendation(
            cropName: 'Wheat',
            percentage: 70,
            description: 'Based on current soil condition'),
      ],
    ),
    Field(
      name: 'Field 3',
      recommendations: [
        CropRecommendation(
            cropName: 'Soybeans',
            percentage: 92,
            description: 'Based on current soil condition'),
        CropRecommendation(
            cropName: 'Cotton',
            percentage: 82,
            description: 'Based on current soil condition'),
        CropRecommendation(
            cropName: 'Corn',
            percentage: 72,
            description: 'Based on current soil condition'),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fields.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFieldIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(fields[index].name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  // setState(() {
                  //   selectedFieldIndex = index;
                  // });
                }
              },
              selectedColor: Colors.green[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.green : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
