import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:picospaintballzone/shared/constants/assets_constants.dart';

import '../theme/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final bool? isEnabled;
  final IconData? icon;
  final bool? isLoading;
  final Function()? press;
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.press,
    required this.isEnabled,
    required this.color,
    this.borderColor,
    required this.textColor,
    this.width,
    this.icon,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      width: width,
      child: RawMaterialButton(
        fillColor: isEnabled! ? color : AppColors.primaryGreyMedium,
        splashColor: isEnabled! ? Colors.white.withOpacity(0.3) : Colors.transparent,
        highlightColor: isEnabled! ? Colors.white.withOpacity(0.3) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(
            color: borderColor!,
          )
              : BorderSide.none,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        onPressed: isEnabled! ? press : () {},
        elevation: 0,
        highlightElevation: isEnabled! ? 5 : 0,
        child: isLoading ?? false
            ? Row(
          children: [
            Expanded(
              child: Lottie.asset(
                AssetsConstants.loading,
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                text!,
                style: TextStyle(color: textColor,),
                textAlign: TextAlign.center,
              ),
            ),
            if (icon != null) Icon(icon, color: Colors.white,),
          ],
        ),
      ),
    );
  }
}