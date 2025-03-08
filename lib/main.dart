import 'package:agriflow/presentation/auth/cubit/button/button_cubit.dart';
import 'package:agriflow/presentation/crops/bloc/field_selector/field_selector_cubit.dart';
import 'package:agriflow/presentation/crops/bloc/recommendation/recommendation_cubit.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/main/pages/main_screen.dart';
import 'package:agriflow/presentation/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/profile/bloc/user_details/user_details_cubit.dart';
import 'service_locator.dart';

void main() {
  setupServiceLocator();

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
          create: (context) => ButtonCubit(),
        ),
        BlocProvider(
          create: (context) => RecommendationCubit(),
        ),
        BlocProvider(
          create: (context) => FieldSelectorCubit(),
        ),
        BlocProvider(
          create: (context) => UserDetailsCubit(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
