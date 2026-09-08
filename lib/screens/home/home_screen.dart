import 'package:bible_quiz_game/screens/categories/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//===============================================================
// Tela inicial do aplicativo, apresentando o título e um botão para iniciar o quiz.
//===============================================================
class HomeScreen extends StatelessWidget {
  static const String routeName = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book_rounded, size: 100),

              const SizedBox(height: 24),

              Text(
                'Quiz Bíblico',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Teste os seus conhecimentos e aprenda mais sobre a Bíblia.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 48),

              ElevatedButton.icon(
                onPressed: () {
                  context.goNamed(CategoriesScreen.routeName);
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Começar Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
