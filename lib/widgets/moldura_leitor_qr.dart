import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../tema.dart';

class MolduraLeitorQr extends StatelessWidget {
  const MolduraLeitorQr({
    super.key,
    required this.controladorCamera,
    required this.erroCamera,
  });

  final MobileScannerController controladorCamera;
  final String? erroCamera;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: erroCamera != null
              ? Container(
                  color: TemaAplicativo.superficieCamera,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    erroCamera!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(controller: controladorCamera),
                    IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: TemaAplicativo.azulPrincipal,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
