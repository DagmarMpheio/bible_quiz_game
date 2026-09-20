import 'difficulty_model.dart';
import 'question_model.dart';
import 'quiz_history_model.dart';

/// Representa o desafio diário disponibilizado pela aplicação.
///
/// O conteúdo é calculado dinamicamente a partir:
///
/// - da data actual;
/// - do banco local de perguntas;
/// - do histórico do utilizador.
///
/// Este modelo não é guardado directamente no Hive.
class DailyQuizModel {
  /// Identificador textual da data.
  ///
  /// Exemplo:
  ///
  /// `2026-09-20`
  final String dateKey;

  /// Dificuldade seleccionada automaticamente para este dia.
  final QuizDifficulty difficulty;

  /// Perguntas que fazem parte do desafio diário.
  final List<QuestionModel> questions;

  /// Tentativa já realizada neste dia.
  ///
  /// É `null` quando o utilizador ainda não concluiu
  /// o desafio diário.
  final QuizHistoryModel? completedHistory;

  /// Cria a configuração de um Quiz Diário.
  const DailyQuizModel({
    required this.dateKey,
    required this.difficulty,
    required this.questions,
    required this.completedHistory,
  });

  /// Indica se o Quiz Diário deste dia já foi concluído.
  bool get isCompleted {
    return completedHistory != null;
  }

  /// Identificador único utilizado no histórico.
  ///
  /// Utilizar uma chave baseada na data impede que sejam
  /// criados vários registos para o mesmo desafio diário.
  String get sessionId {
    return 'daily-$dateKey';
  }
}
