import 'package:agriflow/common/helpers/alert_dialog.dart';
import 'package:agriflow/common/widgets/snack_bar/custom_snack_bar.dart';
import 'package:agriflow/domain/usecases/field/delete_field.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/dashboard/widgets/parameter_card.dart';
import 'package:agriflow/service_locator.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load fields once when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FieldsCubit>().loadFields();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocBuilder<FieldsCubit, FieldsState>(
        builder: (context, state) {
          if (state is FieldsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
            );
          }

          if (state is FieldsLoaded) {
            if (state.fields.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              color: const Color(0xFF2E7D32),
              onRefresh: () async {
                context.read<FieldsCubit>().loadFields();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.fields.length,
                itemBuilder: (context, index) {
                  final field = state.fields[index];
                  return FieldCard(
                    key: ValueKey(field.id),
                    field: field,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.grass_outlined, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            "No Fields Available",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Add fields to start monitoring your crops",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class FieldCard extends StatefulWidget {
  final dynamic field;

  const FieldCard({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<FieldCard> createState() => _FieldCardState();
}

class _FieldCardState extends State<FieldCard> {
  bool isExpanded = false;

  // Format values with consistent units
  String formatValue(dynamic value, {String unit = ''}) {
    if (value == null) return '-$unit';

    if (value is num) {
      // Handle NaN or infinite values
      if (value.isNaN || value.isInfinite) return '-$unit';

      // Format with one decimal place and remove trailing zeros
      String formatted = value
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');

      return '$formatted$unit';
    }

    return '$value$unit';
  }

  String _getCurrentCrop() {
    try {
      final crop = widget.field.currentCrop;
      if (crop != null &&
          crop.toString().isNotEmpty &&
          crop.toString().toLowerCase() != "none") {
        return crop.toString();
      }
      return "Not planted";
    } catch (e) {
      debugPrint("Error accessing current crop: $e");
      return "Not planted";
    }
  }

  Color _getStatusColor() {
    final moisture = widget.field.sensorReadings?.moisture ?? 0;
    if (moisture < 30) return Colors.red;
    if (moisture < 60) return Colors.orange;
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    final currentCrop = _getCurrentCrop();
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Field name row with actions
                  _buildFieldHeader(currentCrop, statusColor),

                  // Key readings when collapsed
                  if (!isExpanded) ...[
                    const SizedBox(height: 16),
                    _buildKeyReadings(),
                  ],

                  // Expand/collapse button
                  const SizedBox(height: 8),
                  _buildExpandCollapseButton(),
                ],
              ),
            ),
          ),

          // Expanded content
          AnimatedCrossFade(
            firstCurve: Curves.easeOutQuad,
            secondCurve: Curves.easeInQuad,
            sizeCurve: Curves.easeInOutQuad,
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(height: 0),
            secondChild: _buildExpandedContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldHeader(String currentCrop, Color statusColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(Icons.grass, color: statusColor),
        ),
        const SizedBox(width: 12),
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
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
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
                          size: 12,
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
            ],
          ),
        ),
        // Options menu
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey[600],
          ),
          onSelected: (value) {
            _confirmDelete(context);
          },
          itemBuilder: (context) => [
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
    );
  }

  Widget _buildKeyReadings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildKeyReadingItem(
          "Moisture",
          formatValue(widget.field.sensorReadings?.moisture, unit: '%'),
          Icons.water_drop,
          Colors.blue,
        ),
        _buildKeyReadingItem(
          "Temperature",
          formatValue(widget.field.sensorReadings?.temperature, unit: '°C'),
          Icons.thermostat,
          Colors.orange,
        ),
        _buildKeyReadingItem(
          "pH",
          formatValue(widget.field.sensorReadings?.pH),
          Icons.science,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildExpandCollapseButton() {
    return Center(
      child: Container(
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyReadingItem(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
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

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 16),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: const [
                    Tab(text: "Readings"),
                    Tab(text: "Climate"),
                    Tab(text: "Nutrients"),
                  ],
                  labelColor: const Color(0xFF2E7D32),
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: const Color(0xFF2E7D32),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSensorReadingsView(),
                      _buildClimateView(),
                      _buildNutrientsView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorReadingsView() {
    final sensorReadings = widget.field.sensorReadings;
    if (sensorReadings == null) {
      return const Center(
        child: Text("No sensor readings available"),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ParameterCard(
          title: 'Moisture',
          value: formatValue(sensorReadings.moisture, unit: '%'),
          icon: Icons.water_drop,
          color: Colors.blue,
        ),
        ParameterCard(
          title: 'Temperature',
          value: formatValue(sensorReadings.temperature, unit: '°C'),
          icon: Icons.thermostat,
          color: Colors.orange,
        ),
        ParameterCard(
          title: 'pH',
          value: formatValue(sensorReadings.pH),
          icon: Icons.science,
          color: Colors.purple,
        ),
        ParameterCard(
          title: 'Nitrogen',
          value: formatValue(sensorReadings.nitrogen, unit: ' mg/kg'),
          icon: Icons.grass,
          color: Colors.green,
        ),
        ParameterCard(
          title: 'Phosphorus',
          value: formatValue(sensorReadings.phosphorus, unit: ' mg/kg'),
          icon: Icons.grass,
          color: Colors.green.shade700,
        ),
        ParameterCard(
          title: 'Potassium',
          value: formatValue(sensorReadings.potassium, unit: ' mg/kg'),
          icon: Icons.grass,
          color: Colors.green.shade900,
        ),
      ],
    );
  }

  Widget _buildClimateView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildClimateItem(
                "Annual Rainfall",
                formatValue(widget.field.annualRainfall, unit: ' mm'),
                Icons.water,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNutrientsView() {
    final nutrients = widget.field.nutrientsNeeded;
    if (nutrients == null) {
      return const Center(
        child: Text("No nutrient data available"),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildNutrientItem(
                "N",
                "Nitrogen",
                formatValue(nutrients.nitrogen, unit: ' kg/ha'),
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNutrientItem(
                "P",
                "Phosphorus",
                formatValue(nutrients.phosphorus, unit: ' kg/ha'),
                Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNutrientItem(
                "K",
                "Potassium",
                formatValue(nutrients.potassium, unit: ' kg/ha'),
                Colors.green.shade900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClimateItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
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

  Widget _buildNutrientItem(
      String symbol, String name, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
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
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDeleteConfirmationDialog(
      context: context,
      title: const Text("Delete Field"),
      content: Text(
        'Are you sure you want to delete the field "${widget.field.fieldName}"?',
      ),
      onDelete: () async {
        final result = await sl<DeleteFieldUsecase>().call(
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
            context.read<FieldsCubit>().loadFields();
            CustomSnackBar.show(
              context: context,
              message: data,
              isError: false,
            );
          },
        );
      },
    );
  }
}
