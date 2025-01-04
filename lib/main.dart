import 'package:agriflow/presentation/auth/pages/signin.dart';
import 'package:agriflow/presentation/crops/bloc/field_selector/field_selector_cubit.dart';
import 'package:agriflow/presentation/crops/bloc/recommendation/recommendation_cubit.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/main/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FieldsCubit(),
        ),
        BlocProvider(
          create: (context) => RecommendationCubit(),
        ),
        BlocProvider(
          create: (context) => FieldSelectorCubit(),
        )
      ],
      child: MaterialApp(
        home: SigninScreen(),
      ),
    );
  }
}
