import 'package:flutter/material.dart';
import '../../app_utils/index_app_util.dart';
import '../app_pages/index.dart';
import '../app_storage/secure_storage.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? action;
  final bool? automaticallyImplyLeading;
  final Widget? leading;
  final VoidCallback? onBackPressed; // Callback for back button press

  const AppBarWidget({
    super.key,
    required this.title,
    this.action,
    this.leading,
    this.automaticallyImplyLeading,
    this.onBackPressed,
    TabBar? bottom, // Initialize the onBackPressed callback
  });

  // Get Preferred Size For App Bar Widget
  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      title: Text(
        title,
      ),
      leading: automaticallyImplyLeading == false || leading != null
          ? leading
          : Builder(
              builder: (context) {
                // Check if the current route has a back button
                bool canPop = Navigator.of(context).canPop();
                if (canPop) {
                  return IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: RColors.grey,
                      child: Icon(Icons.arrow_back, color: RColors.primary),
                    ),
                    onPressed: onBackPressed ??
                        () {
                          Navigator.of(context).pop(); // Default behavior
                        },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
      actions: action == false
          ? []
          : [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutConfirmationDialog();
                    },
                  ).then((value) {
                    if (value != null && value) {
                      // Perform logout action here
                      BoxStorage boxStorage = BoxStorage();
                      boxStorage.deleteUserDetails();
                      // boxStorage.deleteLoginInfo();
                      Navigator.pushReplacementNamed(context, 'login');
                    }
                  });
                },
                icon: const CircleAvatar(
                  backgroundColor: RColors.grey,
                  child: Icon(color: RColors.primary, Icons.logout_outlined),
                ),
              )
            ],
    );
  }
}
