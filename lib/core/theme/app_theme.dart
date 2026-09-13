import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Centraliza a configuração visual global da aplicação.
///
/// O objetivo desta classe é evitar que cada tela configure manualmente cores,
/// estilos de AppBar, botões e outros elementos visuais.
///
/// O construtor é privado porque o tema é disponibilizado através de membros
/// estáticos.
class AppTheme {
  AppTheme._();

  /// Retorna o tema claro utilizado pelo Quiz Bíblico.
  ///
  /// O tema utiliza Material 3 e gera um [ColorScheme] com base na cor
  /// principal definida em [AppColors.primary].
  static ThemeData get lightTheme {
    /// Gera automaticamente uma paleta de cores compatível com Material 3.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      /// Ativa os componentes e comportamentos visuais do Material Design 3.
      useMaterial3: true,

      /// Define o esquema global de cores.
      colorScheme: colorScheme,

      /// Define a cor de fundo padrão dos Scaffolds.
      scaffoldBackgroundColor: AppColors.background,

      /// Configuração padrão aplicada a todas as AppBars do projeto.
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      /// Configuração padrão dos botões elevados.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,

          /// Faz com que o botão ocupe toda a largura disponível e tenha uma
          /// altura mínima de 52 pixels.
          minimumSize: const Size(double.infinity, 52),

          /// Define os cantos arredondados dos botões.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
