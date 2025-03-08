import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/password_visibility/password_visibility_cubit.dart';

class BasicTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Color? iconColor;
  final double labelSize;
  final Widget? suffixWidget;
  final bool enableField;

  const BasicTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.iconColor,
    this.labelSize = 14,
    this.suffixWidget,
    this.enableField = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordVisibilityCubit(),
      child: BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
        builder: (context, state) {
          return TextFormField(
            controller: controller,
            validator: validator,
            enabled: enableField,
            obscureText: obscureText && !state.showPassword,
            style: TextStyle(color: iconColor),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                bottom: 20,
                left: 20,
              ),
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: TextStyle(
                fontSize: labelSize,
                color: Colors.black.withOpacity(0.75),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.75),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.75),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorStyle: TextStyle(color: Colors.red.withOpacity(0.75)),
              labelStyle: TextStyle(
                fontSize: labelSize,
                color: Colors.black.withOpacity(0.75),
              ),
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      color: iconColor ?? Colors.orange.shade600,
                    ),
              suffixIcon: suffixWidget ??
                  (suffixIcon == null
                      ? null
                      : obscureText
                          ? IconButton(
                              icon: Icon(
                                state.showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.orange.shade600,
                              ),
                              onPressed: () => context
                                  .read<PasswordVisibilityCubit>()
                                  .toggleVisibility(),
                            )
                          : Icon(
                              suffixIcon,
                              color: Colors.orange.shade600,
                            )),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}
