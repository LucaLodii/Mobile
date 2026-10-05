class Habito {
  final int? id; // nulo enquanto não foi gravado no banco
  final String nome;
  final String meta;
  final String icone;

  Habito({
    this.id,
    required this.nome,
    required this.meta,
    required this.icone,
  });

  Map<String, Object?> toMap() =>
      {'id': id, 'nome': nome, 'meta': meta, 'icone': icone};

  factory Habito.fromMap(Map<String, Object?> m) => Habito(
        id: m['id'] as int?,
        nome: m['nome'] as String,
        meta: m['meta'] as String,
        icone: m['icone'] as String,
      );
}
