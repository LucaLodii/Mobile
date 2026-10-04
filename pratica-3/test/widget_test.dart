import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/dados/habitos_repositorio.dart';
import 'package:flutter_application_1/dominio/habitos_store.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('adiciona e remove um hábito', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => HabitosStore(HabitosRepositorio())..carregar(),
        child: const MeuApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nenhum hábito cadastrado.'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Nome do hábito'), 'Ler');
    await tester.enterText(find.widgetWithText(TextField, 'Meta'), '10 páginas por dia');
    await tester.tap(find.text('Salvar Hábito'));
    await tester.pumpAndSettle();

    expect(find.text('Ler'), findsOneWidget);
    expect(find.text('10 páginas por dia'), findsOneWidget);

    await tester.tap(find.text('Ler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir Hábito'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum hábito cadastrado.'), findsOneWidget);
  });
}
