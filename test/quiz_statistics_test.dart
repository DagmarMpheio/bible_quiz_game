import 'package:bible_quiz_game/models/quiz_statistics_model.dart';
import 'package:bible_quiz_game/models/quiz_history_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testa os cálculos utilizados pelo ecrã de estatísticas.
///
/// Estes testes não dependem do Hive porque
/// [QuizStatisticsModel] trabalha apenas com os dados
/// recebidos através do histórico.
void main() {
  group('QuizStatisticsModel', () {
    test('deve retornar estatísticas vazias quando não existe histórico', () {
      final statistics = QuizStatisticsModel.fromHistory(const []);

      expect(statistics.totalQuizzes, 0);

      expect(statistics.totalAnswers, 0);

      expect(statistics.correctAnswers, 0);

      expect(statistics.accuracy, 0);

      expect(statistics.bestResult, isNull);
    });

    test('deve calcular correctamente as estatísticas gerais', () {
      final history = [
        QuizHistoryModel(
          id: 'quiz-1',
          categoryName: 'antigoTestamento',
          difficultyName: 'facil',
          correctAnswers: 8,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 19),
        ),
        QuizHistoryModel(
          id: 'quiz-2',
          categoryName: 'novoTestamento',
          difficultyName: 'medio',
          correctAnswers: 6,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 20),
        ),
      ];

      final statistics = QuizStatisticsModel.fromHistory(history);

      expect(statistics.totalQuizzes, 2);

      expect(statistics.totalAnswers, 20);

      expect(statistics.correctAnswers, 14);

      expect(statistics.incorrectAnswers, 6);

      expect(statistics.accuracy, 70);
    });

    test('deve identificar correctamente o melhor resultado', () {
      final history = [
        QuizHistoryModel(
          id: 'quiz-1',
          categoryName: 'antigoTestamento',
          difficultyName: 'facil',
          correctAnswers: 7,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 19),
        ),
        QuizHistoryModel(
          id: 'quiz-2',
          categoryName: 'jesusCristo',
          difficultyName: 'dificil',
          correctAnswers: 9,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 20),
        ),
      ];

      final statistics = QuizStatisticsModel.fromHistory(history);

      expect(statistics.bestResult?.id, 'quiz-2');

      expect(statistics.bestResult?.percentage, 90);
    });

    test('deve agrupar correctamente os resultados por categoria', () {
      final history = [
        QuizHistoryModel(
          id: 'quiz-1',
          categoryName: 'antigoTestamento',
          difficultyName: 'facil',
          correctAnswers: 8,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 19),
        ),
        QuizHistoryModel(
          id: 'quiz-2',
          categoryName: 'antigoTestamento',
          difficultyName: 'medio',
          correctAnswers: 6,
          totalQuestions: 10,
          completedAt: DateTime(2026, 9, 20),
        ),
      ];

      final statistics = QuizStatisticsModel.fromHistory(history);

      final category = statistics.byCategory.values.first;

      expect(category.totalQuizzes, 2);

      expect(category.correctAnswers, 14);

      expect(category.totalAnswers, 20);

      expect(category.accuracy, 70);
    });
  });
}
