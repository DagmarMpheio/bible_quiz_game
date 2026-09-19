import 'package:hive_ce/hive_ce.dart';

import '../core/database/hive_boxes.dart';
import '../models/quiz_history_model.dart';

/// Define as operações disponíveis para o histórico dos quizzes.
///
/// Utilizamos uma abstracção para impedir que os ecrãs dependam
/// directamente do Hive CE.
///
/// Desta forma, poderemos futuramente substituir ou complementar
/// o armazenamento local sem alterar a interface da aplicação.
abstract class QuizHistoryRepository {
  /// Guarda uma tentativa concluída.
  Future<void> save(QuizHistoryModel history);

  /// Retorna todas as tentativas guardadas.
  List<QuizHistoryModel> getAll();

  /// Elimina uma tentativa específica.
  Future<void> delete(String id);

  /// Elimina todo o histórico.
  Future<void> clear();
}

/// Implementação do histórico utilizando Hive CE.
class HiveQuizHistoryRepository implements QuizHistoryRepository {
  /// Obtém a box já aberta durante a inicialização da aplicação.
  Box<QuizHistoryModel> get _box {
    return Hive.box<QuizHistoryModel>(HiveBoxes.quizHistory);
  }

  /// Guarda uma tentativa na base local.
  ///
  /// O [QuizHistoryModel.id] é utilizado como chave.
  ///
  /// Isto torna a operação idempotente: se tentarmos guardar
  /// novamente a mesma sessão, o registo existente será actualizado
  /// em vez de criar uma duplicação.
  @override
  Future<void> save(QuizHistoryModel history) async {
    await _box.put(history.id, history);
  }

  /// Obtém todas as tentativas realizadas.
  ///
  /// Os registos são ordenados do mais recente para o mais antigo.
  @override
  List<QuizHistoryModel> getAll() {
    final history = _box.values.toList();

    history.sort((first, second) {
      return second.completedAt.compareTo(first.completedAt);
    });

    return history;
  }

  /// Elimina uma sessão através do respectivo identificador.
  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Remove todos os registos existentes no histórico.
  @override
  Future<void> clear() async {
    await _box.clear();
  }
}
