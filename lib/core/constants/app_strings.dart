/// Centraliza os textos estáticos utilizados em diferentes
/// áreas da aplicação.
///
/// Manter estes valores num único ficheiro facilita alterações futuras,
/// internacionalização e evita a repetição de textos pela aplicação.
class AppStrings {
  /// Impede a criação de instâncias desta classe.
  AppStrings._();

  /// Nome oficial da aplicação.
  static const String appName = 'Quiz Bíblico';

  //// Informação de autoria apresentada na aplicação.
  ///
  /// O autor original permanece identificado mesmo quando o projecto
  /// recebe contribuições de terceiros.
  static const String copyright =
      'Copyright © 2026 Eng. Dagmar Mpheio e colaboradores.';

  /// Nome da licença utilizada pelo código-fonte do projecto.
  static const String licenseName = 'Apache License 2.0';

  /// Informação resumida sobre o licenciamento do software.
  static const String licenseNotice =
      'Este software é disponibilizado ao abrigo da '
      'Apache License, Version 2.0.';
}
