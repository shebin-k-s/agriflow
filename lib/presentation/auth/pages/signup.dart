import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/helpers/navigation.dart';
import '../../../common/widgets/snack_bar/custom_snack_bar.dart';
import '../../../data/models/auth/auth_req_params.dart';
import '../../../domain/usecases/auth/send_otp.dart';
import '../../../domain/usecases/auth/signup.dart';
import '../../../service_locator.dart';
import '../cubit/button/button_cubit.dart';
import '../cubit/email_veify/email_verify_cubit.dart';
import '../widgets/basic_text_form_field.dart';
import 'otp_screen.dart';
import 'signin.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();

    final TextEditingController emailController =
        TextEditingController(text: "sshebi71@gmail.com");
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ButtonCubit(),
          ),
          BlocProvider(
            create: (context) => EmailVerifyCubit(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ButtonCubit, ButtonState>(
              listener: (context, state) {
                if (state is ButtonSuccessState) {
                  CustomSnackBar.show(
                    context: context,
                    message: state.message,
                    isError: false,
                  );
                  return AppNavigator.pushReplacement(
                      context, const SigninScreen());
                }
              },
            ),
            BlocListener<EmailVerifyCubit, EmailVerifyState>(
              listener: (context, state) {
                if (state is OtpSend) {
                  CustomSnackBar.show(
                    context: context,
                    message: state.message,
                    isError: false,
                  );
                  return AppNavigator.push(
                    context,
                    OtpScreen(
                      resendOtp: () => sl<SendOtpUseCase>().call(
                        param: {
                          "email": emailController.text,
                        },
                      ),
                      onSuccess: () =>
                          context.read<EmailVerifyCubit>().onVerified(),
                    ),
                  );
                }
                if (state is EmailNotVerified) {
                  CustomSnackBar.show(
                    context: context,
                    message: state.message,
                    isError: true,
                  );
                }
              },
            ),
          ],
          child: Stack(
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
                            Column(
                              children: [
                                const Text(
                                  'Join AgriFlow 🌱',
                                  style: TextStyle(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  'Create your account',
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
                              key: formkey,
                              child: Column(
                                children: [
                                  BlocBuilder<EmailVerifyCubit,
                                      EmailVerifyState>(
                                    builder: (context, state) {
                                      return BasicTextFormField(
                                        controller: emailController,
                                        enableField: state is! EmailVerified,
                                        suffixIcon: Icons.mail_outline,
                                        suffixWidget: GestureDetector(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();

                                            if (state is! EmailVerified &&
                                                state is! VerifyLoading) {
                                              if (emailController
                                                  .text.isEmpty) {
                                                CustomSnackBar.show(
                                                  context: context,
                                                  message:
                                                      "Please enter an email to verify.",
                                                  isError: true,
                                                );
                                                return;
                                              }
                                              context
                                                  .read<EmailVerifyCubit>()
                                                  .verifyEmail(
                                                      emailController.text);
                                            }
                                          },
                                          child: state is VerifyLoading
                                              ? const Padding(
                                                  padding: EdgeInsets.all(16),
                                                  child: SizedBox(
                                                    width: 4,
                                                    height: 4,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xFF388E3C),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 16),
                                                  child: Text(
                                                    state is EmailVerified
                                                        ? "Verified"
                                                        : "Verify",
                                                    style: TextStyle(
                                                      color: state
                                                              is EmailVerified
                                                          ? Color(0xFF388E3C)
                                                          : Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        label: "Email Address",
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email cannot be empty";
                                          }
                                          return null;
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  BasicTextFormField(
                                    controller: nameController,
                                    suffixIcon: Icons.person_outline,
                                    label: "Full Name",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Name cannot be empty";
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
                                      if (value != passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                  ),
                                  BlocBuilder<ButtonCubit, ButtonState>(
                                    builder: (context, state) {
                                      if (state is ButtonFailureState) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            state.message,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  BlocBuilder<ButtonCubit, ButtonState>(
                                    builder: (context, state) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final emailVerifyState = context
                                                .read<EmailVerifyCubit>()
                                                .state;
                                            if (emailVerifyState
                                                is! EmailVerified) {
                                              CustomSnackBar.show(
                                                context: context,
                                                message:
                                                    "Please verify your email before signing up.",
                                                isError: true,
                                              );
                                              return;
                                            }
                                            if (formkey.currentState!
                                                    .validate() &&
                                                state is! ButtonLoadingState) {
                                              FocusScope.of(context).unfocus();

                                              final sharedPref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              final sessionId = sharedPref
                                                  .getString("SESSIONID");

                                              context
                                                  .read<ButtonCubit>()
                                                  .execute(
                                                    usecase:
                                                        sl<SignupUseCase>(),
                                                    params: AuthReqParams(
                                                      sessionId: sessionId,
                                                      name: nameController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                    ),
                                                  );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            backgroundColor: const Color(
                                                0xFF388E3C), 
                                          ),
                                          child: state is ButtonLoadingState
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : const Text(
                                                  "SIGN UP",
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
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    AppNavigator.pushReplacement(
                                        context, const SigninScreen());
                                  },
                                  child: Text(
                                    "Login",
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
