import 'package:agriflow/domain/entities/field/field.dart';
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
  final List<FieldData> fields;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fields.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final field = fields[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () =>
                  context.read<FieldSelectorCubit>().selectField(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green[600] : Colors.grey[200],
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Colors.green, Colors.teal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 3,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(field.fieldName),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
