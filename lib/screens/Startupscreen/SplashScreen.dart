import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Startupscreen/Splashviewmodel.dart';
import 'package:flutter_application_1/screens/Views/LoginView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () => SplashViewModel(),
      onModelReady: (model) => model.checkSplash(),
      builder: (context, model, child) {
        if (model.isSplashDone) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          });
        }

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB3CDE0),
                  Color(0xFF9EBDF1),
                  Color(0xFF2A4D6F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/hero.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      'NotePad',
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                          fontSize: 40,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'All thoughts in one place',
                      style: GoogleFonts.bonaNova(
                        textStyle: TextStyle(
                          fontSize: 30,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
