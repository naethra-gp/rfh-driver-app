import 'package:flutter/material.dart';
import 'package:rfh/app_storage/secure_storage.dart';
import 'index_app_util.dart';

class UserName extends StatelessWidget {
  UserName({super.key});

  final String? name = BoxStorage().getUserName();

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunction.isDarkMode(context);
    return Column(
      children: [
        Text(
          name ?? 'Guest', // Provide a fallback in case name is null
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: dark ? RColors.white : RColors.primary),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
