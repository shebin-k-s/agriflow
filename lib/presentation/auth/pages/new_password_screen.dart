import 'package:agriflow/presentation/auth/widgets/basic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/snack_bar/custom_snack_bar.dart';
import '../../../domain/usecases/auth/reset_password.dart';
import '../../../service_locator.dart';
import '../cubit/button/button_cubit.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Color(0xFF2E7D32), // Green color for back button
        ),
      ),
      body: BlocProvider(
        create: (context) => ButtonCubit(),
        child: BlocListener<ButtonCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              CustomSnackBar.show(
                context: context,
                message: "Password reset successfully!",
                isError: false,
              );
              Navigator.pop(context);
            } else if (state is ButtonFailureState) {
              CustomSnackBar.show(
                context: context,
                message: state.message,
                isError: true,
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color:
                          Color(0xFF2E7D32), // Green color from other screens
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enter the token you received via email and set your new password.",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Colors.black54, // Matching style from other screens
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        BasicTextFormField(
                          controller: newPasswordController,
                          suffixIcon: Icons.lock_outline,
                          label: "Password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        BasicTextFormField(
                          controller: confirmPasswordController,
                          suffixIcon: Icons.lock_outline,
                          label: "Confirm Password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm Password cannot be empty";
                            }
                            if (value != newPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<ButtonCubit, ButtonState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate() &&
                                      state is! ButtonLoadingState) {
                                    FocusScope.of(context).unfocus();
                                    final sharedPref =
                                        await SharedPreferences.getInstance();
                                    final sessionId =
                                        sharedPref.getString("SESSIONID");
                                    context.read<ButtonCubit>().execute(
                                        usecase: sl<ResetPasswordUsecase>(),
                                        params: {
                                          'sessionId': sessionId,
                                          'password':
                                              newPasswordController.text,
                                        });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: const Color(
                                      0xFF388E3C), // Deep Green from other screens
                                ),
                                child: state is ButtonLoadingState
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "RESET PASSWORD",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
