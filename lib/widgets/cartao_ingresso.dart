import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../tema.dart';
import 'cabecalho_ingresso.dart';

class CartaoIngresso extends StatelessWidget {
  const CartaoIngresso({
    super.key,
    required this.nome,
    required this.email,
    required this.dadosQrCode,
  });

  final String nome;
  final String email;
  final String dadosQrCode;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: TemaAplicativo.bordaAzul),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CabecalhoIngresso(),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(email, textAlign: TextAlign.center),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: TemaAplicativo.bordaAzul),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QrImageView(
                    data: dadosQrCode,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
