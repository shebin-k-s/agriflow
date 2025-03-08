import 'dart:developer';

import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/fields/widgets/field_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FieldsCubit>().loadFields();
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FieldsCubit>().loadFields();
      },
      child: BlocBuilder<FieldsCubit, FieldsState>(
        builder: (context, state) {
          if (state is FieldsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FieldsLoaded) {
            log(state.fields.length.toString());
            if (state.fields.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(
                    child: Text(
                      "No Fields Exist",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            }
            final fields = state.fields;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          child: const Icon(Icons.grass, color: Colors.green),
                        ),
                        title: Text(field.fieldName),
                        subtitle: const Text(
                          'Active • Not connected',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FieldStatus(
                              label: 'Moisture',
                              value: field.sensorReadings.moisture.toString(),
                              icon: Icons.water_drop,
                            ),
                            FieldStatus(
                              label: 'Temperature',
                              value: field.sensorReadings.temperature.toString(),
                              icon: Icons.thermostat,
                            ),
                            FieldStatus(
                              label: 'pH',
                              value: field.sensorReadings.pH.toString(),
                              icon: Icons.science,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
