import 'package:flutter/material.dart';

void main() {
  runApp(const AplicativoCheckinEvento());
}

class AplicativoCheckinEvento extends StatelessWidget {
  const AplicativoCheckinEvento({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Check-in de Evento',
      home: (Scaffold(
        body: Center(child: Text('Aplicativo de Check-in de Evento')),
      )),
    );
  }
}
