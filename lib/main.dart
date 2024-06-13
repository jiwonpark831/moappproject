import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'MainScreen.dart';
import 'firebase_options.dart';

import 'dart:async';             

import 'login.dart';

import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Moappfinal_seodangol',
        initialRoute: '/main',
        routes: {
          '/login': (BuildContext context) => LoginPage(),
           '/main': (BuildContext context) => MainScreenPage(),
        });
  }
}
