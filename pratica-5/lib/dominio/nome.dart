class Nome {
  final String nome;
  final int frequencia;
  final int ranking;

  Nome({
    required this.nome,
    required this.frequencia,
    required this.ranking,
  });

  // À esquerda os nomes do app, entre aspas os nomes que o IBGE manda.
  factory Nome.fromMap(Map<String, Object?> m) => Nome(
        nome: m['nome'] as String? ?? '(sem nome)',
        frequencia: m['frequencia'] as int? ?? 0,
        ranking: m['ranking'] as int? ?? 0,
      );
}
