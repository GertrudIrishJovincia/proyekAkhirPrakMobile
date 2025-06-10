import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  /// [AppFont.nunitoSansLight] light text
  static TextStyle nunitoSansLight = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w200,
  );

  /// [AppFont.nunitoSansRegular] regular text
  static TextStyle nunitoSansRegular = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.normal,
  );

  /// [AppFont.nunitoSansMedium] medium text
  static TextStyle nunitoSansMedium = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w500,
  );

  /// [AppFont.nunitoSansSemiBold] semi bolder text
  static TextStyle nunitoSansSemiBold = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w600,
  );

  /// [AppFont.nunitoSansBold] more bolder text
  static TextStyle nunitoSansBold = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w700,
  );

  /// [AppFont.nunitoSansBlack] like boldblack text
  static TextStyle nunitoSansBlack = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w900,
  );
}
