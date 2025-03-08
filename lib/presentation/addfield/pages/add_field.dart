import 'dart:developer';

import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:agriflow/domain/usecases/field/add_field.dart';
import 'package:agriflow/presentation/auth/cubit/button/button_cubit.dart';
import 'package:agriflow/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/snack_bar/custom_snack_bar.dart';

class AddFieldScreen extends StatelessWidget {
  const AddFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final fieldNameController = TextEditingController(text: "field 1");

    final deviceIdController = TextEditingController(text: "device 1");

    final serialNumberController = TextEditingController(text: "serial 1");

    return BlocListener<ButtonCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            isError: false,
          );
          return Navigator.of(context).pop();
        }
        if (state is ButtonFailureState) {
          log(state.message);
          CustomSnackBar.show(
            context: context,
            message: state.message,
            isError: true,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Field'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: fieldNameController,
                          decoration: InputDecoration(
                            labelText: 'Field Name',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter field name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Device Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: deviceIdController,
                          decoration: InputDecoration(
                            labelText: 'Device ID',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter device ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: serialNumberController,
                          decoration: InputDecoration(
                            labelText: 'Serial Number',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter serial number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: BlocBuilder<ButtonCubit, ButtonState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate() &&
                                      state is! ButtonLoadingState) {
                                    FocusScope.of(context).unfocus();
                                    context.read<ButtonCubit>().execute(
                                          usecase: sl<AddFieldUsecase>(),
                                          params: FieldReqParams(
                                            deviceId: deviceIdController.text,
                                            fieldName: fieldNameController.text,
                                            serialNumber:
                                                serialNumberController.text,
                                          ),
                                        );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: state is ButtonLoadingState
                                    ? const CircularProgressIndicator()
                                    : const Text('Add Field'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
