import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heavek/constants/app_colors.dart';

class CommonImageView extends StatelessWidget {
// ignore_for_file: must_be_immutable
  String? url;
  String? imagePath;
  String? svgPath;
  File? file;
  final double? height, width, radius, borderWidth;

  final BoxFit fit;
  final String placeHolder;
  final Color? borderColor;
  
  // New properties for image upload functionality
  final VoidCallback? onTap;
  final bool isUploadable;
  final Widget? uploadIndicator;
  final bool isCircular;

  CommonImageView({
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.radius = 0.0,
    this.fit = BoxFit.cover,
    this.placeHolder = 'assets/images/no_image_found.png',
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
    this.onTap,
    this.isUploadable = false,
    this.uploadIndicator,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageView();
    
    // Wrap with GestureDetector if uploadable and onTap is provided
    if (isUploadable && onTap != null) {
      imageWidget = GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            imageWidget,
            if (uploadIndicator != null)
              Positioned.fill(
                child: uploadIndicator!,
              ),
          ],
        ),
      );
    }
    
    return imageWidget;
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      final circularRadius = isCircular ? (height! / 2) : radius!;
      return Container(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(circularRadius),
          child: SvgPicture.asset(
            svgPath!,
            height: height,
            width: width,
            fit: fit,
          ),
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      final circularRadius = isCircular ? (height! / 2) : radius!;
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularRadius),
          border: Border.all(
            color: borderColor!,
            width: borderWidth!,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(circularRadius),
          child: Image.file(
            file!,
            height: height,
            width: width,
            fit: BoxFit.cover, // Ensure the image fills the entire container
          ),
        ),
      );
    } else if (url != null && url!.isNotEmpty) {
      final circularRadius = isCircular ? (height! / 2) : radius!;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularRadius),
          border: Border.all(
            color: borderColor!,
            width: borderWidth!,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(circularRadius),
          child: CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: url!,
            placeholder: (context, url) => Container(
              height: 23,
              width: 23,
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: kSecondaryColor,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit,
            ),
          ),
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      final circularRadius = isCircular ? (height! / 2) : radius!;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularRadius),
          border: Border.all(
            color: borderColor!,
            width: borderWidth!,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(circularRadius),
          child: Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit,
          ),
        ),
      );
    }
    return SizedBox();
  }
}
