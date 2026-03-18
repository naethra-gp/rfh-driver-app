import 'package:flutter/material.dart';
import '../../app_utils/index_app_util.dart';

class RElevatedButtonTheme {
  RElevatedButtonTheme._();

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: RColors.light,
      backgroundColor: RColors.primary,
      disabledForegroundColor: RColors.darkGrey,
      disabledBackgroundColor: RColors.buttonDisabled,

      side: const BorderSide(color: RColors.grey),
      // padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
          fontSize: 16, color: RColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: RColors.light,
      backgroundColor: RColors.primary,
      disabledForegroundColor: RColors.darkGrey,
      disabledBackgroundColor: RColors.darkerGrey,
      side: const BorderSide(color: RColors.grey),
      // padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
          fontSize: 16, color: RColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RSizes.buttonRadius)),
    ),
  );

//GEt From GP

  // ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(
  //       textStyle: const TextStyle(
  //         color: Colors.white,
  //         fontWeight: FontWeight.w500,
  //         fontSize: 16,
  //       ),
  //       elevation: 5,
  //       foregroundColor: Colors.white,
  //       backgroundColor: AppColors.primary,
  //       disabledForegroundColor: AppColors.gray,
  //       disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //     ),
  // ),
}
