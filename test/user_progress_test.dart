import 'package:bible_quiz_game/models/achievement_model.dart';
import 'package:bible_quiz_game/models/quiz_history_model.dart';
import 'package:bible_quiz_game/models/user_progress_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testa as regras de progressão do Quiz Bíblico.
///
/// Como o progresso é calculado directamente a partir do histórico,
/// os testes não precisam de inicializar o Hive CE.
void main() {
  group('UserProgressModel', () {
    test('deve iniciar no nível 1 quando não existe histórico', () {
      final progress = UserProgressModel.fromHistory(const []);

      expect(progress.totalXp, 0);

      expect(progress.level, 1);

      expect(progress.currentStreak, 0);

      expect(progress.longestStreak, 0);
    });

    test('deve calcular correctamente o XP', () {
      final history = [
        QuizHistoryModel(
          id: 'quiz-1',
          categoryName: 'antigoTestamento',
          difficultyName: 'facil',
          correctAnswers: 8,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 18),
        ),
        QuizHistoryModel(
          id: 'quiz-2',
          categoryName: 'jesusCristo',
          difficultyName: 'dificil',
          correctAnswers: 10,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 19),
        ),
      ];

      final progress = UserProgressModel.fromHistory(history);

      /// Fácil:
      /// 8 × 10 + 20 = 100 XP
      ///
      /// Difícil:
      /// 10 × 10 + 20 + 50 = 170 XP
      ///
      /// Total = 270 XP.
      expect(progress.totalXp, 270);

      expect(progress.level, 1);

      expect(progress.currentLevelXp, 270);

      expect(progress.xpToNextLevel, 230);
    });

    test('deve calcular uma sequência de três dias', () {
      final history = [
        QuizHistoryModel(
          id: 'quiz-1',
          categoryName: 'antigoTestamento',
          difficultyName: 'facil',
          correctAnswers: 5,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 18),
        ),
        QuizHistoryModel(
          id: 'quiz-2',
          categoryName: 'novoTestamento',
          difficultyName: 'facil',
          correctAnswers: 5,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 19),
        ),
        QuizHistoryModel(
          id: 'quiz-3',
          categoryName: 'jesusCristo',
          difficultyName: 'facil',
          correctAnswers: 5,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 20),
        ),
      ];

      final progress = UserProgressModel.fromHistory(
        history,
        referenceDate: DateTime(2026, 9, 20),
      );

      expect(progress.currentStreak, 3);

      expect(progress.longestStreak, 3);
    });

    test('deve desbloquear a conquista de quiz perfeito', () {
      final history = [
        QuizHistoryModel(
          id: 'quiz-1',
          categoryName: 'jesusCristo',
          difficultyName: 'dificil',
          correctAnswers: 10,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 20),
        ),
      ];

      final progress = UserProgressModel.fromHistory(history);

      final achievement = progress.achievements.firstWhere(
        (item) => item.type == AchievementType.perfeccionista,
      );

      expect(achievement.unlocked, isTrue);
    });
  });
}
