/// Centraliza os textos estáticos utilizados em diferentes
/// áreas da aplicação.
///
/// Manter estes valores num único ficheiro evita a repetição
/// de textos e facilita futuras alterações.
class AppStrings {
  /// Impede a criação de instâncias desta classe.
  AppStrings._();

  /// Nome oficial da aplicação.
  static const String appName = 'Quiz Bíblico';

  /// Nome do autor original do projecto.
  ///
  /// Mesmo que outros programadores contribuam futuramente,
  /// a autoria original do projecto permanece identificada.
  static const String originalAuthor =
      'Eng.Dagmar Mpheio';

  /// Ano em que o projecto foi criado/publicado.
  static const String copyrightYear =
      '2026';

  /// Informação de copyright apresentada na aplicação.
  ///
  /// A expressão "e colaboradores" reconhece as contribuições
  /// que poderão ser acrescentadas ao projecto por terceiros.
  static const String copyright =
      'Copyright © $copyrightYear '
      '$originalAuthor e colaboradores.';

  /// Nome simplificado da licença utilizada pelo projecto.
  static const String licenseName =
      'Apache License 2.0';

  /// Informação resumida sobre a licença do código-fonte.
  static const String licenseNotice =
      'Este software é disponibilizado ao abrigo da '
      'Apache License, Version 2.0.';

  /// Aviso relacionado com o conteúdo bíblico.
  ///
  /// A licença Apache 2.0 aplica-se ao software desenvolvido
  /// neste projecto, mas não substitui os direitos associados
  /// a traduções bíblicas pertencentes a terceiros.
  static const String bibleCopyrightNotice =
      'As referências bíblicas são utilizadas para fins educativos. '
      'Os direitos sobre textos de traduções bíblicas específicas '
      'pertencem aos respectivos titulares.';
}