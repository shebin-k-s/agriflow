import 'package:agriflow/presentation/crops/bloc/recommendation/recommendation_cubit.dart';
import 'package:agriflow/presentation/crops/widgets/field_selector.dart';
import 'package:agriflow/presentation/crops/widgets/field_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/field_selector/field_selector_cubit.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RecommendationCubit>().loadRecommendation();
    return BlocBuilder<RecommendationCubit, RecommendationState>(
      builder: (context, cropsState) {
        if (cropsState is RecommendationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (cropsState is RecommendationLoaded) {
          final recommendations = cropsState.recommendation;
          return BlocBuilder<FieldSelectorCubit, FieldSelectorState>(
            builder: (context, selectorState) {
              int selectedIndex = selectorState is FieldSelector
                  ? selectorState.selectedIndex
                  : 0;

              final selectedField = recommendations[selectedIndex];

              return Column(
                children: [
                  FieldSelectorView(
                    selectedIndex: selectedIndex,
                    fields:recommendations
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        final crop =
                            recommendations[selectedIndex].crops[index];

                        return FieldView(
                          crops: crop,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }

        return const Center(
          child: Text('No recommendations available.'),
        );
      },
    );
  }
}
