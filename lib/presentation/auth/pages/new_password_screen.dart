
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/button/basic_app_button.dart';
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
      appBar:  AppBar(
        title: const Text("Reset Password"),
        centerTitle: false,
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enter the token you received via email and set your new password.",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                          label: Text("New Password"),

                          suffixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: const InputDecoration(
                          label: Text("Confirm Password"),
                          suffixIcon: Icon(Icons.lock_outline),

                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
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
                            return BasicAppButton(
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
                                        'password': newPasswordController.text,
                                      });
                                }
                              },
                              isLoading: state is ButtonLoadingState,
                              width: 353,
                              title: "Reset Password",
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
