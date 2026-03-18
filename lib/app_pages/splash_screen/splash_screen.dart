import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_utils/index_app_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getRoute();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getRoute() {
    BoxStorage storage = BoxStorage();
    var token = storage.getLoginToken();
    Future.delayed(const Duration(seconds: 3), () async {
      if (token != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, "deliveryDashboard", (route) => false);
      } else {
        RHelperFunction.navigateToLoginPage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunction.isDarkMode(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(RImages.lightAppLogo),
            const SizedBox(height: RSizes.defaultSpace),
            SpinKitThreeBounce(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color.fromARGB(255, 192, 201, 195)
                        : RColors.primary,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
