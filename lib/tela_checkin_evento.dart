import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'tela_leitura_ingresso.dart';
import 'tema.dart';

class TelaCheckinEvento extends StatefulWidget {
  const TelaCheckinEvento({super.key});

  @override
  State<TelaCheckinEvento> createState() => _EstadoTelaCheckinEvento();
}

class _EstadoTelaCheckinEvento extends State<TelaCheckinEvento> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final List<_Participante> _presentes = [];

  bool _ingressoGerado = false;
  String? _erroNome;
  String? _erroEmail;

  String _tituloResultado = 'Aguardando leitura';
  String _mensagemResultado =
      'Toque em "Ler ingresso" para iniciar a conferência.';
  TipoResultado _tipoResultado = TipoResultado.neutro;

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorEmail.dispose();
    super.dispose();
  }

  bool _emailValido(String email) {
    final formatoEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return formatoEmail.hasMatch(email.trim());
  }

  void _gerarIngresso() {
    final nome = _controladorNome.text.trim();
    final email = _controladorEmail.text.trim();
    final emailNormalizado = email.toLowerCase();

    setState(() {
      _erroNome = nome.isEmpty ? 'Insira o nome do participante.' : null;

      if (email.isEmpty) {
        _erroEmail = 'Insira um e-mail.';
      } else if (!_emailValido(email)) {
        _erroEmail = 'Insira um e-mail válido.';
      } else if (_presentes.any(
        (participante) => participante.email.toLowerCase() == emailNormalizado,
      )) {
        _erroEmail = 'Este e-mail já realizou check-in.';
      } else {
        _erroEmail = null;
      }

      if (_erroNome == null && _erroEmail == null) {
        _ingressoGerado = true;
      }
    });

    if (_erroNome != null || _erroEmail != null) return;
    FocusScope.of(context).unfocus();
  }

  Future<void> _abrirLeitor() async {
    final String? resultado = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const TelaLeituraIngresso()),
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
        titulo: 'QR Code inválido',
        mensagem: 'O código lido não pertence a um ingresso válido.',
        tipo: TipoResultado.erro,
      );
      return;
    }

    final nomeParticipante = partes[1].trim();
    final emailParticipante = partes[2].trim().toLowerCase();

    final jaEstaPresente = _presentes.any(
      (participante) => participante.email.toLowerCase() == emailParticipante,
    );

    if (jaEstaPresente) {
      _mostrarResultado(
        titulo: 'Já fez check-in',
        mensagem: 'O e-mail $emailParticipante já está na lista de presentes.',
        tipo: TipoResultado.duplicado,
      );
      return;
    }

    setState(() {
      _presentes.add(
        _Participante(nome: nomeParticipante, email: emailParticipante),
      );
    });

    _mostrarResultado(
      titulo: 'Check-in confirmado',
      mensagem: 'Entrada confirmada para $nomeParticipante.',
      tipo: TipoResultado.sucesso,
    );
  }

  void _mostrarResultado({
    required String titulo,
    required String mensagem,
    required TipoResultado tipo,
  }) {
    setState(() {
      _tituloResultado = titulo;
      _mensagemResultado = mensagem;
      _tipoResultado = tipo;
    });
  }

  Color _obterCorResultado() {
    switch (_tipoResultado) {
      case TipoResultado.sucesso:
        return Colors.green.shade700;
      case TipoResultado.duplicado:
        return Colors.orange.shade800;
      case TipoResultado.erro:
        return Colors.red.shade700;
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
        return Icons.cancel_outlined;
      case TipoResultado.neutro:
        return Icons.qr_code_2;
    }
  }

  Widget _construirCartaoPresenca(_Participante participante) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: TemaAplicativo.azulPrincipal,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participante.nome,
                  style: const TextStyle(
                    color: TemaAplicativo.textoPrincipal,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  participante.email,
                  style: const TextStyle(
                    color: TemaAplicativo.textoPrincipal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = _controladorNome.text.trim();
    final email = _controladorEmail.text.trim();
    final dadosQrCode = 'CHECKIN|$nome|$email';
    final corResultado = _obterCorResultado();

    return Scaffold(
      appBar: AppBar(title: const Text('Semana da Computação 2026')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controladorNome,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nome do participante',
                  hintText: 'Digite seu nome completo',
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: _erroNome,
                ),
                onChanged: (_) => setState(() {
                  _erroNome = null;
                  _ingressoGerado = false;
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controladorEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Digite seu e-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: _erroEmail,
                ),
                onChanged: (_) => setState(() {
                  _erroEmail = null;
                  _ingressoGerado = false;
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _gerarIngresso,
                icon: const Icon(Icons.confirmation_number_outlined),
                label: const Text('Gerar ingresso'),
              ),
              if (_ingressoGerado) ...[
                const SizedBox(height: 24),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'SEMANA DA COMPUTAÇÃO 2026',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TemaAplicativo.azulPrincipal,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          nome,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: TemaAplicativo.textoPrincipal,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: TemaAplicativo.textoPrincipal,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: TemaAplicativo.bordaAzul),
                          ),
                          child: QrImageView(
                            data: dadosQrCode,
                            version: QrVersions.auto,
                            size: 190,
                            backgroundColor: Colors.white,
                            foregroundColor: TemaAplicativo.azulMarinho,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              const Divider(height: 1),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(
                    Icons.how_to_reg_outlined,
                    color: TemaAplicativo.azulPrincipal,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Check-in',
                    style: TextStyle(
                      color: TemaAplicativo.textoPrincipal,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _abrirLeitor,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Ler ingresso'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  foregroundColor: TemaAplicativo.azulPrincipal,
                  side: const BorderSide(color: TemaAplicativo.azulPrincipal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Card(
                color: TemaAplicativo.fundoClaro,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: corResultado.withValues(alpha: 0.5),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: corResultado.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _obterIconeResultado(),
                          color: corResultado,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tituloResultado,
                              style: TextStyle(
                                color: corResultado,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _mensagemResultado,
                              style: const TextStyle(
                                color: TemaAplicativo.textoPrincipal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Presentes',
                      style: TextStyle(
                        color: TemaAplicativo.textoPrincipal,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: TemaAplicativo.bordaAzul,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_presentes.length}',
                      style: const TextStyle(
                        color: TemaAplicativo.azulMarinho,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_presentes.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: TemaAplicativo.fundoClaro,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: TemaAplicativo.bordaAzul),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 34,
                        color: TemaAplicativo.azulPrincipal,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nenhum check-in confirmado ainda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TemaAplicativo.textoPrincipal,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Os participantes aparecerão aqui após '
                        'a validação do ingresso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TemaAplicativo.textoPrincipal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._presentes.map(_construirCartaoPresenca),
            ],
          ),
        ),
      ),
    );
  }
}

class _Participante {
  const _Participante({required this.nome, required this.email});

  final String nome;
  final String email;
}

enum TipoResultado { neutro, sucesso, duplicado, erro }
