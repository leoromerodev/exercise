import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:heavek/bindings/bindings.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeaveK',
      theme: ThemeData(
        scaffoldBackgroundColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialBinding: InitialBindings(),
      home: SplashScreen(),
    );
  }
}
