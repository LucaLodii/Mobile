import 'package:flutter/material.dart';
import '../dados/preferencias.dart';
import 'tela_habitos.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    lerUltimaAba().then((indice) {
      if (mounted) setState(() => indiceAtual = indice);
    });
  }

  @override
  Widget build(BuildContext context) {
    final telas = const [
      TelaHabitos(),
      Center(child: Text('Resumo em construção...')),
      Center(child: Text('Perfil em construção...')),
    ];

    return Scaffold(
      body: telas[indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceAtual,
        onTap: (indice) {
          setState(() {
            indiceAtual = indice;
          });
          salvarUltimaAba(indice);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Resumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
