import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chicken_game/res/color_constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration = const InputDecoration();
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign = TextAlign.start;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool? readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? icon;
  final Color? iconColor;
  final String? hintText;
  final String? labelText;
  final bool? filled;
  final Color? fillColor;
  final Color? focusColor;
  final double? cursorWidth;
  final Color? hoverColor;
  final void Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? labelSize;
  final double? hintSize;
  final double? fontSize;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? contentPadding;
  final double? cursorHeight;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BorderRadius? fieldRadius;
  final bool? enabled;
  final void Function()? onTap;
  final bool? autofocus;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? margin;
  final Color? labelColor;
  final Color? hintColor;
  final String? errorText;
  final BorderSide? borderSide;
  final Color? textColor;
  final FontWeight? fontWeight;
  final FontWeight? hintWeight;
  final FontWeight? labelWeight;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.style,
    this.strutStyle,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType,
    this.icon,
    this.iconColor,
    this.hintText,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.onChanged,
    this.height,
    this.width,
    this.labelSize,
    this.hintSize,
    this.fontSize,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.contentPadding,
    this.cursorHeight,
    this.cursorColor,
    this.cursorWidth,
    this.prefixIcon,
    this.suffixIcon,
    this.fieldRadius,
    this.enabled,
    this.maxLines,
    this.onTap,
    this.autofocus,
    this.onSaved,
    this.validator,
    this.margin,
    this.labelColor,
    this.hintColor,
    this.errorText,
    this.borderSide,
    this.textColor,
    this.fontWeight,
    this.labelWeight,
    this.hintWeight,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: height ?? 45,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: TextFormField(
          focusNode: focusNode,
          textInputAction: textInputAction ?? TextInputAction.done,
          validator: validator,
          onSaved: onSaved,
          autofocus: autofocus ?? false,
          textAlignVertical: TextAlignVertical.center,
          enabled: enabled,
          controller: controller,
          cursorColor: cursorColor,
          cursorWidth: cursorWidth ?? 2.0,
          cursorHeight: cursorHeight,
          onChanged: onChanged,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
          readOnly: readOnly ?? false,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: style ??
              TextStyle(
                  color: ColorConstant.white, fontSize: Dimensions.fifteen),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
                    fontSize: labelSize ?? 15,
                    fontWeight: labelWeight ?? FontWeight.normal,
                    color: labelColor ?? Colors.white,)
                .merge(GoogleFonts.sourceSerif4()),
            errorText: errorText,
            counterText: "",
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: filled ?? true,
            fillColor: fillColor ?? ColorConstant.black,
            hintText: hintText,
            hintStyle: TextStyle(
                    fontSize: hintSize ?? 16,
                    fontWeight: hintWeight ?? FontWeight.normal,
                    color: hintColor ?? Colors.black.withValues(alpha: 0.5))
                .merge(GoogleFonts.sourceSerif4()),
            contentPadding: contentPadding ??
                const EdgeInsets.only(left: 10, right: 5, top: 0, bottom: 0),
            border: UnderlineInputBorder(
                borderSide: borderSide == null
                    ? BorderSide(
                        width: 1,
                        color: ColorConstant.black.withValues(alpha: 0.5))
                    : borderSide!),
            focusedBorder: OutlineInputBorder(
                borderSide: borderSide == null
                    ? const BorderSide(width: 1, color: ColorConstant.black)
                    : borderSide!,
                borderRadius: fieldRadius == null
                    ? const BorderRadius.all(Radius.circular(10))
                    : fieldRadius!),
            disabledBorder: OutlineInputBorder(
                borderSide: borderSide == null
                    ? const BorderSide(width: 1, color: ColorConstant.black)
                    : borderSide!,
                borderRadius: fieldRadius == null
                    ? const BorderRadius.all(Radius.circular(5))
                    : fieldRadius!),
            enabledBorder: OutlineInputBorder(
                borderSide: borderSide == null
                    ? const BorderSide(width: 1, color: ColorConstant.black)
                    : borderSide!,
                borderRadius: fieldRadius == null
                    ? const BorderRadius.all(Radius.circular(5))
                    : fieldRadius!),
          ),
        ),
      ),
    );
  }
}
