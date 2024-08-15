import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Home/HomeView.dart';
import 'package:flutter_application_1/screens/Startupscreen/SplashScreen.dart';
import 'package:flutter_application_1/screens/Views/LoginView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/home':
            final args = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (context) => HomeView(username: args ?? ''),
            );
          case '/splash':
            return MaterialPageRoute(builder: (context) => const SplashScreen());
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('404')),
                body: const Center(child: Text('Page not found')),
              ),
            );
        }
      },
    );
  }
}
