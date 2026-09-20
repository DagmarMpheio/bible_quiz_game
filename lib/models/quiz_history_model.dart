import 'package:bible_quiz_game/models/quiz_mode.dart';

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

  /// Nome interno do modo em que o quiz foi realizado.
  ///
  /// O valor possui um valor padrão para manter compatibilidade
  /// com tentativas guardadas antes da introdução do Quiz Diário.
  final String quizModeName;

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

    /// Tentativas antigas são consideradas quizzes normais.
    this.quizModeName = 'standard',
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

  /// Modo em que esta tentativa foi realizada.
  ///
  /// Caso seja encontrado um valor desconhecido na base local,
  /// assume-se o modo normal para evitar erros na aplicação.
  QuizMode get mode {
    return QuizMode.values.firstWhere(
      (mode) {
        return mode.name == quizModeName;
      },
      orElse: () {
        return QuizMode.standard;
      },
    );
  }
}
