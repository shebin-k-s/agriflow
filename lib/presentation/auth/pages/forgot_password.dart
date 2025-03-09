import 'package:agriflow/presentation/auth/pages/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/helpers/navigation.dart';
import '../../../common/widgets/snack_bar/custom_snack_bar.dart';
import '../../../domain/usecases/auth/forgot_password.dart';
import '../../../service_locator.dart';
import '../cubit/button/button_cubit.dart';
import 'new_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
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
                message: state.message,
                isError: false,
              );
              AppNavigator.pushReplacement(
                context,
                OtpScreen(
                  resendOtp: () => sl<ForgotPasswordUseCase>().call(
                    param: {
                      "email": emailController.text,
                    },
                  ),
                  onSuccessNavigation: const NewPasswordScreen(),
                ),
              );
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
                    "Forgot Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Color(0xFF2E7D32), // Green color from SigninScreen
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enter your registered email address to receive a password reset token.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<ButtonCubit, ButtonState>(
                    builder: (context, state) {
                      return Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                label: Text("Email Address"),
                                suffixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Color(0xFF388E3C),
                                ),
                                labelStyle: TextStyle(
                                  color: Color(0xFF388E3C),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF388E3C),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate() &&
                                      state is! ButtonLoadingState) {
                                    FocusScope.of(context).unfocus();
                                    context.read<ButtonCubit>().execute(
                                      usecase: sl<ForgotPasswordUseCase>(),
                                      params: {
                                        'email': emailController.text,
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: const Color(0xFF388E3C), // Deep Green from SigninScreen
                                ),
                                child: state is ButtonLoadingState
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "SEND OTP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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