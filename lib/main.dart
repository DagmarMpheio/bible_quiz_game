import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

/// Ponto de entrada da aplicação.
///
/// O [ProviderScope] envolve toda a aplicação e permite que os widgets abaixo
/// dele utilizem os providers definidos com Riverpod.
void main() {
  runApp(
    const ProviderScope(
      child: BibleQuizApp(),
    ),
  );
}

/// Widget raiz do Quiz Bíblico.
///
/// É responsável por configurar o tema global, a navegação com GoRouter e
/// propriedades gerais do [MaterialApp].
class BibleQuizApp extends StatelessWidget {
  const BibleQuizApp({super.key});

  /// Constrói a aplicação principal.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      /// Título utilizado pelo sistema para identificar a aplicação.
      title: 'Quiz Bíblico',

      /// Remove a faixa de "DEBUG" exibida durante o desenvolvimento.
      debugShowCheckedModeBanner: false,

      /// Define o tema claro global.
      theme: AppTheme.lightTheme,

      /// Liga o MaterialApp às rotas configuradas no GoRouter.
      routerConfig: appRouter,
    );
  }
}
