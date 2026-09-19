import 'question_model.dart';

/// Representa a resposta dada pelo utilizador a uma pergunta do quiz.
///
/// Esta classe associa uma [QuestionModel] à alternativa escolhida
/// pelo utilizador.
///
/// Ela será utilizada principalmente para:
/// - guardar o histórico das respostas durante o quiz;
/// - verificar quais perguntas foram acertadas ou erradas;
/// - apresentar a tela de revisão no final do quiz;
/// - futuramente guardar o histórico no Hive CE.
class QuizAnswerModel {
  /// Pergunta respondida pelo utilizador.
  final QuestionModel question;

  /// Índice da alternativa selecionada.
  ///
  /// Por exemplo:
  /// - 0 = alternativa A;
  /// - 1 = alternativa B;
  /// - 2 = alternativa C;
  /// - 3 = alternativa D.
  final int selectedAnswerIndex;

  /// Cria o registo de uma resposta dada pelo utilizador.
  const QuizAnswerModel({
    required this.question,
    required this.selectedAnswerIndex,
  });

  /// Indica se a resposta selecionada está correta.
  ///
  /// A resposta é considerada correta quando o índice escolhido pelo
  /// utilizador coincide com [QuestionModel.correctAnswerIndex].
  bool get isCorrect {
    return selectedAnswerIndex == question.correctAnswerIndex;
  }

  /// Retorna o texto da alternativa escolhida pelo utilizador.
  String get selectedAnswer {
    return question.options[selectedAnswerIndex];
  }

  /// Retorna o texto da alternativa correta da pergunta.
  String get correctAnswer {
    return question.options[question.correctAnswerIndex];
  }
}
