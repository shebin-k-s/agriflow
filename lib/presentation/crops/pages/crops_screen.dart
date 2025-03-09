import 'dart:developer';

import 'package:agriflow/common/widgets/snack_bar/custom_snack_bar.dart';
import 'package:agriflow/domain/usecases/field/predict_crop.dart';
import 'package:agriflow/presentation/auth/cubit/button/button_cubit.dart';
import 'package:agriflow/presentation/crops/widgets/field_selector.dart';
import 'package:agriflow/presentation/crops/widgets/field_view.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/field_selector/field_selector_cubit.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Set<String> predictingCropList = {};
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FieldsCubit>().loadFields();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<FieldsCubit, FieldsState>(
                builder: (context, cropsState) {
                  if (cropsState is FieldsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (cropsState is! FieldsLoaded) {
                    return const Center(
                      child: Text(
                        "Failed to load fields.",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  final fields = cropsState.fields;

                  if (fields.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.agriculture, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "You don't have any fields.",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }

                  return BlocBuilder<FieldSelectorCubit, FieldSelectorState>(
                    builder: (context, selectorState) {
                      int selectedIndex = selectorState is FieldSelector
                          ? selectorState.selectedIndex
                          : 0;
                      final selectedField = fields[selectedIndex];
                      final lastUpdated =
                          selectedField.cropRecommendationsLastUpdated;

                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          FieldSelectorView(
                            selectedIndex: selectedIndex,
                            fields: fields,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Updated: ${lastUpdated != null ? lastUpdated.toLocal().toString().split('.')[0] : "Never"}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  BlocListener<ButtonCubit, ButtonState>(
                                    listener: (context, state) {
                                      if (state is ButtonSuccessState) {
                                        context
                                            .read<FieldsCubit>()
                                            .loadFields();
                                        CustomSnackBar.show(
                                          context: context,
                                          message: "Prediction successful!",
                                          isError: false,
                                        );
                                        predictingCropList
                                            .remove(state.message);
                                      } else if (state is ButtonFailureState) {
                                        CustomSnackBar.show(
                                          context: context,
                                          message: "Prediction Failed!",
                                          isError: true,
                                        );
                                        predictingCropList
                                            .remove(state.message);
                                      }
                                    },
                                    child:
                                        BlocBuilder<ButtonCubit, ButtonState>(
                                      builder: (context, state) {
                                        log(predictingCropList.toString());
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green[700],
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: state is ButtonLoadingState &&
                                                    predictingCropList.contains(
                                                        fields[selectedIndex]
                                                            .id)
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Icon(Icons.refresh,
                                                    size: 20),
                                            label: Text(
                                              state is ButtonLoadingState &&
                                                      predictingCropList
                                                          .contains(fields[
                                                                  selectedIndex]
                                                              .id)
                                                  ? "Predicting..."
                                                  : "Predict Crops",
                                            ),
                                            onPressed: state
                                                        is ButtonLoadingState &&
                                                    predictingCropList.contains(
                                                        fields[selectedIndex]
                                                            .id)
                                                ? null
                                                : () {
                                                    predictingCropList.add(
                                                        fields[selectedIndex]
                                                            .id);

                                                    print(predictingCropList);
                                                    context
                                                        .read<ButtonCubit>()
                                                        .execute(
                                                          usecase: sl<
                                                              PredictFieldCropsUsecase>(),
                                                          params: fields[
                                                                  selectedIndex]
                                                              .id,
                                                        );
                                                  },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: selectedField.cropRecommendations.isNotEmpty
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: selectedField
                                        .cropRecommendations.length,
                                    itemBuilder: (context, index) {
                                      final crop = selectedField
                                          .cropRecommendations[index];
                                      return FieldView(
                                        crop: crop,
                                        isCurrentCrop:
                                            selectedField.currentCrop ==
                                                crop.crop,
                                        fieldId: selectedField.id,
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      'No recommendations available.',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
