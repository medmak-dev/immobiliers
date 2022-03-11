import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class TextCustum extends Text {
  TextCustum(String data,
      {double size = 20,
      fontWeight = FontWeight.normal,
      Color color = Colors.white,
      double letterSpacing = 0,
      textAlign = TextAlign.center})
      : super(data,
            textAlign: textAlign,
            style: GoogleFonts.aBeeZee(
              color: color,
              fontSize: size,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
            ));
}
