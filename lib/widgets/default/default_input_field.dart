import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:living_room/util/constants.dart';

class DefaultInputField extends StatelessWidget {
  final ValueChanged callback;
  final String? initialValue;
  final String? text;
  final String? hintText;
  final bool? obscureText;
  final String? suffixText;
  final IconData? suffixIcon;
  final TextInputAction? textInputAction;
  final int maxLength;
  final Color textColor;
  final Function? validator;
  final Function? validatorMessage;
  final Function? obscureIconTap;
  final Function? suffixIconTap;

  const DefaultInputField({
    Key? key,
    required this.callback,
    this.initialValue,
    this.text,
    this.hintText,
    this.obscureText,
    this.suffixText,
    this.suffixIcon,
    this.textInputAction,
    this.validator,
    this.validatorMessage,
    this.maxLength = 250,
    this.obscureIconTap,
    this.suffixIconTap,
    this.textColor = AppColors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TextFormField(
      initialValue: initialValue,
      onChanged: (String input) {
        callback(input);
      },
      validator: (input) {
        if (validator != null && validator!() == false) {
          return validatorMessage != null
              ? validatorMessage!()
              : ''; //widget.validatorMessage!;
        } else {
          return null;
        }
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      textInputAction: textInputAction,
      obscureText: obscureText == true,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: Constants.borderRadius,
          borderSide: BorderSide(
              width: Constants.borderWidth, color: AppColors.red),),
        focusedBorder: OutlineInputBorder(
            borderRadius: Constants.borderRadius,
            borderSide: BorderSide(
                width: Constants.borderWidth, color: AppColors.purple),),
        enabledBorder: OutlineInputBorder(
          borderRadius: Constants.borderRadius,
          borderSide: BorderSide(
              width: Constants.borderWidth, color: AppColors.whiteOp30),),
        contentPadding: AppPaddings.inputField,
        border: OutlineInputBorder(borderRadius: Constants.borderRadius),
        labelText: hintText,
        labelStyle: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: textColor),
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: textColor),
        suffixText: suffixText,
        errorMaxLines: 3,
        errorStyle: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: AppColors.red),
        suffixIcon: suffix,
      ),
    ));
  }

  Widget? get suffix {
    IconData? iconData;
    Function? onPressed;
    if (suffixIcon != null) {
      iconData = suffixIcon!;
      onPressed = suffixIconTap;
    } else if (obscureText == true) {
      iconData = Icons.visibility_rounded;
      onPressed = obscureIconTap;
    } else if (obscureText == false) {
      iconData = Icons.visibility_off_rounded;
      onPressed = obscureIconTap;
    }

    return ExcludeFocus(
        child: IconButton(
            onPressed: () => onPressed?.call(),
            icon: Icon(iconData, color: AppColors.whiteOp30)));
  }
}
