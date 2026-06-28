import 'package:flutter/material.dart';

// Dark palette
const Color bgColor        = Color(0xFF0E100D);
const Color surfaceColor   = Color(0xFF181B16);
const Color trackColor     = Color(0xFF23271F);
const Color trackMuted     = Color(0xFF3A4326);
const Color borderColor    = Color(0x0FFFFFFF); // 6% white

const Color accentColor    = Color(0xFFC9F24A);
const Color onAccent       = Color(0xFF10140A);
const Color onAccentDim    = Color(0xFF46580F);

const Color textColor      = Color(0xFFF3F5EF);
const Color text2Color     = Color(0xFFC7CCC0);
const Color textMuted      = Color(0xFF7E837A);
const Color textDisabled   = Color(0xFF5A5F54);

// Light palette
const Color bgColorLight      = Color(0xFFF4F5F0);
const Color surfaceColorLight = Color(0xFFEBECE6);
const Color trackColorLight   = Color(0xFFD8DAD2);
const Color textColorLight    = Color(0xFF12150F);
const Color text2ColorLight   = Color(0xFF3D4238);
const Color textMutedLight    = Color(0xFF6B7065);
const Color textDisabledLight = Color(0xFF9BA094);

// Shared
const LinearGradient accentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFC9F24A), Color(0xFFA8D633)],
);
