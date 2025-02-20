import 'package:chicken_game/res/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Color? gradientColorOne;
  final Color? gradientColorTwo;
  final Color? shadowColor;
  final double? dx;
  final double? dy;
  final Gradient? gradient;
  final String? label;
  final TextStyle? style;
  final IconData? icon;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final double? blurRadius;
  final double? spreadRadius;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final void Function()? onTap;
  final double? space;
  final double? iconSize;
  final List<BoxShadow>? boxShadow;
  final bool? isClicked;
  final BoxShape? shape;
  final BoxBorder? border;
  final bool? loading;
  const PrimaryButton(
      {super.key,
      this.alignment,
      this.padding,
      this.color,
      this.decoration,
      this.width,
      this.height,
      this.margin,
      this.gradientColorOne,
      this.gradientColorTwo,
      this.shadowColor,
      this.dx,
      this.dy,
      this.gradient,
      this.label,
      this.style,
      this.icon,
      this.fontWeight,
      this.fontStyle,
      this.iconColor,
      this.textColor,
      this.fontSize,
      this.begin,
      this.end,
      this.blurRadius,
      this.spreadRadius,
      this.child,
      this.borderRadius,
      this.onTap,
      this.space,
      this.iconSize,
      this.boxShadow,
      this.isClicked,
      this.shape,
      this.border,
      this.loading});

  @override
  Widget build(context) {
    final widths = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        if (onTap != null) {
          HapticFeedback.vibrate();
          onTap!();
        }
        SystemSound.play(SystemSoundType.click);
      },
      child: Container(
        margin: margin,
        alignment: Alignment.center,
        padding: padding,
        height: height ?? 50,
        width: width ?? widths * 0.9,
        decoration: BoxDecoration(
            border: border,
            shape: shape == null ? BoxShape.rectangle : shape!,
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            color: color ?? ColorConstant.blueColor,
            boxShadow: boxShadow),
        child: child ??
            (icon == null
                ? loading == true
                    ? const CircularIndicator()
                    : Text(label == null ? "CLICK" : label!,
                        style: TextStyle(
                                color: textColor ?? ColorConstant.white,
                                fontSize: fontSize ?? 18,
                                fontWeight: fontWeight ?? FontWeight.w500)
                            .merge(GoogleFonts.sourceSerif4()))
                : icon != null && child == null && label == null
                    ? Icon(
                        icon,
                        color: iconColor ?? ColorConstant.white,
                        size: iconSize,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: iconColor ?? ColorConstant.white,
                            size: iconSize,
                          ),
                          SizedBox(
                            width: space ?? 5,
                          ),
                          loading == true
                              ? const CircularIndicator()
                              : Text(label == null ? "" : label!,
                                  style: TextStyle(
                                          color:
                                              textColor ?? ColorConstant.white,
                                          fontSize: fontSize,
                                          fontWeight:
                                              fontWeight ?? FontWeight.w500)
                                      .merge(GoogleFonts.sourceSerif4())),
                        ],
                      )),
      ),
    );
  }
}

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key});

  @override
  Widget build(context) {
    return const Center(
      child: CupertinoActivityIndicator(
        radius: 15.0,
        animating: true,
        color: ColorConstant.grey,
      ),
    );
  }
}
