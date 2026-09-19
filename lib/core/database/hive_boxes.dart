/// Centraliza os nomes das boxes utilizadas pelo Hive CE.
///
/// Manter os nomes num único local evita erros provocados pela
/// utilização de Strings diferentes em várias partes da aplicação.
///
/// Uma alteração ao nome de uma box deve ser feita com cuidado,
/// principalmente depois de a aplicação estar publicada, porque
/// o nome identifica o local onde os dados são persistidos.
class HiveBoxes {
  /// Impede a criação de instâncias desta classe.
  HiveBoxes._();

  /// Box responsável por guardar o histórico dos quizzes
  /// concluídos pelo utilizador.
  static const String quizHistory = 'quiz_history';
}
