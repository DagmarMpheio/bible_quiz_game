/// Identifica as conquistas disponíveis no Quiz Bíblico.
enum AchievementType {
  /// Concluir o primeiro quiz.
  primeiroQuiz,

  /// Obter 100% de respostas correctas num quiz.
  perfeccionista,

  /// Concluir pelo menos 10 quizzes.
  veterano,

  /// Jogar em três dias consecutivos.
  sequenciaTresDias,

  /// Realizar quizzes em todas as categorias principais.
  exploradorBiblico,
}

/// Representa o estado de uma conquista.
///
/// As conquistas são calculadas a partir do histórico e,
/// nesta fase, não são guardadas numa box própria do Hive.
class AchievementProgress {
  /// Tipo da conquista.
  final AchievementType type;

  /// Indica se a conquista já foi alcançada.
  final bool unlocked;

  /// Valor actual utilizado para calcular o progresso.
  final int currentValue;

  /// Valor necessário para desbloquear a conquista.
  final int targetValue;

  /// Cria o estado de uma conquista.
  const AchievementProgress({
    required this.type,
    required this.unlocked,
    required this.currentValue,
    required this.targetValue,
  });

  /// Progresso da conquista num intervalo entre 0 e 1.
  double get progress {
    if (targetValue <= 0) {
      return 0;
    }

    return (currentValue / targetValue).clamp(0.0, 1.0).toDouble();
  }
}

/// Disponibiliza textos amigáveis para cada conquista.
extension AchievementTypeExtension on AchievementType {
  /// Nome apresentado na interface.
  String get title {
    switch (this) {
      case AchievementType.primeiroQuiz:
        return 'Primeiro passo';

      case AchievementType.perfeccionista:
        return 'Perfeccionista';

      case AchievementType.veterano:
        return 'Veterano';

      case AchievementType.sequenciaTresDias:
        return 'Consistência';

      case AchievementType.exploradorBiblico:
        return 'Explorador Bíblico';
    }
  }

  /// Descrição utilizada no ecrã de progresso.
  String get description {
    switch (this) {
      case AchievementType.primeiroQuiz:
        return 'Conclui o teu primeiro quiz.';

      case AchievementType.perfeccionista:
        return 'Obtém 100% de respostas correctas num quiz.';

      case AchievementType.veterano:
        return 'Conclui 10 quizzes.';

      case AchievementType.sequenciaTresDias:
        return 'Realiza quizzes durante 3 dias consecutivos.';

      case AchievementType.exploradorBiblico:
        return 'Realiza pelo menos um quiz em cada categoria principal.';
    }
  }
}
