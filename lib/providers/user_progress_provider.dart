import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_progress_model.dart';
import 'quiz_history_provider.dart';

/// Calcula automaticamente o progresso do utilizador
/// a partir do histórico dos quizzes.
///
/// Não possui estado próprio nem escreve directamente no Hive.
///
/// Sempre que [quizHistoryProvider] mudar, este provider
/// é recalculado automaticamente.
final userProgressProvider = Provider<UserProgressModel>((ref) {
  /// Observa o histórico persistido.
  final history = ref.watch(quizHistoryProvider);

  /// Constrói o progresso utilizando os dados existentes.
  return UserProgressModel.fromHistory(history);
});
