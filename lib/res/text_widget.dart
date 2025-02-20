import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textWidget({
  required String text,
  double? fontSize,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  bool strikethrough = false,
  int? maxLines,
  String? fontFamily,
  bool showMore = false,
  int threshold = 150,
  Function()? onToggle,
}) {
  // Determine if the text needs truncation
  bool isLongText = text.length > threshold;

  // Displayed text based on `showMore`
  String displayedText =
  isLongText && !showMore ? '${text.substring(0, threshold)}...' : text;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        displayedText,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
        style: TextStyle(
          fontSize: fontSize ?? Dimensions.twenty,
          fontWeight: fontWeight,
          color: color,
          decoration: strikethrough ? TextDecoration.lineThrough : null,
        ).merge(GoogleFonts.sourceSerif4()),
      ),
      if (isLongText) // Show "Read More" or "Read Less" toggle for long text
        GestureDetector(
          onTap: onToggle,
          child: Text(
            showMore ? 'Read Less' : 'Read More',
            style: TextStyle(
              fontSize: fontSize ?? Dimensions.sixteen,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
    ],
  );
}

class Dimensions {
  static double twentyFour = 24;
  static double twenty = 20;
  static double five = 5;
  static double fourteen = 14;
  static double thirteen = 13;
  static double eighteen = 18;
  static double sixteen = 16;
  static double fifteen = 15;
  static double ten = 10;
  static double twelve = 12;
  static double eight = 8;
}


