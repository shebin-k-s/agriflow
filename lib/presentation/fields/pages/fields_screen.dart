import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/fields/widgets/field_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        if (state is FieldsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FieldsLoaded) {
          final fields = state.fields;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
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
                      subtitle: Text(
                          'Active • ${field.deviceStatus ? "Connected" : "Not connected"}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
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
                            value: field.moisture.toString(),
                            icon: Icons.water_drop,
                          ),
                          FieldStatus(
                            label: 'Temperature',
                            value: field.temperature.toString(),
                            icon: Icons.thermostat,
                          ),
                          FieldStatus(
                            label: 'pH',
                            value: field.pH.toString(),
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
    );
  }
}
