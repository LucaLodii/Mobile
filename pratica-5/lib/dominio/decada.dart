class Decada {
  final String rotulo;
  final int frequencia;

  Decada({required this.rotulo, required this.frequencia});

  // O IBGE manda o período como "[1930,1940[" ou "1930[" (antes de 1930).
  factory Decada.fromMap(Map<String, Object?> m) {
    final periodo = m['periodo'] as String? ?? '';
    final ano = RegExp(r'\d{4}').firstMatch(periodo)?.group(0) ?? '?';
    return Decada(
      rotulo: periodo.startsWith('[') ? ano : '< $ano',
      frequencia: m['frequencia'] as int? ?? 0,
    );
  }
}
