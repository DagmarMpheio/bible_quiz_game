/// Representa os níveis de dificuldade disponíveis no Quiz Bíblico.
///
/// Cada pergunta deverá possuir um nível de dificuldade para permitir
/// que o utilizador escolha o tipo de desafio antes de iniciar o quiz.
enum QuizDifficulty {
  /// Perguntas de conhecimento bíblico básico.
  facil,

  /// Perguntas que exigem um conhecimento bíblico intermédio.
  medio,

  /// Perguntas destinadas a utilizadores com conhecimento mais aprofundado.
  dificil,
}

/// Adiciona propriedades auxiliares ao enum [QuizDifficulty].
///
/// Esta extensão permite obter textos preparados para apresentação
/// na interface sem espalhar condições pelas várias views.
extension QuizDifficultyExtension on QuizDifficulty {
  /// Retorna o nome apresentado ao utilizador.
  String get title {
    switch (this) {
      case QuizDifficulty.facil:
        return 'Fácil';

      case QuizDifficulty.medio:
        return 'Médio';

      case QuizDifficulty.dificil:
        return 'Difícil';
    }
  }

  /// Retorna uma pequena descrição do nível de dificuldade.
  String get description {
    switch (this) {
      case QuizDifficulty.facil:
        return 'Perguntas para testar conhecimentos bíblicos essenciais.';

      case QuizDifficulty.medio:
        return 'Perguntas que exigem um conhecimento bíblico intermédio.';

      case QuizDifficulty.dificil:
        return 'Perguntas mais exigentes para aprofundar os teus conhecimentos.';
    }
  }
}
