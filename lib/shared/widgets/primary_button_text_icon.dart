import 'package:picospaintballzone/shared/constants/assets_constants.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PrimaryButtonTextIcon extends StatelessWidget {
  final String? text;
  final Function()? press;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final bool? isEnabled;
  final IconData icon;
  final bool? isLoading;
  const PrimaryButtonTextIcon({
    Key? key,
    required this.text,
    required this.press,
    required this.isEnabled,
    required this.color,
    this.borderColor,
    required this.textColor,
    this.width,
    required this.icon,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
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
                  width: 30
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(
              text!,
              style: TextStyle(color: textColor,),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
