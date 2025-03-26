import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? letterSpacing;

  const ResponsiveText(
    this.text, {
    super.key,
    required this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final double? width;
  final double? height;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width?.w,
      height: height?.h,
      child: child,
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ResponsiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      height: height?.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      ),
    );
  }
} 