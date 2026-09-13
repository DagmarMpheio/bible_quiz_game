/// Enumera todas as categorias disponíveis no Quiz Bíblico.
///
/// Cada valor representa um grupo temático usado para filtrar as perguntas
/// apresentadas ao utilizador.
enum QuizCategory {
  /// Perguntas que podem pertencer a qualquer tema da Bíblia.
  geral,

  /// Perguntas relacionadas com o Antigo Testamento.
  antigoTestamento,

  /// Perguntas relacionadas com o Novo Testamento.
  novoTestamento,

  /// Perguntas relacionadas diretamente com Jesus Cristo.
  jesusCristo,

  /// Perguntas sobre personagens bíblicos.
  personagens,

  /// Perguntas sobre reis e profetas.
  reisEProfetas,

  /// Perguntas relacionadas com os livros que compõem a Bíblia.
  livrosDaBiblia,
}

/// Adiciona propriedades auxiliares ao enum [QuizCategory].
///
/// A extensão permite manter a representação visual da categoria próxima do
/// próprio enum, evitando condicionais repetidas nas telas.
extension QuizCategoryExtension on QuizCategory {
  /// Retorna o título legível apresentado na interface para cada categoria.
  String get title {
    switch (this) {
      case QuizCategory.geral:
        return 'Perguntas Gerais';

      case QuizCategory.antigoTestamento:
        return 'Antigo Testamento';

      case QuizCategory.novoTestamento:
        return 'Novo Testamento';

      case QuizCategory.jesusCristo:
        return 'Jesus Cristo';

      case QuizCategory.personagens:
        return 'Personagens Bíblicos';

      case QuizCategory.reisEProfetas:
        return 'Reis e Profetas';

      case QuizCategory.livrosDaBiblia:
        return 'Livros da Bíblia';
    }
  }
}
