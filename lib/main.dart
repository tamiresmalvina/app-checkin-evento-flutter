import 'package:flutter/material.dart';
import 'tela_checkin_evento.dart';
import 'tema.dart';

void main() {
  runApp(const AplicativoCheckinEvento());
}

class AplicativoCheckinEvento extends StatelessWidget {
  const AplicativoCheckinEvento({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-in de Evento',
      theme: TemaAplicativo.obterTema(),
      home: const TelaCheckinEvento(),
      debugShowCheckedModeBanner: false,
    );
  }
}
