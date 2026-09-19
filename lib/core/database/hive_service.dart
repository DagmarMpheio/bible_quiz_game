import 'package:bible_quiz_game/hive/hive_registrar.g.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../models/quiz_history_model.dart';
import 'hive_boxes.dart';

/// Serviço responsável pela inicialização do Hive CE.
///
/// Toda a configuração necessária para utilizar a base local
/// fica centralizada nesta classe.
///
/// Actualmente o serviço:
///
/// - inicializa o Hive;
/// - regista os adapters gerados;
/// - abre a box do histórico.
///
/// Futuramente poderão ser abertas aqui boxes relacionadas com:
///
/// - progresso;
/// - estatísticas;
/// - definições;
/// - conquistas;
/// - quiz diário.
class HiveService {
  /// Impede a criação de instâncias desta classe.
  HiveService._();

  /// Inicializa a base de dados local da aplicação.
  ///
  /// Este método deve ser executado antes de [runApp].
  static Future<void> initialize() async {
    /// Inicializa o Hive no directório adequado à plataforma.
    await Hive.initFlutter();

    /// Regista automaticamente todos os adapters gerados através
    /// do ficheiro `hive_adapters.dart`.
    Hive.registerAdapters();

    /// Abre a box responsável pelo histórico.
    ///
    /// A box fica disponível durante toda a execução da aplicação.
    await Hive.openBox<QuizHistoryModel>(HiveBoxes.quizHistory);
  }
}
