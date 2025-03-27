class ServicoVtr {
  final int cod;
  final int capacidadeMaxima;
  final double valor;
  final double valorAnterior;
  final double pontos;
  final String descricao;

  ServicoVtr(this.cod, this.capacidadeMaxima, this.valor, this.valorAnterior,
      this.pontos, this.descricao);

  ServicoVtr.fromJson(Map<String, dynamic> json)
      : cod = json['cod'],
        capacidadeMaxima = json['capacidadeMaxima'],
        valor = json['valor'],
        valorAnterior = json['valorAnterior'] ?? 0,
        pontos = json['pontos'],
        descricao = json['descricao'] ?? '';

  Map<String, dynamic> toJson() => {
        'cod': cod,
        'capacidadeMaxima': capacidadeMaxima,
        'valor': valor,
        'valorAnterior': valorAnterior,
        'pontos': pontos,
        'descricao': descricao,
      };
}
