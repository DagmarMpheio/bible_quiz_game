import 'package:bible_quiz_game/models/quiz_mode.dart';

import 'achievement_model.dart';
import 'category_model.dart';
import 'difficulty_model.dart';
import 'quiz_history_model.dart';

/// Representa o progresso geral do utilizador.
///
/// Este modelo é derivado do histórico dos quizzes e não é
/// persistido directamente no Hive CE.
///
/// Actualmente contém:
///
/// - pontos de experiência;
/// - nível;
/// - progresso até ao próximo nível;
/// - sequência actual de dias;
/// - maior sequência de dias;
/// - conquistas.
class UserProgressModel {
  /// Quantidade de XP necessária para avançar um nível.
  static const int xpPerLevel = 500;

  /// XP total acumulado.
  final int totalXp;

  /// Nível actual do utilizador.
  ///
  /// O primeiro nível é sempre 1.
  final int level;

  /// XP já acumulado dentro do nível actual.
  final int currentLevelXp;

  /// Quantidade de XP ainda necessária para o próximo nível.
  final int xpToNextLevel;

  /// Número actual de dias consecutivos com quizzes realizados.
  final int currentStreak;

  /// Maior sequência de dias consecutivos já alcançada.
  final int longestStreak;

  /// Estado das conquistas disponíveis.
  final List<AchievementProgress> achievements;

  /// Cria o progresso do utilizador.
  const UserProgressModel({
    required this.totalXp,
    required this.level,
    required this.currentLevelXp,
    required this.xpToNextLevel,
    required this.currentStreak,
    required this.longestStreak,
    required this.achievements,
  });

  /// Cria um estado inicial sem qualquer progresso.
  factory UserProgressModel.empty() {
    return UserProgressModel.fromHistory(const []);
  }

  /// Calcula todo o progresso a partir do histórico existente.
  ///
  /// [referenceDate] é opcional e permite controlar a data utilizada
  /// no cálculo da sequência actual.
  ///
  /// Esta opção é especialmente útil nos testes unitários.
  factory UserProgressModel.fromHistory(
    List<QuizHistoryModel> history, {
    DateTime? referenceDate,
  }) {
    /// Utiliza a data actual quando nenhuma data específica
    /// tiver sido fornecida.
    final now = referenceDate ?? DateTime.now();

    /// Calcula o XP total de todas as tentativas.
    final totalXp = history.fold<int>(0, (total, item) {
      return total + _calculateQuizXp(item);
    });

    /// O nível começa em 1.
    ///
    /// Exemplos:
    ///
    /// 0-499 XP    -> nível 1
    /// 500-999 XP  -> nível 2
    /// 1000-1499   -> nível 3
    final level = (totalXp ~/ xpPerLevel) + 1;

    /// XP acumulado apenas dentro do nível actual.
    final currentLevelXp = totalXp % xpPerLevel;

    /// XP que falta para chegar ao próximo nível.
    final xpToNextLevel = xpPerLevel - currentLevelXp;

    /// Obtém apenas os dias distintos em que existiram quizzes.
    final quizDates =
        history.map((item) => _dateOnly(item.completedAt)).toSet().toList()
          ..sort();

    final longestStreak = _calculateLongestStreak(quizDates);

    final currentStreak = _calculateCurrentStreak(quizDates, now);

    /// Categorias principais já utilizadas.
    ///
    /// `QuizCategory.geral` não entra nesta conquista porque
    /// funciona como agregadora das restantes categorias.
    final completedCategories = history.map((item) => item.category).where((
      category,
    ) {
      return category != QuizCategory.geral;
    }).toSet();

    /// Verifica se existe pelo menos uma tentativa perfeita.
    final hasPerfectQuiz = history.any((item) {
      return item.totalQuestions > 0 &&
          item.correctAnswers == item.totalQuestions;
    });

    final achievements = <AchievementProgress>[
      AchievementProgress(
        type: AchievementType.primeiroQuiz,
        unlocked: history.isNotEmpty,
        currentValue: history.isEmpty ? 0 : 1,
        targetValue: 1,
      ),
      AchievementProgress(
        type: AchievementType.perfeccionista,
        unlocked: hasPerfectQuiz,
        currentValue: hasPerfectQuiz ? 1 : 0,
        targetValue: 1,
      ),
      AchievementProgress(
        type: AchievementType.veterano,
        unlocked: history.length >= 10,
        currentValue: history.length.clamp(0, 10),
        targetValue: 10,
      ),
      AchievementProgress(
        type: AchievementType.sequenciaTresDias,
        unlocked: longestStreak >= 3,
        currentValue: longestStreak.clamp(0, 3),
        targetValue: 3,
      ),
      AchievementProgress(
        type: AchievementType.exploradorBiblico,
        unlocked: completedCategories.length >= 6,
        currentValue: completedCategories.length.clamp(0, 6),
        targetValue: 6,
      ),
    ];

    return UserProgressModel(
      totalXp: totalXp,
      level: level,
      currentLevelXp: currentLevelXp,
      xpToNextLevel: xpToNextLevel,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      achievements: achievements,
    );
  }

