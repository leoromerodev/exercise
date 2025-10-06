import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/views/widgets/my_text.dart';

class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    required this.buttonText,
    required this.onTap,
    this.bgColor = Colors.transparent,
    this.textColor = kSecondaryColor,
    this.borderColor = kSecondaryColor,
    this.weight = FontWeight.w600,
    this.height = 48,
    this.textSize = 16,
    this.radius = 50,
    this.borderWidth = 1.5,
    this.splashColor,
    this.child,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height, textSize, radius, borderWidth;
  final Color? bgColor, textColor, borderColor, splashColor;
  final FontWeight? weight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius!),
        border: Border.all(width: borderWidth!, color: borderColor!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor ?? kPrimaryColor.withValues(alpha: 0.2),
          highlightColor: splashColor ?? kPrimaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(radius!),
          child: child ?? Center(
                  child: MyText(
                    text: buttonText,
                    size: textSize,
                    weight: weight,
                    color: textColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ),
      ),
    );
  }
}
