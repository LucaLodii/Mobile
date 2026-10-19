import 'package:flutter/material.dart';

class TelaDeErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback aoTentarDeNovo;

  const TelaDeErro({
    super.key,
    required this.mensagem,
    required this.aoTentarDeNovo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 40, color: Colors.grey),
          const SizedBox(height: 4),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: aoTentarDeNovo,
            child: const Text('Tentar de novo'),
          ),
        ],
      ),
    );
  }
}

class TelaVazia extends StatelessWidget {
  final String mensagem;

  const TelaVazia(this.mensagem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        mensagem,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
