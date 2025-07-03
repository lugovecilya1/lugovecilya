import 'package:flutter/material.dart';
import 'phone_input.dart';
import 'otp_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: PhoneInputScreen.routeName,
      routes: {
        PhoneInputScreen.routeName: (_) => const PhoneInputScreen(),
        OTPScreen.routeName: (_) => const OTPScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
    );
  }
}
