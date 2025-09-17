import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/app/bindings/initial_binding.dart';
import '/app/core/values/app_colors.dart';
import '/app/routes/app_pages.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';


class MyApp extends StatefulWidget {

   MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  final EnvConfig _envConfig = BuildConfig.instance.config;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      builder: (context, child) => GetMaterialApp(
        title: _envConfig.appName,
        initialBinding: InitialBinding(),
        debugShowCheckedModeBanner: false,
        getPages: AppPages.routes,
        initialRoute: AppPages.INITIAL,
        theme: ThemeData(
          primarySwatch: AppColors.colorPrimarySwatch,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          primaryColor: AppColors.colorPrimary,
          textTheme: const TextTheme(
            labelLarge: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}