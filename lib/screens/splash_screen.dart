import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_aplication/list/list_image_sc.dart';

import 'package:qr_aplication/screens/iniciar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //TODO lista de colores,
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];
  //INDEX ASIGNADO AL COLOR INICIAL
  int colorIndex = 0;

  int currentIndex = 0;

  Timer? timer, timer2;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //TODO duracion del splash screem - pantalla inicial dura 5 segundos
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Iniciar(),
          ));
    });
    timer2 = Timer.periodic(const Duration(milliseconds: 500), (Timer timer2) {
      setState(() {
        currentIndex = (currentIndex + 1) % imagesSplashScren.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO timer que controla el cambio de colores de la lista - 0.1 seg
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        colorIndex = (colorIndex + 1) % colorList.length;
      });
    });

    return Scaffold(
      //TODO fondo de pantalla

      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LECTOR QR',
              style: TextStyle(color: colorList[colorIndex], fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Q",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.red, fontSize: 40),
                ),
                Text(
                  "R",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.white, fontSize: 30),
                ),
                Text(
                  " ",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.blue, fontSize: 40),
                ),
                Text(
                  "C",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.red, fontSize: 30),
                ),
                Text(
                  "O",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.white, fontSize: 40),
                ),
                Text(
                  "D",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.blue, fontSize: 30),
                ),
                Text(
                  "E",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.red, fontSize: 40),
                ),
                Text(
                  " ",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.white, fontSize: 30),
                ),
                Text(
                  "S",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.blue, fontSize: 40),
                ),
                Text(
                  "C",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.red, fontSize: 30),
                ),
                Text(
                  "A",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.white, fontSize: 40),
                ),
                Text(
                  "N",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.blue, fontSize: 30),
                ),
                Text(
                  "N",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.red, fontSize: 40),
                ),
                Text(
                  "E",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.white, fontSize: 40),
                ),
                Text(
                  "R",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.blue, fontSize: 30),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    imagesSplashScren[currentIndex],
                    height: 400,
                    width: 400,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            const SpinKitCircle(
              color: Colors.orange,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
