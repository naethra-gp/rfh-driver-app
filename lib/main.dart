import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_config/app_routes.dart';
import 'app_themes/app_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensures Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Open the box
  await Hive.openBox('box_Rfh');
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'R4X',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        initialRoute: 'splash',
        builder: EasyLoading.init(),
        onGenerateRoute: AppRoute.allRoutes,
        navigatorKey: navigatorKey,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
      ),
    );
  }
}
