import 'dart:developer';

import 'package:agriflow/common/helpers/alert_dialog.dart';
import 'package:agriflow/data/models/currentCrop/current_crop_req_params.dart';
import 'package:agriflow/domain/usecases/field/set_current_crop.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agriflow/presentation/auth/cubit/button/button_cubit.dart';
import 'package:agriflow/common/widgets/snack_bar/custom_snack_bar.dart';
import 'package:agriflow/domain/entities/field/field.dart';

class FieldView extends StatelessWidget {
  const FieldView({
    super.key,
    required this.crop,
    required this.isCurrentCrop,
    required this.fieldId,
  });

  final CropRecommendation crop;
  final bool isCurrentCrop;
  final String fieldId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          log(state.toString());
          if (state is ButtonSuccessState) {
            CustomSnackBar.show(
              context: context,
              message: "Crop set successfully!",
              isError: false,
            );
          } else if (state is ButtonFailureState) {
            CustomSnackBar.show(
              context: context,
              message: state.message,
              isError: true,
            );
          }
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green[500],
                      radius: 28,
                      child: Text(
                        crop.crop[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop.crop,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Condition Match: ${(crop.conditionMatch * 100).toStringAsFixed(1)}%",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${(crop.compositeScore * 100).toStringAsFixed(2)}%",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Yield Score: ${(crop.yieldScore * 100).toStringAsFixed(1)}%",
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: crop.compositeScore,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(Colors.green[500]!),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ButtonCubit, ButtonState>(
                  builder: (context, state) {
                    log(state.toString());
                    return Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: isCurrentCrop || state is ButtonLoadingState
                            ? null
                            : () async {
                                return showDeleteConfirmationDialog(
                                  context: context,
                                  title: const Text("Set As Current Crop"),
                                  acceptButtontitle: "Save",
                                  content: Text(
                                    'Are you sure you want to set ${crop.crop} as current crop?',
                                  ),
                                  onDelete: () async {
                                    Either result =
                                        await sl<SetCurrentCropUsecase>().call(
                                            param: CurrentCropReqParams(
                                                currentCrop: crop.crop,
                                                fieldId: fieldId));

                                    result.fold(
                                      (error) {
                                        CustomSnackBar.show(
                                          context: context,
                                          message: error,
                                          isError: true,
                                        );
                                      },
                                      (data) {
                                        context
                                            .read<FieldsCubit>()
                                            .loadFields();
                                        CustomSnackBar.show(
                                          context: context,
                                          message: data,
                                          isError: false,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCurrentCrop
                              ? Colors.green[100]
                              : Colors.green[600],
                          foregroundColor:
                              isCurrentCrop ? Colors.green[700] : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: isCurrentCrop ? 0 : 2,
                        ),
                        icon: state is ButtonLoadingState
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                isCurrentCrop
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                size: 20,
                                color: isCurrentCrop
                                    ? Colors.green[700]
                                    : Colors.white,
                              ),
                        label: Text(
                          isCurrentCrop
                              ? "Current Crop (Selected)"
                              : "Set as Current Crop",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isCurrentCrop
                                ? Colors.green[700]
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
