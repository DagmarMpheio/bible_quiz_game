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

  /// Ano associado ao copyright da aplicação.
  static const String copyrightYear = '2026';

  /// Nome do proprietário dos direitos da aplicação.
  ///
  /// Substituir pelo nome do autor, empresa ou entidade responsável
  /// antes da publicação da aplicação.
  static const String copyrightOwner = 'Eng. Dagmar Mpheio';

  /// Aviso de copyright apresentado na aplicação.
  static const String copyright =
      'Copyright © $copyrightYear $copyrightOwner. '
      'Todos os direitos reservados.';

  /// Informação relativa ao conteúdo bíblico utilizado.
  ///
  /// A aplicação utiliza referências bíblicas e conteúdos educativos.
  /// Caso sejam utilizados textos integrais de uma tradução específica,
  /// deverão ser respeitadas as respectivas condições de utilização.
  static const String bibleCopyrightNotice =
      'As referências bíblicas são apresentadas para fins educativos. '
      'Os direitos relativos ao texto de cada tradução da Bíblia '
      'pertencem aos respectivos titulares.';
}
