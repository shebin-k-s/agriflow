import 'dart:developer';

import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/dashboard/widgets/field_card.dart';
import 'package:agriflow/presentation/dashboard/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FieldsCubit>().loadFields();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WeatherCard(),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Field Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is FieldsLoaded) {
                log("fields loaded");
                if (state.fields.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
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
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return FieldCard(
                      field: fields[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                  itemCount: fields.length,
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
