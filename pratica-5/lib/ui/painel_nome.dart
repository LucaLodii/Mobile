import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/decada.dart';
import '../dominio/nomes_store.dart';
import 'estados.dart';
import 'formato.dart';

// O nome buscado aparece neste painel, acima do ranking, sem sair da tela.
class PainelNome extends StatelessWidget {
  const PainelNome({super.key});

  @override
  Widget build(BuildContext context) {
    final loja = context.watch<NomesStore>();
    final nome = loja.nomeBuscado!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nome.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: loja.fecharBusca,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(height: 150, child: _conteudo(loja, nome)),
          ),
        ],
      ),
    );
  }

  Widget _conteudo(NomesStore loja, String nome) {
    switch (loja.estadoBusca) {
      case Estado.carregando:
        return const Center(child: CircularProgressIndicator());
      case Estado.erro:
        return TelaDeErro(
          mensagem: loja.mensagemErroBusca!,
          aoTentarDeNovo: () => loja.buscar(nome),
        );
      case Estado.pronto:
        if (loja.decadas.isEmpty) return const TelaVazia('Nome não encontrado no Censo.');
        return _Grafico(decadas: loja.decadas);
    }
  }
}

// Uma coluna por década; a mais alta (o pico) fica escura.
class _Grafico extends StatelessWidget {
  final List<Decada> decadas;

  const _Grafico({required this.decadas});

  @override
  Widget build(BuildContext context) {
    final total = decadas.fold(0, (soma, d) => soma + d.frequencia);
    final pico = decadas.reduce((a, b) => b.frequencia > a.frequencia ? b : a);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${formatarNumero(total)} pessoas',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'nascidas por década, pico em ${pico.rotulo}',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final d in decadas)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: pico.frequencia == 0 ? 0 : 70 * d.frequencia / pico.frequencia,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        color: d == pico ? Colors.blue.shade800 : Colors.blue.shade200,
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(d.rotulo, style: const TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
