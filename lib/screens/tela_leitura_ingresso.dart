import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../tema.dart';
import '../widgets/moldura_leitor_qr.dart';
import '../widgets/orientacao_leitor_qr.dart';

class TelaLeituraIngresso extends StatefulWidget {
  const TelaLeituraIngresso({super.key});

  @override
  State<TelaLeituraIngresso> createState() => _EstadoTelaLeituraIngresso();
}

class _EstadoTelaLeituraIngresso extends State<TelaLeituraIngresso> {
  final MobileScannerController _controladorCamera = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  StreamSubscription<BarcodeCapture>? _assinaturaCodigos;
  bool _leituraConcluida = false;
  String? _erroCamera;

  @override
  void initState() {
    super.initState();

    // Recebe os códigos detectados pela câmera.
    _assinaturaCodigos = _controladorCamera.barcodes.listen(_aoDetectarCodigo);

    // Inicia a câmera quando a tela é aberta.
    _iniciarCamera();
  }

  Future<void> _iniciarCamera() async {
    try {
      await _controladorCamera.start();
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _erroCamera =
            'Não foi possível abrir a câmera. '
            'Confira a permissão e a configuração do dispositivo.';
      });
    }
  }

  void _aoDetectarCodigo(BarcodeCapture captura) {
    if (_leituraConcluida) return;

    for (final codigo in captura.barcodes) {
      final valor = codigo.rawValue;

      if (valor != null && valor.isNotEmpty) {
        _leituraConcluida = true;
        _assinaturaCodigos?.cancel();
        _controladorCamera.stop();

        if (mounted) {
          Navigator.of(context).pop(valor);
        }
        return;
      }
    }
  }

  Future<void> _cancelarLeitura() async {
    await _assinaturaCodigos?.cancel();
    await _controladorCamera.stop();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _assinaturaCodigos?.cancel();
    _controladorCamera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemaAplicativo.fundoCamera,
      appBar: AppBar(
        title: const Text('Semana da Computação 2026'),
        backgroundColor: TemaAplicativo.azulPrincipal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            const Text(
              'Ler ingresso',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Posicione o QR Code dentro da moldura',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: Center(
                child: MolduraLeitorQr(
                  controladorCamera: _controladorCamera,
                  erroCamera: _erroCamera,
                ),
              ),
            ),

            const OrientacaoLeitorQr(),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _cancelarLeitura,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: TemaAplicativo.azulPrincipal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
