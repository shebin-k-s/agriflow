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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
          BlocBuilder<UserDetailsCubit, UserDetailsState>(
            builder: (context, state) {
              final String name =
                  state is UserDetailsLoaded ? state.fullName : "....";
              final String email =
                  state is UserDetailsLoaded ? state.email : "....";
              return Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
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
          _buildProfileSection(
            'Farm Information',
            [
              'Total Fields: 3',
              'Active Crops: Cotton, Wheat, Rice',
            ],
          ),
          const SizedBox(height: 16),
          BasicAppButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              final sharedPref = await SharedPreferences.getInstance();
              await sharedPref.clear();
              context.read<FieldsCubit>().reset();
              AppNavigator.pushAndRemoveUntil(
                context,
                const SigninScreen(),
              );
            },
            title: "Logout",
          )
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<String> items) {
    return Card(
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
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
}
