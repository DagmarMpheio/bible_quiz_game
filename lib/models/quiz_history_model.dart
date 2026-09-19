import 'category_model.dart';
import 'difficulty_model.dart';

/// Representa uma tentativa concluída do Quiz Bíblico.
///
/// Cada registo corresponde a uma sessão completa realizada
/// pelo utilizador.
///
/// O modelo é persistido localmente através do Hive CE.
class QuizHistoryModel {
  /// Identificador único da sessão.
  ///
  /// Também será utilizado como chave na box do Hive para impedir
  /// que a mesma tentativa seja guardada mais de uma vez.
  final String id;

  /// Nome interno da categoria seleccionada.
  ///
  /// Guardamos uma [String] em vez do enum para simplificar
  /// a persistência e reduzir dependências entre adapters.
  final String categoryName;

  /// Nome interno do nível de dificuldade seleccionado.
  final String difficultyName;

  /// Quantidade de respostas correctas.
  final int correctAnswers;

  /// Quantidade total de perguntas apresentadas.
  final int totalQuestions;

  /// Data e hora em que o quiz foi concluído.
  final DateTime completedAt;

  /// Cria um registo do histórico do quiz.
  const QuizHistoryModel({
    required this.id,
    required this.categoryName,
    required this.difficultyName,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.completedAt,
  });

  /// Converte o nome guardado para [QuizCategory].
  ///
  /// Isto permite continuar a utilizar propriedades como
  /// `category.title` na interface.
  QuizCategory get category {
    return QuizCategory.values.byName(categoryName);
  }

  /// Converte o nome guardado para [QuizDifficulty].
  QuizDifficulty get difficulty {
    return QuizDifficulty.values.byName(difficultyName);
  }

  /// Quantidade de respostas incorrectas.
  int get incorrectAnswers {
    return totalQuestions - correctAnswers;
  }

  /// Percentagem de respostas correctas.
  ///
  /// Caso não existam perguntas, retorna 0 para impedir
  /// uma divisão por zero.
  double get percentage {
    if (totalQuestions == 0) {
      return 0;
    }

    return (correctAnswers / totalQuestions) * 100;
  }
}
