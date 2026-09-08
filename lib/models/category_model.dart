//==============================================
//Classe responsável por definir os modelos de dados do aplicativo.
//==============================================
enum QuizCategory {
  geral,
  antigoTestamento,
  novoTestamento,
  jesusCristo,
  personagens,
  reisEProfetas,
  livrosDaBiblia,
}

extension QuizCategoryExtension on QuizCategory {
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

class QuestionModel {
  final String id;

  final String question;

  final List<String> options;

  /// Índice da resposta correta dentro da lista `options`.
  final int correctAnswerIndex;

  final QuizCategory category;

  /// Pequena explicação apresentada depois da resposta.
  final String explanation;

  /// Referência bíblica relacionada com a pergunta.
  final String bibleReference;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    required this.explanation,
    required this.bibleReference,
  });
}
