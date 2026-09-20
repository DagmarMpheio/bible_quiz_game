import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/daily_quiz_model.dart';
import '../services/daily_quiz_service.dart';
import 'quiz_history_provider.dart';
import 'quiz_provider.dart';

/// Disponibiliza o Quiz Diário correspondente ao dia actual.
///
/// O provider observa também o histórico.
///
/// Assim que o desafio diário for concluído e guardado,
/// este provider é automaticamente recalculado e passa
/// a indicar que o desafio já foi realizado.
final dailyQuizProvider = FutureProvider<DailyQuizModel>((ref) async {
  /// Obtém o repositório de perguntas já utilizado
  /// pelo restante sistema do quiz.
  final repository = ref.watch(questionRepositoryProvider);

  /// Observa o histórico para detectar automaticamente
  /// a conclusão do desafio diário.
  final history = ref.watch(quizHistoryProvider);

  /// Carrega o banco completo de perguntas.
  final questions = await repository.getAllQuestions();

  /// Gera o desafio correspondente ao dia actual.
  return DailyQuizService.create(
    questions: questions,
    history: history,
    date: DateTime.now(),
  );
});
