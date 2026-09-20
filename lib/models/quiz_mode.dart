/// Identifica o modo em que uma sessão de quiz foi iniciada.
///
/// Actualmente a aplicação suporta:
///
/// - quiz normal;
/// - quiz diário.
///
/// Esta distinção será guardada no histórico para permitir
/// aplicar regras específicas, como bónus de XP.
enum QuizMode {
  /// Quiz iniciado através da selecção normal de
  /// categoria e dificuldade.
  standard,

  /// Quiz especial disponibilizado uma vez por dia.
  daily,
}

/// Disponibiliza propriedades de apresentação para [QuizMode].
extension QuizModeExtension on QuizMode {
  /// Nome apresentado na interface.
  String get title {
    switch (this) {
      case QuizMode.standard:
        return 'Quiz';

      case QuizMode.daily:
        return 'Quiz Diário';
    }
  }
}
