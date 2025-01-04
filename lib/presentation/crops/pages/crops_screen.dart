import 'package:agriflow/presentation/crops/widgets/field_selector.dart';
import 'package:agriflow/presentation/crops/widgets/field_view.dart';
import 'package:flutter/material.dart';

class Field {
  final String name;
  final List<CropRecommendation> recommendations;

  Field({required this.name, required this.recommendations});
}

class CropRecommendation {
  final String cropName;
  final int percentage;
  final String description;

  CropRecommendation(
      {required this.cropName,
      required this.percentage,
      required this.description});
}

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
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

  int selectedFieldIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FieldSelector(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fields[selectedFieldIndex].recommendations.length,
            itemBuilder: (context, index) {
              final recommendation =
                  fields[selectedFieldIndex].recommendations[index];

              return FieldView(
                recommendation: recommendation,
              );
            },
          ),
        ),
      ],
    );
  }
}
