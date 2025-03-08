import 'package:agriflow/common/widgets/button/basic_app_button.dart';
import 'package:agriflow/presentation/auth/cubit/button/button_cubit.dart';
import 'package:agriflow/presentation/auth/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController =
        TextEditingController(text: "sshebi71@gmail.com");

    final TextEditingController passwordController = TextEditingController(text: "shebin");

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
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Enter your credentials to continue',
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
                              BasicTextFormField(
                                controller: emailController,
                                suffixIcon: Icons.mail,
                                label: "Email id",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email cannot be empty";
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 16.0),
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
                              const SizedBox(height: 16.0),
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
                                    onPressed: () {
                                      if (formkey.currentState!.validate() &&
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
                                    isLoading: state is ButtonLoadingState,
                                    title: "LOGIN",
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
                                context, const SignupScreen());
                          },
                          child: Text(
                            'Don\'t have an account? Sign up',
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
    );
  }
}
