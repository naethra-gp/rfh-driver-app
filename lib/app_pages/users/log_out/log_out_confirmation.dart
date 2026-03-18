import 'package:flutter/material.dart';

import '../../../app_utils/index_app_util.dart';

// ignore: use_key_in_widget_constructors
class LogoutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Logout',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Text(
        'Are you sure you want to logout?',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            overlayColor: RColors.black,
            backgroundColor: RColors.grey,
            side: const BorderSide(color: RColors.grey),
          ),
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Return false when cancel is pressed
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: RColors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pop(true); // Return true when logout is pressed
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
