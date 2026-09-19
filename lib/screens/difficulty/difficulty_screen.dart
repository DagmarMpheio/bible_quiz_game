import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/providers/quiz_provider.dart';
import 'package:bible_quiz_game/screens/quiz/quiz_screen.dart';
import 'package:bible_quiz_game/widgets/difficulty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ecrã responsável pela escolha da dificuldade do quiz.
///
/// É apresentado depois de o utilizador seleccionar uma categoria.
///
/// Apenas os níveis que possuem perguntas disponíveis podem ser
/// seleccionados.
class DifficultyScreen extends ConsumerWidget {
  /// Nome utilizado pelo GoRouter para identificar este ecrã.
  static const String routeName = 'difficulty-screen';

  /// Categoria escolhida anteriormente pelo utilizador.
  final QuizCategory category;

  const DifficultyScreen({super.key, required this.category});

  /// Retorna um ícone adequado para cada nível de dificuldade.
  IconData _getDifficultyIcon(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.facil:
        return Icons.sentiment_satisfied_rounded;

      case QuizDifficulty.medio:
        return Icons.psychology_alt_rounded;

      case QuizDifficulty.dificil:
        return Icons.local_fire_department_rounded;
    }
  }

  /// Constrói o ecrã de selecção da dificuldade.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Obtém o repositório de perguntas através do Riverpod.
    final repository = ref.read(questionRepositoryProvider);

    /// Descobre quais os níveis que possuem perguntas para
    /// a categoria actualmente seleccionada.
    final availableDifficulties = repository.getAvailableDifficulties(category);

    return Scaffold(
      appBar: AppBar(title: const Text('Escolher dificuldade')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Identifica a categoria para a qual o utilizador
          /// está prestes a iniciar o quiz.
          Text(
            category.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Selecciona o nível de dificuldade das perguntas.',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 24),

          /// Gera automaticamente um card para cada dificuldade.
          ...QuizDifficulty.values.map((difficulty) {
            /// Determina se este nível possui pelo menos
            /// uma pergunta disponível.
            final enabled = availableDifficulties.contains(difficulty);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DifficultyCard(
                title: difficulty.title,
                description: difficulty.description,
                icon: _getDifficultyIcon(difficulty),
                enabled: enabled,
                onTap: () {
                  /// Abre o quiz enviando tanto a categoria
                  /// como a dificuldade seleccionada.
                  context.pushNamed(
                    QuizScreen.routeName,
                    pathParameters: {
                      'category': category.name,
                      'difficulty': difficulty.name,
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
