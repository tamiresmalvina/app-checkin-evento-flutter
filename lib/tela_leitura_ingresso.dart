import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'tema.dart';

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

    // Na versão 5 do mobile_scanner, os códigos são recebidos por este stream.
    _assinaturaCodigos = _controladorCamera.barcodes.listen(_aoDetectarCodigo);

    // Solicita o início da câmera ao abrir a tela.
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
    if (mounted) Navigator.of(context).pop();
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
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _erroCamera != null
                          ? Container(
                              color: TemaAplicativo.superficieCamera,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                _erroCamera!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                MobileScanner(controller: _controladorCamera),
                                IgnorePointer(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: TemaAplicativo.azulPrincipal,
                                          width: 4,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: TemaAplicativo.azulCiano,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Aponte a câmera para o QR Code do ingresso.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
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
