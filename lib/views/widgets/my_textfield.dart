import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({
    Key? key,
    this.controller,
    this.hint,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.onTap,
    this.heading,
    this.isEnable = true,
    this.suffix,
    this.prefix,
    this.isCompulsory = false,
    this.fillColor,
    this.hintColor,
    this.hintSize,
    this.hintWeight,
    this.radius,
    this.validator,
    this.focusNode,
    this.onSubmit,
  }) : super(key: key);
  final String? hint, heading;

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Function(String)? onSubmit;
  final bool? isObSecure;
  final double? marginBottom;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool? readOnly;
  final VoidCallback? onTap;
  final bool? isEnable, isCompulsory;
  final Widget? suffix, prefix;
  final Color? fillColor;
  final Color? hintColor;
  final double? hintSize;
  final FontWeight? hintWeight;
  final double? radius;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmit,
      focusNode: focusNode,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly!,
      keyboardType: keyboardType,
      textAlignVertical: suffix != null || prefix != null
          ? TextAlignVertical.center
          : null,
      maxLines: maxLines,
      controller: controller,
      onChanged: onChanged,
      textInputAction: textInputAction,
      obscureText: isObSecure!,
      enabled: isEnable,
      obscuringCharacter: '*',

      // onTapOutside: (_) {
      //   FocusScope.of(context).unfocus();
      // },
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: kTextColorPrimary,
        fontFamily: AppFonts.Montserrat,
      ),
      decoration: InputDecoration(
        fillColor: fillColor ?? kWhiteColor,
        filled: true,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        hintStyle: TextStyle(
          fontSize: hintSize ?? 14,
          color: hintColor ?? kHintColor,
          fontWeight: hintWeight ?? FontWeight.w400,
          fontFamily: AppFonts.Montserrat,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: maxLines! > 1 ? 15 : 0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff4A739C).withValues(alpha: 0.14),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff4A739C).withValues(alpha: 0.14),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff4A739C).withValues(alpha: 0.14),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff4A739C).withValues(alpha: 0.14),
          ),
        ),
      ),
    );
  }
}
