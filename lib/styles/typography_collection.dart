import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyCollection {
  static final TextStyle h1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle sh1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle h2 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle italic = GoogleFonts.poppins(
    fontSize: 16,
    fontStyle: FontStyle.italic,
  );
}
