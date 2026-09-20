import 'category_model.dart';
import 'difficulty_model.dart';
import 'quiz_history_model.dart';

/// Representa um resumo de desempenho para um determinado grupo
/// de quizzes.
///
/// Pode ser utilizado, por exemplo, para representar:
///
/// - uma categoria;
/// - um nível de dificuldade;
/// - qualquer outro agrupamento futuro.
class QuizPerformanceSummary {
  /// Quantidade de quizzes realizados neste grupo.
  final int totalQuizzes;

  /// Quantidade total de respostas correctas.
  final int correctAnswers;

  /// Quantidade total de perguntas respondidas.
  final int totalAnswers;

  /// Cria um resumo de desempenho.
  const QuizPerformanceSummary({
    required this.totalQuizzes,
    required this.correctAnswers,
    required this.totalAnswers,
  });

  /// Quantidade total de respostas incorrectas.
  int get incorrectAnswers {
    return totalAnswers - correctAnswers;
  }

  /// Percentagem global de respostas correctas.
  ///
  /// A taxa é calculada através da relação:
  ///
  /// respostas correctas / total de respostas × 100
  ///
  /// Isto é preferível a calcular simplesmente a média das
  /// percentagens dos quizzes, porque continua correcto caso
  /// futuramente existam quizzes com quantidades diferentes
  /// de perguntas.
  double get accuracy {
    if (totalAnswers == 0) {
      return 0;
    }

    return (correctAnswers / totalAnswers) * 100;
  }
}

/// Representa todas as estatísticas calculadas a partir
/// do histórico do utilizador.
///
/// Este modelo não é persistido no Hive.
///
/// Os seus valores são derivados sempre que o histórico é alterado,
/// evitando duplicação de informação na base de dados.
class QuizStatisticsModel {
  /// Número total de quizzes concluídos.
  final int totalQuizzes;

  /// Quantidade total de perguntas respondidas.
  final int totalAnswers;

  /// Quantidade total de respostas correctas.
  final int correctAnswers;

  /// Melhor tentativa encontrada no histórico.
  ///
  /// É `null` quando o utilizador ainda não concluiu nenhum quiz.
  final QuizHistoryModel? bestResult;

  /// Estatísticas agrupadas por categoria.
  final Map<QuizCategory, QuizPerformanceSummary> byCategory;

  /// Estatísticas agrupadas por dificuldade.
  final Map<QuizDifficulty, QuizPerformanceSummary> byDifficulty;

  /// Cria o conjunto completo de estatísticas.
  const QuizStatisticsModel({
    required this.totalQuizzes,
    required this.totalAnswers,
    required this.correctAnswers,
    required this.bestResult,
    required this.byCategory,
    required this.byDifficulty,
  });

  /// Cria estatísticas vazias.
  factory QuizStatisticsModel.empty() {
    return const QuizStatisticsModel(
      totalQuizzes: 0,
      totalAnswers: 0,
      correctAnswers: 0,
      bestResult: null,
      byCategory: {},
      byDifficulty: {},
    );
  }

  /// Calcula as estatísticas a partir do histórico existente.
  ///
  /// Nenhuma informação adicional é guardada no Hive.
  factory QuizStatisticsModel.fromHistory(List<QuizHistoryModel> history) {
    /// Caso não existam tentativas, retorna imediatamente
    /// um conjunto vazio de estatísticas.
    if (history.isEmpty) {
      return QuizStatisticsModel.empty();
    }

    int totalAnswers = 0;
    int correctAnswers = 0;

    /// Estruturas temporárias utilizadas para acumular
    /// os resultados por categoria.
    final categoryQuizzes = <QuizCategory, int>{};
    final categoryCorrect = <QuizCategory, int>{};
    final categoryAnswers = <QuizCategory, int>{};

    /// Estruturas temporárias utilizadas para acumular
    /// os resultados por dificuldade.
    final difficultyQuizzes = <QuizDifficulty, int>{};
    final difficultyCorrect = <QuizDifficulty, int>{};
    final difficultyAnswers = <QuizDifficulty, int>{};

    /// Inicialmente consideramos a primeira tentativa como
    /// o melhor resultado.
    QuizHistoryModel bestResult = history.first;

    for (final item in history) {
      totalAnswers += item.totalQuestions;
      correctAnswers += item.correctAnswers;

      final category = item.category;
      final difficulty = item.difficulty;

      /// Acumula os valores da categoria.
      categoryQuizzes.update(category, (value) => value + 1, ifAbsent: () => 1);

      categoryCorrect.update(
        category,
        (value) => value + item.correctAnswers,
        ifAbsent: () => item.correctAnswers,
      );

      categoryAnswers.update(
        category,
        (value) => value + item.totalQuestions,
        ifAbsent: () => item.totalQuestions,
      );

      /// Acumula os valores da dificuldade.
      difficultyQuizzes.update(
        difficulty,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      difficultyCorrect.update(
        difficulty,
        (value) => value + item.correctAnswers,
        ifAbsent: () => item.correctAnswers,
      );

      difficultyAnswers.update(
        difficulty,
        (value) => value + item.totalQuestions,
        ifAbsent: () => item.totalQuestions,
      );

      /// Uma percentagem superior substitui o melhor resultado.
      if (item.percentage > bestResult.percentage) {
        bestResult = item;
      }
      /// Em caso de empate na percentagem, damos preferência
      /// à tentativa com maior número absoluto de respostas correctas.
      else if (item.percentage == bestResult.percentage &&
          item.correctAnswers > bestResult.correctAnswers) {
        bestResult = item;
      }
      /// Se os resultados continuarem empatados, consideramos
      /// a tentativa mais recente.
      else if (item.percentage == bestResult.percentage &&
          item.correctAnswers == bestResult.correctAnswers &&
          item.completedAt.isAfter(bestResult.completedAt)) {
        bestResult = item;
      }
    }

    /// Constrói os resumos finais por categoria.
    final byCategory = <QuizCategory, QuizPerformanceSummary>{};

    for (final category in categoryQuizzes.keys) {
      byCategory[category] = QuizPerformanceSummary(
        totalQuizzes: categoryQuizzes[category] ?? 0,
        correctAnswers: categoryCorrect[category] ?? 0,
        totalAnswers: categoryAnswers[category] ?? 0,
      );
    }

    /// Constrói os resumos finais por dificuldade.
    final byDifficulty = <QuizDifficulty, QuizPerformanceSummary>{};

    for (final difficulty in difficultyQuizzes.keys) {
      byDifficulty[difficulty] = QuizPerformanceSummary(
        totalQuizzes: difficultyQuizzes[difficulty] ?? 0,
        correctAnswers: difficultyCorrect[difficulty] ?? 0,
        totalAnswers: difficultyAnswers[difficulty] ?? 0,
      );
    }

    return QuizStatisticsModel(
      totalQuizzes: history.length,
      totalAnswers: totalAnswers,
      correctAnswers: correctAnswers,
      bestResult: bestResult,
      byCategory: byCategory,
      byDifficulty: byDifficulty,
    );
  }

  /// Quantidade total de respostas incorrectas.
  int get incorrectAnswers {
    return totalAnswers - correctAnswers;
  }

  /// Taxa global de respostas correctas.
  double get accuracy {
    if (totalAnswers == 0) {
      return 0;
    }

    return (correctAnswers / totalAnswers) * 100;
  }
}
