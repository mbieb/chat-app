import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/screens/auth_screen.dart';
import 'package:firebase_chat_app/screens/home_page.dart';
import 'package:firebase_chat_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initOneSignal();
  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // FirebaseCrashlytics.instance.crash();
  runApp(const MyApp());
}

initOneSignal() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("19eee5ca-6511-4964-9eac-7e66a7d55784");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (userSnapshot.hasData) {
            return const HomePage();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
