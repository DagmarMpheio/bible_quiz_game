import '../models/daily_quiz_model.dart';
import '../models/difficulty_model.dart';
import '../models/question_model.dart';
import '../models/quiz_history_model.dart';

/// Serviço responsável pelas regras do Quiz Diário.
///
/// A selecção é determinística.
///
/// Isto significa que duas execuções realizadas no mesmo dia,
/// utilizando o mesmo banco de perguntas, produzem exactamente
/// o mesmo conjunto de perguntas.
class DailyQuizService {
  /// Quantidade de perguntas apresentadas diariamente.
  static const int dailyQuestionCount = 5;

  /// Impede a criação de instâncias desta classe.
  DailyQuizService._();

  /// Cria o Quiz Diário correspondente à data indicada.
  ///
  /// [questions] contém todo o banco de perguntas.
  ///
  /// [history] é utilizado para verificar se o desafio
  /// deste dia já foi concluído.
  ///
  /// [date] representa a data utilizada para gerar o desafio.
  static DailyQuizModel create({
    required List<QuestionModel> questions,
    required List<QuizHistoryModel> history,
    required DateTime date,
  }) {
    /// Remove a componente de hora para trabalhar apenas
    /// com a data do calendário.
    final normalizedDate = _dateOnly(date);

    /// Cria um identificador estável para a data.
    final dateKey = _formatDateKey(normalizedDate);

    /// Obtém a dificuldade correspondente ao dia.
    final difficulty = _difficultyForDate(normalizedDate);

    /// Considera apenas perguntas da dificuldade seleccionada.
    final candidates = questions.where((question) {
      return question.difficulty == difficulty;
    }).toList();

    /// O Quiz Diário necessita de pelo menos cinco perguntas.
    if (candidates.length < dailyQuestionCount) {
      throw StateError(
        'Não existem perguntas suficientes para criar '
        'o Quiz Diário de dificuldade ${difficulty.name}.',
      );
    }

    /// Ordena as perguntas através de um valor determinístico.
    ///
    /// Não utilizamos `shuffle()` porque queremos que o mesmo
    /// dia produza sempre exactamente o mesmo conjunto.
    candidates.sort((first, second) {
      final firstScore = _stableHash('$dateKey:${first.id}');

      final secondScore = _stableHash('$dateKey:${second.id}');

      final comparison = firstScore.compareTo(secondScore);

      /// Caso extremamente raro de colisão,
      /// o ID garante uma ordem estável.
      if (comparison == 0) {
        return first.id.compareTo(second.id);
      }

      return comparison;
    });

    /// Selecciona as primeiras cinco perguntas
    /// depois da ordenação determinística.
    final dailyQuestions = candidates.take(dailyQuestionCount).toList();

    QuizHistoryModel? completedHistory;

    final expectedSessionId = 'daily-$dateKey';

    /// Procura no histórico uma tentativa correspondente
    /// exactamente ao desafio deste dia.
    for (final item in history) {
      if (item.id == expectedSessionId) {
        completedHistory = item;
        break;
      }
    }

    return DailyQuizModel(
      dateKey: dateKey,
      difficulty: difficulty,
      questions: dailyQuestions,
      completedHistory: completedHistory,
    );
  }

  /// Determina a dificuldade diária.
  ///
  /// As dificuldades são alternadas:
  ///
  /// Fácil → Médio → Difícil → Fácil...
  static QuizDifficulty _difficultyForDate(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);

    final dayIndex = date.difference(firstDayOfYear).inDays;

    return QuizDifficulty.values[dayIndex % QuizDifficulty.values.length];
  }

  /// Remove horas, minutos, segundos e milissegundos.
  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Formata uma data no padrão `AAAA-MM-DD`.
  static String _formatDateKey(DateTime date) {
    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${date.year}-'
        '${twoDigits(date.month)}-'
        '${twoDigits(date.day)}';
  }

  /// Cria um hash determinístico para uma String.
  ///
  /// Utilizamos uma implementação simples do algoritmo FNV-1a.
  ///
  /// Diferentemente de depender de valores aleatórios,
  /// este cálculo produz o mesmo resultado para a mesma entrada.
  static int _stableHash(String value) {
    int hash = 0x811C9DC5;

    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;

      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }

    return hash;
  }
}
