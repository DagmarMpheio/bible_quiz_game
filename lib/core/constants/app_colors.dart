import 'package:flutter/material.dart';

/// Centraliza todas as cores utilizadas pela aplicação.
///
/// Esta classe funciona como uma paleta global do projeto. Ao manter as cores
/// num único local, torna-se mais simples alterar a identidade visual do app
/// sem precisar procurar valores hexadecimais espalhados pelas telas.
///
/// A classe possui construtor privado para impedir a sua instanciação, uma vez
/// que todas as propriedades são estáticas e podem ser acedidas diretamente.
class AppColors {
  AppColors._();

  /// Cor principal do aplicativo.
  ///
  /// Utilizada, por exemplo, em AppBars, botões principais e elementos de
  /// destaque da interface.
  static const Color primary = Color(0xFF4E342E);

  /// Cor secundária do aplicativo.
  ///
  /// O tom dourado é utilizado para criar contraste com a cor principal e
  /// reforçar elementos visuais importantes, como o progresso do quiz.
  static const Color secondary = Color(0xFFD4A017);

  /// Cor de fundo padrão das telas do aplicativo.
  static const Color background = Color(0xFFF8F5F0);

  /// Cor utilizada para indicar estados de sucesso.
  ///
  /// É aplicada, por exemplo, quando o utilizador seleciona a resposta correta.
  static const Color success = Color(0xFF2E7D32);

  /// Cor utilizada para indicar erros ou respostas incorretas.
  static const Color error = Color(0xFFC62828);

  /// Cor principal utilizada nos textos da aplicação.
  static const Color textPrimary = Color(0xFF212121);

  /// Cor secundária utilizada em textos de menor destaque.
  static const Color textSecondary = Color(0xFF616161);
}
