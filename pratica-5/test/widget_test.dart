import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/dados/ibge_api.dart';
import 'package:flutter_application_1/dominio/decada.dart';
import 'package:flutter_application_1/dominio/nome.dart';
import 'package:flutter_application_1/dominio/nomes_store.dart';
import 'package:flutter_application_1/main.dart';

// Os testes do Flutter bloqueiam a internet, então a API é trocada por dados fixos.
class FakeIbgeApi extends IbgeApi {
  @override
  Future<List<Nome>> ranking({String? sexo}) async => [
        Nome(nome: 'MARIA', frequencia: 11734129, ranking: 1),
        Nome(nome: 'JOSE', frequencia: 5754529, ranking: 2),
      ];

  @override
  Future<List<Decada>> historico(String nome) async => [
        Decada(rotulo: '1990', frequencia: 3308),
        Decada(rotulo: '2000', frequencia: 7013),
      ];
}

void main() {
  testWidgets('mostra o ranking e abre o histórico de um nome', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NomesStore(FakeIbgeApi())..carregar(),
        child: const MeuApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MARIA'), findsOneWidget);
    expect(find.text('11.734.129 pessoas'), findsOneWidget);

    await tester.tap(find.text('JOSE'));
    await tester.pumpAndSettle();

    expect(find.text('10.321 pessoas'), findsOneWidget);
    expect(find.text('7.013'), findsOneWidget);
  });
}
