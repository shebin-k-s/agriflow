import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agriflow/presentation/auth/cubit/button/button_cubit.dart';
import 'package:agriflow/presentation/auth/pages/forgot_password.dart';
import 'package:agriflow/presentation/auth/pages/signup.dart';
import '../../../common/helpers/navigation.dart';
import '../../../common/widgets/snack_bar/custom_snack_bar.dart';
import '../../../data/models/auth/auth_req_params.dart';
import '../../../domain/usecases/auth/signin.dart';
import '../../../service_locator.dart';
import '../../main/pages/main_screen.dart';
import '../widgets/basic_text_form_field.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController =
        TextEditingController(text: "sshebi71@gmail.com");
    final TextEditingController passwordController =
        TextEditingController(text: "shebin");

    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) async {
          if (state is ButtonSuccessState) {
            CustomSnackBar.show(
              context: context,
              message: state.message,
              isError: false,
            );
            return AppNavigator.pushAndRemoveUntil(
              context,
              const MainScreen(),
            );
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFA7D7A3), // Soft pastel green
                      Color(0xFF3E8E41), // Deep forest green
                    ],
                  ),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      elevation: 12,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                          vertical: 36.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            /// 🌱 **Welcome Message**
                            Column(
                              children: [
                                const Text(
                                  'Welcome Back! 🌱',
                                  style: TextStyle(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  'Sign in to continue',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24.0),

                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  BasicTextFormField(
                                    controller: emailController,
                                    suffixIcon: Icons.mail_outline,
                                    label: "Email Address",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email cannot be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  BasicTextFormField(
                                    controller: passwordController,
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
                                ],
                              ),
                            ),

                            const SizedBox(height: 16.0),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  AppNavigator.push(context, const ForgotPasswordScreen());
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            BlocBuilder<ButtonCubit, ButtonState>(
                              builder: (context, state) {
                                if (state is ButtonFailureState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      state.message,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            const SizedBox(height: 16.0),

                            BlocBuilder<ButtonCubit, ButtonState>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate() &&
                                          state is! ButtonLoadingState) {
                                        FocusScope.of(context).unfocus();
                                        context.read<ButtonCubit>().execute(
                                              usecase: sl<SigninUseCase>(),
                                              params: AuthReqParams(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              ),
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
                                      backgroundColor: const Color(0xFF388E3C),
                                    ),
                                    child: state is ButtonLoadingState
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text(
                                            "LOGIN",
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

                            const SizedBox(height: 20.0),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    AppNavigator.pushReplacement(
                                        context, const SignupScreen());
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
