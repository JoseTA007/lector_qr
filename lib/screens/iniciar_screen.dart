import 'dart:io';
import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const QrScanner());
}

class QrScanner extends StatelessWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR SCANNER',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('QR SCANNER'),
        ),
        body: const Iniciar(),
      ),
    );
  }
}

class Iniciar extends StatefulWidget {
  const Iniciar({Key? key}) : super(key: key);

  @override
  State<Iniciar> createState() => _IniciarState();
}

class _IniciarState extends State<Iniciar> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFrontCamera = true;
  bool isPlaying = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        )),
                    child: _buildQrView(context))),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (result != null)
                      Column(
                        children: [
                          Text(
                            '${result!.code}',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //Barcode Type: ${describeEnum(result!.format)} Data:
                          Container(
                            width: 300,
                            child: Flexible(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade900,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Colors.white, width: 3))),
                                onPressed: () {
                                  _launchURL(result!.code!);
                                },
                                child: const Text(
                                  'IR Al URL',
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'USAME...!!!',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade600,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Colors.white, width: 3))),
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                bool isFlashActive = false;

                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  isFlashActive = snapshot.data as bool;

                                  return Row(
                                    children: [
                                      const Text(
                                        'Flash: ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Icon(
                                        isFlashActive
                                            ? Icons.flash_off
                                            : Icons.flash_on,
                                        color: isFlashActive
                                            ? Colors.red
                                            : Colors.blue,
                                      ),
                                    ],
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Colors.white, width: 3))),
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {
                                isFrontCamera = !isFrontCamera;
                              });
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: ((context, snapshot) {
                                if (snapshot.data != null) {
                                  return Row(
                                    children: [
                                      const Text('Camera facing: '),
                                      const Icon(
                                        Icons.cameraswitch,
                                        color: Colors.white60,
                                      ),
                                      Icon(
                                        isFrontCamera
                                            ? Icons.camera_front
                                            : Icons.camera_rear,
                                        color: isFrontCamera
                                            ? Colors.orange.shade200
                                            : Colors.blue,
                                      )
                                    ],
                                  );
                                } else {
                                  return const Text('loading');
                                }
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade300,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                    color: Colors.white, width: 3))),
                        onPressed: () async {
                          if (isPlaying) {
                            await controller?.pauseCamera();
                          } else {
                            await controller?.resumeCamera();
                          }
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Camara: ',
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: isPlaying ? Colors.red : Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
//TODO ESPACIO A SCANNEAR, SI EL ANCHO O LA ALTURA DEL DISPOSITIVO ES MENOR A 400, EL ESPACIO A SCANNEAR ES DE 150*15 DE LO CONTRARIO ES 300*300

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        //SE ASIGNA
        ? 150.0
        //DE LO CONTRARIO SE ASIGNARA
        : 300.0;
    //WIDGET WRVIEW
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String logMessage = '$timestamp _onPermissionSet $p';
    log(logMessage);
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('no Permission'),
      ));
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri);
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not launch the URL'),
      ));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
