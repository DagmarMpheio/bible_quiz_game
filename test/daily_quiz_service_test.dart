import 'dart:convert';

import 'package:bible_quiz_game/models/question_model.dart';
import 'package:bible_quiz_game/services/daily_quiz_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testa as regras fundamentais do Quiz Diário.
///
/// É utilizado o próprio banco de perguntas da aplicação para
/// garantir que a funcionalidade também funciona com os dados reais.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Carrega o banco local de perguntas.
  Future<List<QuestionModel>> loadQuestions() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/questions.json',
    );

    final decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded.map((item) {
      return QuestionModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  group('DailyQuizService', () {
    test('deve gerar cinco perguntas', () async {
      final questions = await loadQuestions();

      final daily = DailyQuizService.create(
        questions: questions,
        history: const [],
        date: DateTime(2026, 9, 20),
      );

      expect(daily.questions.length, 5);
    });

    test(
      'deve gerar exactamente as mesmas perguntas para a mesma data',
      () async {
        final questions = await loadQuestions();

        final first = DailyQuizService.create(
          questions: questions,
          history: const [],
          date: DateTime(2026, 9, 20),
        );

        final second = DailyQuizService.create(
          questions: questions,
          history: const [],
          date: DateTime(2026, 9, 20),
        );

        expect(
          first.questions.map((question) => question.id).toList(),
          second.questions.map((question) => question.id).toList(),
        );
      },
    );

    test('as perguntas devem respeitar a dificuldade do dia', () async {
      final questions = await loadQuestions();

      final daily = DailyQuizService.create(
        questions: questions,
        history: const [],
        date: DateTime(2026, 9, 20),
      );

      for (final question in daily.questions) {
        expect(question.difficulty, daily.difficulty);
      }
    });

    test('não deve repetir perguntas dentro do mesmo desafio', () async {
      final questions = await loadQuestions();

      final daily = DailyQuizService.create(
        questions: questions,
        history: const [],
        date: DateTime(2026, 9, 20),
      );

      final ids = daily.questions.map((question) => question.id).toSet();

      expect(ids.length, daily.questions.length);
    });
  });
}
