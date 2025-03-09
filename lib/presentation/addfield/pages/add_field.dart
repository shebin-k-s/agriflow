import 'dart:developer';

import 'package:agriflow/data/models/field/field_req_params.dart';
import 'package:agriflow/domain/usecases/field/add_field.dart';
import 'package:agriflow/presentation/addfield/pages/map_screen.dart';
import 'package:agriflow/presentation/auth/cubit/button/button_cubit.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/widgets/snack_bar/custom_snack_bar.dart';

class AddFieldScreen extends StatelessWidget {
  AddFieldScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final fieldNameController = TextEditingController(text: "Field 1");
  final deviceIdController = TextEditingController(text: "Device 1");
  final serialNumberController = TextEditingController(text: "Serial 1");
  final addressController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  LatLng? selectedLocation;

  Future<void> _selectLocationOnMap(BuildContext context) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (result != null) {
      selectedLocation = result['location'] as LatLng;
      addressController.text = result['address'] as String;
    }
  }

  void _scrollToFirstError() {
    if (formKey.currentState?.validate() == false) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          context.read<FieldsCubit>().loadFields();
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
          title: const Text('Add New Field',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildSectionCard(
                  title: "Basic Information",
                  children: [
                    _buildTextField(
                      controller: fieldNameController,
                      label: "Field Name",
                      hint: "Enter field name",
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: addressController,
                      label: "Address",
                      hint: "Select location on map",
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _selectLocationOnMap(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map, size: 22),
                          SizedBox(width: 8),
                          Text("Select on Map", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: "Device Information",
                  children: [
                    _buildTextField(
                      controller: deviceIdController,
                      label: "Device ID",
                      hint: "Enter device ID",
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: serialNumberController,
                      label: "Serial Number",
                      hint: "Enter serial number",
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                BlocBuilder<ButtonCubit, ButtonState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _scrollToFirstError();
                          if (formKey.currentState!.validate() &&
                              state is! ButtonLoadingState) {
                            FocusScope.of(context).unfocus();
                            context.read<ButtonCubit>().execute(
                                  usecase: sl<AddFieldUsecase>(),
                                  params: FieldReqParams(
                                    deviceId: deviceIdController.text,
                                    fieldName: fieldNameController.text,
                                    serialNumber: serialNumberController.text,
                                    address: addressController.text,
                                    latitude: selectedLocation?.latitude,
                                    longitude: selectedLocation?.longitude,
                                  ),
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: state is ButtonLoadingState
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Add Field',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
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

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon: readOnly
            ? const Icon(Icons.location_on, color: Colors.green)
            : null,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}
