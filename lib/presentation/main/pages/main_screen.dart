import 'package:agriflow/presentation/addfield/pages/add_field.dart';
import 'package:agriflow/presentation/crops/pages/crops_screen.dart';
import 'package:agriflow/presentation/dashboard/pages/dashboard_screen.dart';
import 'package:agriflow/presentation/fields/pages/fields_screen.dart';
import 'package:agriflow/presentation/main/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:agriflow/presentation/main/widgets/basic_bottom_navigation.dart';
import 'package:agriflow/presentation/profile/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardScreen(),
      const FieldsScreen(),
      const CropsScreen(),
      const ProfileScreen(),
    ];
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('AgriFlow'),
              forceMaterialTransparency: true,
            ),
            body: pages[state.selectedIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddFieldScreen(),
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BasicBottomNavigation(
              currentIndex: state.selectedIndex,
            ),
          );
        },
      ),
    );
  }
}
