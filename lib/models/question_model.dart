import 'package:bible_quiz_game/models/category_model.dart';

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