  /// Percentagem de progresso dentro do nível actual.
  double get levelProgress {
    return currentLevelXp / xpPerLevel;
  }

  /// Quantidade de conquistas já desbloqueadas.
  int get unlockedAchievements {
    return achievements.where((achievement) => achievement.unlocked).length;
  }

  /// Calcula o XP recebido por uma tentativa.
  ///
  /// Regras:
  ///
  /// - 10 XP por resposta correcta;
  /// - 20 XP por concluir;
  /// - Médio: +25 XP;
  /// - Difícil: +50 XP;
  /// - Quiz Diário: +75 XP.
  static int _calculateQuizXp(QuizHistoryModel history) {
    final correctAnswerXp = history.correctAnswers * 10;

    const completionXp = 20;

    final difficultyXp = switch (history.difficulty) {
      QuizDifficulty.facil => 0,
      QuizDifficulty.medio => 25,
      QuizDifficulty.dificil => 50,
    };

    /// O desafio diário oferece um bónus adicional para
    /// incentivar a utilização regular da aplicação.
    final dailyBonusXp = history.mode == QuizMode.daily ? 75 : 0;

    return correctAnswerXp + completionXp + difficultyXp + dailyBonusXp;
  }

  /// Retorna apenas a componente da data.
  ///
  /// Horas, minutos e segundos são removidos para que vários
  /// quizzes realizados no mesmo dia contem apenas como um dia
  /// na sequência.
  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Retorna o dia imediatamente anterior.
  static DateTime _previousDay(DateTime date) {
    return DateTime(date.year, date.month, date.day - 1);
  }

  /// Calcula a maior sequência de dias consecutivos
  /// encontrada em todo o histórico.
  static int _calculateLongestStreak(List<DateTime> dates) {
    if (dates.isEmpty) {
      return 0;
    }

    int longest = 1;
    int current = 1;

    for (int index = 1; index < dates.length; index++) {
      final expectedDate = _previousDay(dates[index]);

      if (dates[index - 1] == expectedDate) {
        current++;

        if (current > longest) {
          longest = current;
        }
      } else {
        current = 1;
      }
    }

    return longest;
  }

  /// Calcula a sequência actual.
  ///
  /// Para a sequência continuar activa, a última actividade
  /// deve ter acontecido hoje ou ontem.
  ///
  /// Se o utilizador ficar mais de um dia sem realizar
  /// qualquer quiz, a sequência actual regressa a zero.
  static int _calculateCurrentStreak(
    List<DateTime> dates,
    DateTime referenceDate,
  ) {
    if (dates.isEmpty) {
      return 0;
    }

    final today = _dateOnly(referenceDate);

    final yesterday = _previousDay(today);

    final lastQuizDate = dates.last;

    if (lastQuizDate != today && lastQuizDate != yesterday) {
      return 0;
    }

    int streak = 1;
    var expectedPreviousDate = _previousDay(lastQuizDate);

    for (int index = dates.length - 2; index >= 0; index--) {
      if (dates[index] == expectedPreviousDate) {
        streak++;

        expectedPreviousDate = _previousDay(dates[index]);
      } else {
        break;
      }
    }

    return streak;
  }
}
