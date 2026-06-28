import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildDarkTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: bgColor,
  colorScheme: const ColorScheme.dark(
    surface: surfaceColor,
    primary: accentColor,
    onPrimary: onAccent,
    onSurface: textColor,
  ),
  textTheme: GoogleFonts.hankenGroteskTextTheme(
    ThemeData.dark().textTheme,
  ).apply(bodyColor: textColor, displayColor: textColor),
  dividerColor: borderColor,
  extensions: const [PushColors.dark()],
);

ThemeData buildLightTheme() => ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: bgColorLight,
  colorScheme: const ColorScheme.light(
    surface: surfaceColorLight,
    primary: accentColor,
    onPrimary: onAccent,
    onSurface: textColorLight,
  ),
  textTheme: GoogleFonts.hankenGroteskTextTheme(
    ThemeData.light().textTheme,
  ).apply(bodyColor: textColorLight, displayColor: textColorLight),
  dividerColor: const Color(0x1A000000),
  extensions: const [PushColors.light()],
);

// ThemeExtension so widgets can access semantic colors without knowing dark/light
@immutable
class PushColors extends ThemeExtension<PushColors> {
  const PushColors({
    required this.bg,
    required this.surface,
    required this.track,
    required this.text,
    required this.text2,
    required this.muted,
    required this.disabled,
  });

  const PushColors.dark()
      : bg = bgColor,
        surface = surfaceColor,
        track = trackColor,
        text = textColor,
        text2 = text2Color,
        muted = textMuted,
        disabled = textDisabled;

  const PushColors.light()
      : bg = bgColorLight,
        surface = surfaceColorLight,
        track = trackColorLight,
        text = textColorLight,
        text2 = text2ColorLight,
        muted = textMutedLight,
        disabled = textDisabledLight;

  final Color bg;
  final Color surface;
  final Color track;
  final Color text;
  final Color text2;
  final Color muted;
  final Color disabled;

  @override
  PushColors copyWith({Color? bg, Color? surface, Color? track,
      Color? text, Color? text2, Color? muted, Color? disabled}) =>
      PushColors(
        bg: bg ?? this.bg,
        surface: surface ?? this.surface,
        track: track ?? this.track,
        text: text ?? this.text,
        text2: text2 ?? this.text2,
        muted: muted ?? this.muted,
        disabled: disabled ?? this.disabled,
      );

  @override
  PushColors lerp(PushColors? other, double t) {
    if (other == null) return this;
    return PushColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      track: Color.lerp(track, other.track, t)!,
      text: Color.lerp(text, other.text, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}

// Convenience extension on BuildContext
extension PushTheme on BuildContext {
  PushColors get pushColors =>
      Theme.of(this).extension<PushColors>()!;
}
