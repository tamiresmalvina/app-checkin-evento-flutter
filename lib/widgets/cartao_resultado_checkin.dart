import 'package:flutter/material.dart';

class CartaoResultadoCheckin extends StatelessWidget {
  const CartaoResultadoCheckin({
    super.key,
    required this.titulo,
    required this.mensagem,
    required this.cor,
    required this.icone,
  });

  final String titulo;
  final String mensagem;
  final Color cor;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: cor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: cor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: cor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(mensagem),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
