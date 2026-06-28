import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

TextStyle spaceGrotesk({
  required double size,
  required FontWeight weight,
  Color color = textColor,
  double? letterSpacing,
  double? height,
}) =>
    GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

TextStyle hankenGrotesk({
  required double size,
  required FontWeight weight,
  Color color = textColor,
  double? letterSpacing,
  double? height,
}) =>
    GoogleFonts.hankenGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

// Named styles — design token ramp
final screenTitle  = spaceGrotesk(size: 26, weight: FontWeight.w700);
final greeting     = spaceGrotesk(size: 25, weight: FontWeight.w700, height: 1.08);
final heroNumber   = spaceGrotesk(size: 62, weight: FontWeight.w700, color: accentColor, height: 0.9);
final bigNumber    = spaceGrotesk(size: 48, weight: FontWeight.w700);
final timerStyle   = spaceGrotesk(size: 50, weight: FontWeight.w700);
final statValue    = spaceGrotesk(size: 20, weight: FontWeight.w700);
final buttonLabel  = spaceGrotesk(size: 15, weight: FontWeight.w700, color: onAccent);

final bodyStyle    = hankenGrotesk(size: 13, weight: FontWeight.w500, color: text2Color);
final metaStyle    = hankenGrotesk(size: 11, weight: FontWeight.w600, color: textMuted);
final overlineStyle = hankenGrotesk(
  size: 10, weight: FontWeight.w800, color: textMuted,
  letterSpacing: 0.12 * 10,
);
final navLabel     = hankenGrotesk(size: 9, weight: FontWeight.w600, color: textDisabled);
