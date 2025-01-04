import 'package:agriflow/domain/entities/recommendation/crop_recommendation.dart';
import 'package:agriflow/presentation/crops/bloc/field_selector/field_selector_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldSelectorView extends StatelessWidget {
  const FieldSelectorView({
    super.key,
    required this.selectedIndex,
    required this.fields,
  });

  final int selectedIndex;
  final List<CropRecommendationEntity> fields;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fields.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final field = fields[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(field.fieldName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  context.read<FieldSelectorCubit>().selectField(index);
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
