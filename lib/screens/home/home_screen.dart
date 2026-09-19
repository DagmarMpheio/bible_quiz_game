import 'package:bible_quiz_game/screens/views.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tela inicial do aplicativo.
///
/// Apresenta a identidade principal do Quiz Bíblico e disponibiliza a acção que
/// leva o utilizador para a escolha de categorias.
class HomeScreen extends StatelessWidget {
  /// Nome da rota utilizado pelo GoRouter.
  static const String routeName = 'home-screen';

  const HomeScreen({super.key});

  /// Constrói a interface da tela inicial.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        /// Garante que o conteúdo não fique sob áreas reservadas do sistema,
        /// como notch, barra de estado e gestos.
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Ícone principal que representa a Bíblia.
              const Icon(Icons.menu_book_rounded, size: 100),

              const SizedBox(height: 24),

              /// Nome do aplicativo.
              Text(
                'Quiz Bíblico',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// Pequena descrição do objetivo da aplicação.
              Text(
                'Teste os seus conhecimentos e aprenda mais sobre a Bíblia.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 48),

              /// Acção principal que encaminha o utilizador às categorias.
              ElevatedButton.icon(
                onPressed: () {
                  context.goNamed(CategoriesScreen.routeName);
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Começar Quiz'),
              ),

              const SizedBox(height: 12),

              /// Permite consultar informações sobre a aplicação,
              /// autoria, copyright e licenciamento.
              TextButton.icon(
                onPressed: () {
                  /// Utilizamos [pushNamed] para manter a Home na pilha
                  /// de navegação e permitir regressar através do botão
                  /// de voltar do ecrã "Sobre".
                  context.pushNamed(AboutScreen.routeName);
                },
                icon: const Icon(Icons.info_outline_rounded),
                label: const Text('Sobre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
