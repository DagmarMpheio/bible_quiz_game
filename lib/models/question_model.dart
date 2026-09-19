import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';

/// Representa uma pergunta disponível no Quiz Bíblico.
///
/// Cada pergunta possui:
/// - um enunciado;
/// - alternativas de resposta;
/// - a resposta correcta;
/// - uma categoria;
/// - um nível de dificuldade;
/// - uma explicação;
/// - uma referência bíblica.
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

  /// Nível de dificuldade da pergunta.
  final QuizDifficulty difficulty;

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
    required this.difficulty,
    required this.explanation,
    required this.bibleReference,
  });

  /// Cria uma instância de [QuestionModel] a partir de um mapa JSON.
  ///
  /// Os valores de categoria e dificuldade são guardados no JSON
  /// através dos respectivos nomes internos dos enums.
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,

      /// Converte a lista dinâmica proveniente do JSON
      /// numa lista tipada de [String].
      options: List<String>.from(json['options'] as List),

      correctAnswerIndex: json['correctAnswerIndex'] as int,

      /// Converte, por exemplo, "jesusCristo" em
      /// [QuizCategory.jesusCristo].
      category: QuizCategory.values.byName(json['category'] as String),

      /// Converte, por exemplo, "medio" em
      /// [QuizDifficulty.medio].
      difficulty: QuizDifficulty.values.byName(json['difficulty'] as String),

      explanation: json['explanation'] as String,

      bibleReference: json['bibleReference'] as String,
    );
  }

  /// Converte a pergunta para um mapa compatível com JSON.
  ///
  /// Este método será útil mais tarde quando as perguntas forem
  /// guardadas no Hive CE ou sincronizadas com um serviço remoto.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,

      /// `.name` devolve apenas o nome interno do enum.
      'category': category.name,
      'difficulty': difficulty.name,

      'explanation': explanation,
      'bibleReference': bibleReference,
    };
  }
}
