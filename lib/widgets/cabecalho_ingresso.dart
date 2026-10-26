import 'package:flutter/material.dart';

import '../tema.dart';

class CabecalhoIngresso extends StatelessWidget {
  const CabecalhoIngresso({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem usada como fundo do banner.
          Image.asset(
            'assets/banner_evento.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: TemaAplicativo.azulPrincipal,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.white70,
                  size: 32,
                ),
              );
            },
          ),

          // Camada azul transparente sobre a imagem.
          Container(
            color: TemaAplicativo.azulPrincipal.withValues(alpha: 0.35),
          ),

          // Título centralizado sobre o banner.
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Semana da Computação 2026',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
