class PatrimonioItem {
  final int? id;
  final String nome;
  final String descricao;
  final String numeroDeSerie;
  final String codigoDeBarras;
  final DateTime dataDeAquisicao;
  final String status;

  PatrimonioItem({
    this.id,
    required this.nome,
    required this.descricao,
    required this.numeroDeSerie,
    required this.codigoDeBarras,
    required this.dataDeAquisicao,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'numeroDeSerie': numeroDeSerie,
      'codigoDeBarras': codigoDeBarras,
      'dataDeAquisicao': dataDeAquisicao.toIso8601String(),
      'status': status,
    };
  }

  factory PatrimonioItem.fromMap(Map<String, dynamic> map) {
    return PatrimonioItem(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      numeroDeSerie: map['numeroDeSerie'],
      codigoDeBarras: map['codigoDeBarras'],
      dataDeAquisicao: DateTime.parse(map['dataDeAquisicao']),
      status: map['status'],
    );
  }
}
