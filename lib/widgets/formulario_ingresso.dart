import 'package:flutter/material.dart';

class FormularioIngresso extends StatelessWidget {
  const FormularioIngresso({
    super.key,
    required this.controladorNome,
    required this.controladorEmail,
    required this.erroNome,
    required this.erroEmail,
    required this.onNomeAlterado,
    required this.onEmailAlterado,
    required this.onGerarIngresso,
  });

  final TextEditingController controladorNome;
  final TextEditingController controladorEmail;

  final String? erroNome;
  final String? erroEmail;

  final ValueChanged<String> onNomeAlterado;
  final ValueChanged<String> onEmailAlterado;
  final VoidCallback onGerarIngresso;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controladorNome,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Nome do participante',
            hintText: 'Digite seu nome completo',
            prefixIcon: const Icon(Icons.person_outline),
            errorText: erroNome,
          ),
          onChanged: onNomeAlterado,
        ),

        const SizedBox(height: 16),

        TextField(
          controller: controladorEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'E-mail',
            hintText: 'Digite seu e-mail',
            prefixIcon: const Icon(Icons.email_outlined),
            errorText: erroEmail,
          ),
          onChanged: onEmailAlterado,
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          onPressed: onGerarIngresso,
          icon: const Icon(Icons.confirmation_number_outlined),
          label: const Text('Gerar ingresso'),
        ),
      ],
    );
  }
}
