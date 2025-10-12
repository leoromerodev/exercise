import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/views/widgets/my_textfield.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const CustomSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MyTextfield(
            controller: controller,
            hint: hintText,
            onChanged: onChanged,
            prefix: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(Icons.search, color: Color(0xff7A8094)),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 16),
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                Assets.imagesFilterIcon,
                height: 24,
                width: 24,
              ),
            ),
          ),
        ],
      ],
    );
  }
}




