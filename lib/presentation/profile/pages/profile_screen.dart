import 'package:agriflow/common/helpers/navigation.dart';
import 'package:agriflow/common/widgets/button/basic_app_button.dart';
import 'package:agriflow/presentation/auth/pages/signin.dart';
import 'package:agriflow/presentation/dashboard/bloc/cubit/fields_cubit.dart';
import 'package:agriflow/presentation/profile/bloc/user_details/user_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserDetailsCubit>().loadUserDetails();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // User Details
            BlocBuilder<UserDetailsCubit, UserDetailsState>(
              builder: (context, state) {
                final String name =
                    state is UserDetailsLoaded ? state.fullName : "Loading...";
                final String email =
                    state is UserDetailsLoaded ? state.email : "Loading...";

                return Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Farm Information (Dynamic)
            BlocBuilder<FieldsCubit, FieldsState>(
              builder: (context, state) {
                if (state is FieldsLoaded) {
                  return _buildProfileSection(
                    'Farm Information',
                    [
                      'Total Fields: ${state.fields.length}',
                      'Active Crops: ${state.fields.map((e) => e.currentCrop).join(", ")}',
                    ],
                  );
                } else {
                  return _buildProfileSection(
                    'Farm Information',
                    ['Loading fields...'],
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // Logout Button
            BasicAppButton(
              backgroundColor: Colors.green[700],
              onPressed: () async {
                _logout(context);
              },
              title: "Logout",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<String> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
    context.read<FieldsCubit>().reset();

    // Close loading dialog
    Navigator.pop(context);

    // Navigate to Sign In
    AppNavigator.pushAndRemoveUntil(context, const SigninScreen());
  }
}
