import 'package:bible_quiz_game/core/database/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

/// Ponto de entrada da aplicação.
///
/// Antes de iniciar a interface, são inicializados todos os
/// serviços necessários para o funcionamento da aplicação,
/// incluindo a persistência local com Hive CE.
void main() async {
  /// Garante que os serviços Flutter estão disponíveis antes
  /// de executarmos código assíncrono relacionado com plugins.
  WidgetsFlutterBinding.ensureInitialized();

  /// Inicializa a base de dados local.
  await HiveService.initialize();

  /// Inicia a aplicação depois de os serviços essenciais
  /// estarem correctamente preparados.
  runApp(const ProviderScope(child: BibleQuizApp()));
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
