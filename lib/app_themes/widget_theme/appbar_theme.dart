import 'package:flutter/material.dart';
import '../../app_utils/index_app_util.dart';

class RAppBarTheme {
  RAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 6,
    centerTitle: true,
    scrolledUnderElevation: 0,
    shadowColor: RColors.primary,
    backgroundColor: RColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: RColors.primary, size: RSizes.iconSm),
    actionsIconTheme:
        IconThemeData(color: RColors.primary, size: RSizes.iconSm),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: RColors.white),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 6,
    centerTitle: true,
    scrolledUnderElevation: 0,
    shadowColor: RColors.primary,
    backgroundColor: RColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: RColors.primary, size: RSizes.iconSm),
    actionsIconTheme:
        IconThemeData(color: RColors.primary, size: RSizes.iconSm),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: RColors.white),
  );
}
