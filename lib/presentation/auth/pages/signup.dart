import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/helpers/navigation.dart';
import '../../../common/widgets/button/basic_app_button.dart';
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Create an Account',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Enter your details to get started',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          Form(
                            key: formkey,
                            child: Column(
                              children: [
                                BlocBuilder<EmailVerifyCubit, EmailVerifyState>(
                                  builder: (context, state) {
                                    return BasicTextFormField(
                                      controller: emailController,
                                      enableField: state is! EmailVerified,
                                      suffixIcon: Icons.mail,
                                      suffixWidget: GestureDetector(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          if (state is! EmailVerified &&
                                              state is! VerifyLoading) {
                                            if (emailController.text.isEmpty) {
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
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                child: Text(
                                                  state is EmailVerified
                                                      ? "Verified"
                                                      : "Verify",
                                                  style: TextStyle(
                                                    color:
                                                        state is EmailVerified
                                                            ? Colors.green
                                                            : Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                      ),
                                      label: "Email id",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Email cannot be empty";
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                BasicTextFormField(
                                  controller: nameController,
                                  suffixIcon: Icons.person,
                                  label: "Full name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Name cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                BasicTextFormField(
                                  controller: passwordController,
                                  suffixIcon: Icons.lock,
                                  label: "Password",
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                BasicTextFormField(
                                  controller: confirmPasswordController,
                                  suffixIcon: Icons.lock,
                                  label: "Confirm password",
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
                                      return SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            top: 8,
                                          ),
                                          child: Text(
                                            state.message,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                          ),
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
                                    return BasicAppButton(
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
                                        if (formkey.currentState!.validate() &&
                                            state is! ButtonLoadingState) {
                                          FocusScope.of(context).unfocus();

                                          final sharedPref =
                                              await SharedPreferences
                                                  .getInstance();
                                          final sessionId =
                                              sharedPref.getString("SESSIONID");

                                          context.read<ButtonCubit>().execute(
                                                usecase: sl<SignupUseCase>(),
                                                params: AuthReqParams(
                                                  sessionId: sessionId,
                                                  name: nameController.text,
                                                  password:
                                                      passwordController.text,
                                                ),
                                              );
                                        }
                                      },
                                      isLoading: state is ButtonLoadingState,
                                      width: 353,
                                      title: "SIGN UP",
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              splashFactory: NoSplash.splashFactory,
                            ),
                            onPressed: () {
                              AppNavigator.pushReplacement(
                                  context, const SigninScreen());
                            },
                            child: Text(
                              'Already have an account? Login',
                              style: TextStyle(color: Colors.orange.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
