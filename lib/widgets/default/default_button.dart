import 'package:flutter/material.dart';
import 'package:living_room/util/constants.dart';
import 'package:living_room/widgets/default/default_text.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final Function callback;
  final double? elevation;
  final Color color;
  final Color? borderColor;
  final Color textColor;
  final bool? isLoading;
  final bool? isEnabled;
  final bool? showErrorColor;
  final IconData? leadIcon;
  final IconData? suffixIcon;
  final BorderRadius? borderRadius;

  const DefaultButton(
      {Key? key,
      this.text = '',
      required this.callback,
      this.color = AppColors.purple,
      this.borderColor,
      this.textColor = AppColors.white,
      this.isLoading,
      this.isEnabled,
      this.showErrorColor,
      this.leadIcon,
      this.suffixIcon,
      this.borderRadius,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => isEnabled == false ? null : callback(),
        style: ElevatedButton.styleFrom(
            side: borderColor != null
                ? BorderSide(width: Constants.borderWidth, color: borderColor!)
                : null,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? Constants.borderRadius),
            minimumSize: const Size(150, 48),
            maximumSize: const Size(150, 150),
            elevation: elevation ?? (isEnabled == false ? 0 : 3),
            backgroundColor: isEnabled == false
                ? AppColors.purple50
                : showErrorColor == true
                    ? AppColors.red
                    : color),
        child: content);
  }

  Widget get content {
    if (isLoading == true) {
      return const CircularProgressIndicator(color: AppColors.white);
    }
    if (leadIcon == null && suffixIcon == null) {
      return DefaultText(
        text ?? '',
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: textColor,
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 5,
      spacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (leadIcon != null)
          Icon(
            leadIcon,
            color: textColor,
          ),
        if (text != null)
          DefaultText(
            text ?? '',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: textColor,
          ),
        if (suffixIcon != null) Icon(suffixIcon, color: textColor)
      ],
    );
  }
}
