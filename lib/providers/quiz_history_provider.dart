import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_history_model.dart';
import '../repositories/quiz_history_repository.dart';

/// Disponibiliza o repositório responsável pelo histórico.
///
/// A interface depende apenas de [QuizHistoryRepository],
/// mantendo a implementação do Hive isolada.
final quizHistoryRepositoryProvider = Provider<QuizHistoryRepository>((ref) {
  return HiveQuizHistoryRepository();
});

/// Controlador responsável pelo estado do histórico.
///
/// Como a box do Hive já está aberta antes de [runApp],
/// a leitura inicial pode ser feita de forma síncrona.
class QuizHistoryNotifier extends Notifier<List<QuizHistoryModel>> {
  /// Repositório utilizado pelo controlador.
  QuizHistoryRepository get _repository {
    return ref.read(quizHistoryRepositoryProvider);
  }

  /// Carrega o estado inicial do histórico.
  @override
  List<QuizHistoryModel> build() {
    return _repository.getAll();
  }

  /// Guarda uma nova tentativa.
  ///
  /// Depois da persistência, a lista em memória é recarregada
  /// para que os ecrãs sejam actualizados automaticamente.
  Future<void> save(QuizHistoryModel history) async {
    await _repository.save(history);

    state = _repository.getAll();
  }

  /// Elimina uma tentativa específica.
  Future<void> delete(String id) async {
    await _repository.delete(id);

    state = _repository.getAll();
  }

  /// Elimina todo o histórico da aplicação.
  Future<void> clear() async {
    await _repository.clear();

    state = [];
  }

  /// Força uma nova leitura dos dados persistidos.
  ///
  /// Pode ser útil quando outras partes da aplicação alterarem
  /// directamente a base de dados.
  void refresh() {
    state = _repository.getAll();
  }
}

/// Provider responsável pelo histórico dos quizzes.
///
/// Qualquer alteração realizada pelo notifier reconstrói
/// automaticamente os widgets que observam este provider.
final quizHistoryProvider =
    NotifierProvider<QuizHistoryNotifier, List<QuizHistoryModel>>(
      QuizHistoryNotifier.new,
    );
