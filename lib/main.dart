

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:healthy_bite_project/controllers/providers/sign_in_google_provider.dart';
import 'package:healthy_bite_project/controllers/providers/stripe_payment_provider.dart';
import 'package:healthy_bite_project/services/local_notification_service.dart';
import 'package:healthy_bite_project/views/screens/splash_screen_module/splash_screen.dart';
import 'package:provider/provider.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  print(Directory.current.path);

  final file = File('.env');
  final exists = await file.exists();
  print('Does .env exist? $exists');
  try {
    await dotenv.load();
    print("Loaded dotenv: ${dotenv.env['STRIPE_SECRET_KEY']}");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  print("Stripe Key: ${dotenv.env['STRIPE_SECRET_KEY']}");
  await NotificationService.initialize();
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_51RGOOgRf69cmFU6ydY8D0HJtroaRS86ghu1awio3m5wJwozMmAYBTlOHc2wrDxjPZdKbwoXN073qXTmrorVtMGZI00UGkF8vAV';
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (create) => SignInGoogleProvider(),),
      ChangeNotifierProvider(create: (create) => StripePaymentProvider())
    ],
      child: MyApp(),
    ));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthy Bite',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
         home: const SplashScreen()
      ),
    );
  }
}

