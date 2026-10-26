import 'package:flutter/material.dart';

import '../tema.dart';

class ItemParticipante extends StatelessWidget {
  const ItemParticipante({super.key, required this.nome, required this.email});

  final String nome;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: TemaAplicativo.azulPrincipal,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(email),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
