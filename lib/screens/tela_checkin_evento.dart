import 'package:flutter/material.dart';

import '../tema.dart';
import 'tela_leitura_ingresso.dart';
import '../widgets/formulario_ingresso.dart';
import '../widgets/cartao_ingresso.dart';
import '../widgets/cartao_resultado_checkin.dart';
import '../widgets/item_participante.dart';

enum TipoResultado { neutro, sucesso, duplicado, erro }

class Participante {
  const Participante({required this.nome, required this.email});

  final String nome;
  final String email;
}

class TelaCheckinEvento extends StatefulWidget {
  const TelaCheckinEvento({super.key});

  @override
  State<TelaCheckinEvento> createState() => _TelaCheckinEventoState();
}

class _TelaCheckinEventoState extends State<TelaCheckinEvento> {
  final TextEditingController _controladorNome = TextEditingController();

  final TextEditingController _controladorEmail = TextEditingController();

  final List<Participante> _presentes = [];

  bool _ingressoGerado = false;

  String? _erroNome;
  String? _erroEmail;

  String _tituloResultado = 'Aguardando check-in';
  String _mensagemResultado =
      'Gere um ingresso ou faça a leitura de um QR Code.';
  TipoResultado _tipoResultado = TipoResultado.neutro;

  bool _emailValido(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _gerarIngresso() {
    final nome = _controladorNome.text.trim();
    final email = _controladorEmail.text.trim();

    setState(() {
      _erroNome = nome.isEmpty ? 'Informe o nome do participante.' : null;

      _erroEmail = email.isEmpty
          ? 'Informe o e-mail.'
          : !_emailValido(email)
          ? 'Informe um e-mail válido.'
          : null;

      if (_erroNome != null || _erroEmail != null) {
        _ingressoGerado = false;
        return;
      }

      final emailDuplicado = _presentes.any(
        (participante) =>
            participante.email.toLowerCase() == email.toLowerCase(),
      );

      if (emailDuplicado) {
        _ingressoGerado = false;
        _mostrarResultado(
          'Participante já confirmado',
          'Este e-mail já realizou o check-in.',
          TipoResultado.duplicado,
        );
        return;
      }

      _ingressoGerado = true;
    });

    FocusScope.of(context).unfocus();
  }

  Future<void> _abrirLeitor() async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => TelaLeituraIngresso()),
    );

    if (!mounted || resultado == null) return;

    _processarResultadoLeitura(resultado);
  }

  void _processarResultadoLeitura(String resultado) {
    final partes = resultado.split('|');

    if (partes.length != 3 ||
        partes[0] != 'CHECKIN' ||
        partes[1].trim().isEmpty ||
        !_emailValido(partes[2].trim())) {
      _mostrarResultado(
        'Ingresso inválido',
        'O QR Code não contém dados válidos de check-in.',
        TipoResultado.erro,
      );
      return;
    }

    final nome = partes[1].trim();
    final email = partes[2].trim();

    final emailDuplicado = _presentes.any(
      (participante) => participante.email.toLowerCase() == email.toLowerCase(),
    );

    if (emailDuplicado) {
      _mostrarResultado(
        'Check-in duplicado',
        'Este participante já está na lista de confirmados.',
        TipoResultado.duplicado,
      );
      return;
    }

    setState(() {
      _presentes.add(Participante(nome: nome, email: email));

      _tituloResultado = 'Check-in realizado!';
      _mensagemResultado = '$nome foi confirmado com sucesso.';
      _tipoResultado = TipoResultado.sucesso;
    });
  }

  void _mostrarResultado(String titulo, String mensagem, TipoResultado tipo) {
    setState(() {
      _tituloResultado = titulo;
      _mensagemResultado = mensagem;
      _tipoResultado = tipo;
    });
  }

  Color _obterCorResultado() {
    switch (_tipoResultado) {
      case TipoResultado.sucesso:
        return Colors.green;
      case TipoResultado.duplicado:
        return Colors.orange;
      case TipoResultado.erro:
        return Colors.red;
      case TipoResultado.neutro:
        return TemaAplicativo.azulPrincipal;
    }
  }

  IconData _obterIconeResultado() {
    switch (_tipoResultado) {
      case TipoResultado.sucesso:
        return Icons.check_circle_outline;
      case TipoResultado.duplicado:
        return Icons.warning_amber_rounded;
      case TipoResultado.erro:
        return Icons.error_outline;
      case TipoResultado.neutro:
        return Icons.info_outline;
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in de Evento'),
        backgroundColor: TemaAplicativo.azulPrincipal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormularioIngresso(
              controladorNome: _controladorNome,
              controladorEmail: _controladorEmail,
              erroNome: _erroNome,
              erroEmail: _erroEmail,
              onNomeAlterado: (_) {
                setState(() {
                  _erroNome = null;
                  _ingressoGerado = false;
                });
              },
              onEmailAlterado: (_) {
                setState(() {
                  _erroEmail = null;
                  _ingressoGerado = false;
                });
              },
              onGerarIngresso: _gerarIngresso,
            ),

            if (_ingressoGerado) ...[
              const SizedBox(height: 20),
              CartaoIngresso(
                nome: _controladorNome.text.trim(),
                email: _controladorEmail.text.trim(),
                dadosQrCode:
                    'CHECKIN|${_controladorNome.text.trim()}|${_controladorEmail.text.trim()}',
              ),
            ],

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _abrirLeitor,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Ler ingresso para check-in'),
            ),

            const SizedBox(height: 16),

            CartaoResultadoCheckin(
              titulo: _tituloResultado,
              mensagem: _mensagemResultado,
              cor: _obterCorResultado(),
              icone: _obterIconeResultado(),
            ),

            const SizedBox(height: 24),

            Text(
              'Participantes confirmados (${_presentes.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            if (_presentes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Nenhum participante confirmado ainda.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              ..._presentes.map(
                (participante) => ItemParticipante(
                  nome: participante.nome,
                  email: participante.email,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
