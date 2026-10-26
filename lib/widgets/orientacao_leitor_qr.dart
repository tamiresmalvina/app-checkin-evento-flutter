import 'package:flutter/material.dart';

import '../tema.dart';

class OrientacaoLeitorQr extends StatelessWidget {
  const OrientacaoLeitorQr({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            color: TemaAplicativo.azulCiano,
            size: 20,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Aponte a câmera para o QR Code do ingresso.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
