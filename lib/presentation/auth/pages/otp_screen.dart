import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/helpers/navigation.dart';
import '../../../common/widgets/snack_bar/custom_snack_bar.dart';
import '../../../domain/usecases/auth/verify_otp.dart';
import '../../../service_locator.dart';
import '../cubit/button/button_cubit.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({
    super.key,
    required this.resendOtp,
    this.onSuccessNavigation,
    this.onSuccess,
  });
  final VoidCallback resendOtp;
  final Widget? onSuccessNavigation;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verification",
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
              if (onSuccess != null) {
                onSuccess!();
              }
              if (onSuccessNavigation != null) {
                AppNavigator.pushReplacement(context, onSuccessNavigation!);
              } else {
                Navigator.of(context).pop();
              }
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.mark_email_read_outlined,
                    size: 80,
                    color: Color(0xFF2E7D32), // Green color for icon
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Email Verification",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color:
                          Color(0xFF2E7D32), // Green color from Forgot Password
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "We've sent a verification code to your email",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Colors.black54, // Matching Forgot Password text style
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: OtpTextField(
                      numberOfFields: 5,
                      borderColor: const Color(0xFF388E3C), // Green color
                      showFieldAsBox: true,
                      margin: const EdgeInsets.only(right: 10),
                      borderWidth: 2.0,
                      fieldWidth: 50,
                      fieldHeight: 50,
                      borderRadius: BorderRadius.circular(10),
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      onSubmit: (String verificationCode) {
                        otpController.text = verificationCode;
                      },
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF388E3C), // Green color for text
                      ),
                      focusedBorderColor: const Color(
                          0xFF388E3C), // Green color for focused fields
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<ButtonCubit, ButtonState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (otpController.text.length != 5) {
                              CustomSnackBar.show(
                                context: context,
                                message: "Please Enter the otp",
                                isError: true,
                              );
                              return;
                            }
                            if (state is! ButtonLoadingState) {
                              final sharedPref =
                                  await SharedPreferences.getInstance();
                              final sessionId =
                                  sharedPref.getString("SESSIONID");
                              context.read<ButtonCubit>().execute(
                                  usecase: sl<VerifyOtpUsecase>(),
                                  params: {
                                    "otp": otpController.text,
                                    "sessionId": sessionId
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: const Color(
                                0xFF388E3C), // Deep Green from Forgot Password
                          ),
                          child: state is ButtonLoadingState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "VERIFY",
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the code? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors
                              .black54, // Matching style from Forgot Password
                        ),
                      ),
                      OtpTimer(
                        onResendClick: resendOtp,
                        textColor: const Color(
                            0xFF388E3C), // Green color for resend text
                      ),
                    ],
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

class OtpTimer extends StatefulWidget {
  const OtpTimer({
    super.key,
    required this.onResendClick,
    this.textColor = Colors.grey,
  });

  final VoidCallback onResendClick;
  final Color textColor;

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  int _remainingTime = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("i am");
    if (_remainingTime > 0) {
      return Text(
        "Resend in ${_remainingTime}s",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54, // Matching style from Forgot Password
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          startTimer();
          widget.onResendClick();
        },
        child: Text(
          "Resend",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.textColor, // Using the green color
          ),
        ),
      );
    }
  }
}
