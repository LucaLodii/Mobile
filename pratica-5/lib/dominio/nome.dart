class Nome {
  final String nome;
  final int frequencia;
  final int ranking;

  Nome({
    required this.nome,
    required this.frequencia,
    required this.ranking,
  });

  factory Nome.fromJson(Map<String, dynamic> m) => Nome(
        nome: m['nome'] as String,
        frequencia: m['frequencia'] as int,
        ranking: m['ranking'] as int,
      );
}
