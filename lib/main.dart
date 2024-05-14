import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hot_control/pages/auth_page.dart';
import 'package:hot_control/pages/login_page.dart';
import 'package:hot_control/pages/outlet_page.dart';
import 'package:hot_control/pages/register_page.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HotControl',
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthPage(),
        '/login': (context) => const LogPage(),
        '/register': (context) => RegPage(),
        '/outlet': (context) => const OutletPage(),
      },
    );
  }
}