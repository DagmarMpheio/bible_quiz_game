import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_statistics_model.dart';
import 'quiz_history_provider.dart';

/// Provider responsável por calcular as estatísticas
/// do utilizador.
///
/// Este provider observa [quizHistoryProvider].
///
/// Sempre que:
///
/// - um novo quiz for guardado;
/// - uma tentativa for eliminada;
/// - todo o histórico for limpo;
///
/// as estatísticas são recalculadas automaticamente.
final quizStatisticsProvider = Provider<QuizStatisticsModel>((ref) {
  /// Obtém o histórico actualmente persistido.
  final history = ref.watch(quizHistoryProvider);

  /// Calcula as estatísticas exclusivamente a partir
  /// dos dados existentes no histórico.
  return QuizStatisticsModel.fromHistory(history);
});
