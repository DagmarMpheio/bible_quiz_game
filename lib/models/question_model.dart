import 'package:bible_quiz_game/models/category_model.dart';

/// Representa uma pergunta disponível no Quiz Bíblico.
///
/// Cada instância contém todos os dados necessários para apresentar uma
/// pergunta, validar a resposta selecionada pelo utilizador e apresentar uma
/// explicação após a resposta.
class QuestionModel {
  /// Identificador único da pergunta.
  final String id;

  /// Texto ou enunciado apresentado ao utilizador.
  final String question;

  /// Lista de alternativas disponíveis para a pergunta.
  ///
  /// A posição de cada item é importante porque [correctAnswerIndex] utiliza
  /// o índice desta lista para identificar a alternativa correta.
  final List<String> options;

  /// Índice da resposta correta dentro da lista [options].
  ///
  /// Exemplo:
  /// - `0` corresponde à primeira alternativa;
  /// - `1` corresponde à segunda alternativa;
  /// - e assim sucessivamente.
  final int correctAnswerIndex;

  /// Categoria temática à qual a pergunta pertence.
  final QuizCategory category;

  /// Pequena explicação apresentada depois de o utilizador responder.
  final String explanation;

  /// Referência bíblica relacionada com a resposta da pergunta.
  final String bibleReference;

  /// Cria uma pergunta do Quiz Bíblico.
  ///
  /// Todos os campos são obrigatórios para garantir que a pergunta possui as
  /// informações mínimas necessárias para ser utilizada pelo aplicativo.
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
