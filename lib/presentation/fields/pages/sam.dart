import 'dart:developer';

import 'package:agriflow/common/helpers/alert_dialog.dart';
import 'package:agriflow/common/widgets/snack_bar/custom_snack_bar.dart';
import 'package:agriflow/domain/usecases/field/delete_field.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/fields/widgets/field_status.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FieldsCubit>().loadFields();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Your Fields",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            onPressed: () => context.read<FieldsCubit>().loadFields(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Field Management",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Monitor your fields' health and get crop recommendations",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Fields List
          Expanded(
            child: RefreshIndicator(
              color: Colors.green,
              onRefresh: () async {
                context.read<FieldsCubit>().loadFields();
              },
              child: BlocBuilder<FieldsCubit, FieldsState>(
                builder: (context, state) {
                  if (state is FieldsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
                  }

                  if (state is FieldsLoaded) {
                    if (state.fields.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.grass_outlined,
                                size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              "No Fields Available",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Add fields to start monitoring your crops",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final fields = state.fields;

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: fields.length,
                      itemBuilder: (context, index) {
                        final field = fields[index];
                        return ExpandableFieldCard(field: field);
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          // Implement add field functionality
        },
      ),
    );
  }
}

class ExpandableFieldCard extends StatefulWidget {
  final dynamic field;

  const ExpandableFieldCard({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<ExpandableFieldCard> createState() => _ExpandableFieldCardState();
}

class _ExpandableFieldCardState extends State<ExpandableFieldCard> {
  bool isExpanded = false;

  // Helper method to format values with consistent units
  String formatValue(dynamic value, {String unit = ''}) {
    if (value == null) return '0$unit';

    if (value is num) {
      String formatted = value.toStringAsFixed(1);
      // Remove trailing zeros and decimal point if not needed
      if (formatted.contains('.')) {
        formatted = formatted.replaceAll(RegExp(r'0*$'), '');
        formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      }
      return '$formatted$unit';
    }

    return '$value$unit';
  }

  @override
  Widget build(BuildContext context) {
    // Safely access crop recommendations, check if it exists and is not empty
    final hasCropRecommendations = widget.field.cropRecommendations != null &&
        widget.field.cropRecommendations.isNotEmpty;

    // Simplified and more direct current crop access
    String currentCrop = "Not planted";
    try {
      if (widget.field.currentCrop != null &&
          widget.field.currentCrop.toString().isNotEmpty &&
          widget.field.currentCrop.toString() != "None") {
        currentCrop = widget.field.currentCrop.toString();
      }
    } catch (e) {
      print("Error accessing current crop: $e");
    }

    // Determine status color based on moisture level
    final moisture = widget.field.sensorReadings?.moisture ?? 0;
    final statusColor = moisture < 30
        ? Colors.red
        : moisture < 60
            ? Colors.orange
            : Color(0xFF4CAF50); // A nice green shade

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Field Header (always visible)
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: statusColor,
                      width: 4,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: statusColor.withOpacity(0.1),
                            child: Icon(Icons.grass, color: statusColor),
                          ),
                          if (hasCropRecommendations)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.recommend,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.field.fieldName ?? "Unnamed Field",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF2E7D32),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.spa,
                                    size: 14,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    currentCrop,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Summary readings
                      if (!isExpanded)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCompactSummaryItem(
                              Icons.water_drop,
                              formatValue(widget.field.sensorReadings?.moisture,
                                  unit: '%'),
                              Colors.blue,
                            ),
                            SizedBox(width: 8),
                            _buildCompactSummaryItem(
                              Icons.thermostat,
                              formatValue(
                                  widget.field.sensorReadings?.temperature,
                                  unit: '°C'),
                              Colors.orange,
                            ),
                          ],
                        ),
                      SizedBox(width: 8),
                      // Expand/collapse and options
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey[600],
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                showDeleteConfirmationDialog(
                                  context: context,
                                  title: const Text("Delete Field"),
                                  content: Text(
                                    'Are you sure you want to delete the Field ${widget.field.fieldName}?',
                                  ),
                                  onDelete: () async {
                                    Either result =
                                        await sl<DeleteFieldUsecase>().call(
                                      param: widget.field.id,
                                    );

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
                              } else if (value == 'edit') {
                                // Implement edit functionality
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: "edit",
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text("Edit Field"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: "delete",
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text("Delete Field"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Expandable Content
            if (isExpanded)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                color: Color(0xFFF9F9F9),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Readings Card
                      _buildSensorReadingsCard(),
                      const SizedBox(height: 16),

                      // Climate Data Card
                      _buildClimateDataCard(),
                      const SizedBox(height: 16),

                      // Nutrients Needed Card
                      _buildNutrientsCard(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSummaryItem(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorReadingsCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, size: 20, color: Color(0xFF2E7D32)),
                SizedBox(width: 8),
                Text(
                  "Current Readings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildReadingItem(
                  "Moisture",
                  formatValue(widget.field.sensorReadings?.moisture, unit: '%'),
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildReadingItem(
                  "Temperature",
                  formatValue(widget.field.sensorReadings?.temperature,
                      unit: '°C'),
                  Icons.thermostat,
                  Colors.orange,
                ),
                _buildReadingItem(
                  "pH",
                  formatValue(widget.field.sensorReadings?.pH),
                  Icons.science,
                  Colors.purple,
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade200),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildReadingItem(
                  "Nitrogen",
                  formatValue(widget.field.sensorReadings?.nitrogen,
                      unit: ' ppm'),
                  Icons.grass,
                  Colors.green,
                ),
                _buildReadingItem(
                  "Phosphorus",
                  formatValue(widget.field.sensorReadings?.phosphorus,
                      unit: ' ppm'),
                  Icons.grass,
                  Colors.green.shade700,
                ),
                _buildReadingItem(
                  "Potassium",
                  formatValue(widget.field.sensorReadings?.potassium,
                      unit: ' ppm'),
                  Icons.grass,
                  Colors.green.shade900,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingItem(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClimateDataCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud, size: 20, color: Colors.blue.shade700),
                SizedBox(width: 8),
                Text(
                  "Climate Data",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildClimateItem(
                    "Annual Rainfall",
                    formatValue(widget.field.annualRainfall, unit: ' mm'),
                    Icons.water,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildClimateItem(
                    "Annual Temperature",
                    formatValue(widget.field.annualTemperature, unit: '°C'),
                    Icons.thermostat,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClimateItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientsCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.biotech, size: 20, color: Colors.green.shade700),
                SizedBox(width: 8),
                Text(
                  "Nutrients Needed",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Grid layout for nutrients
            Row(
              children: [
                Expanded(
                  child: _buildNutrientItem(
                    "N",
                    "Nitrogen",
                    formatValue(widget.field.nutrientsNeeded?.nitrogen,
                        unit: ' kg/ha'),
                    Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildNutrientItem(
                    "P",
                    "Phosphorus",
                    formatValue(widget.field.nutrientsNeeded?.phosphorus,
                        unit: ' kg/ha'),
                    Colors.green.shade700,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildNutrientItem(
                    "K",
                    "Potassium",
                    formatValue(widget.field.nutrientsNeeded?.potassium,
                        unit: ' kg/ha'),
                    Colors.green.shade900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientItem(
      String symbol, String name, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Text(
              symbol,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
