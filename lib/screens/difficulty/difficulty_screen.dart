import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/providers/quiz_provider.dart';
import 'package:bible_quiz_game/screens/quiz/quiz_screen.dart';
import 'package:bible_quiz_game/widgets/difficulty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ecrã responsável pela selecção do nível de dificuldade.
///
/// O ecrã consulta o repositório para determinar quais os níveis
/// que possuem perguntas disponíveis para a categoria escolhida.
class DifficultyScreen extends ConsumerWidget {
  /// Nome utilizado para identificar esta rota.
  static const String routeName = 'difficulty-screen';

  /// Categoria seleccionada anteriormente.
  final QuizCategory category;

  const DifficultyScreen({super.key, required this.category});

  /// Retorna o ícone correspondente ao nível de dificuldade.
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

  /// Constrói o ecrã.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Observa a consulta assíncrona das dificuldades disponíveis.
    final difficultiesAsync = ref.watch(
      availableDifficultiesProvider(category),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Escolher dificuldade')),

      /// `when` permite representar os três estados possíveis
      /// de uma operação assíncrona:
      ///
      /// - data;
      /// - loading;
      /// - error.
      body: difficultiesAsync.when(
        /// Executado quando os dados são carregados correctamente.
        data: (availableDifficulties) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// Categoria actualmente seleccionada.
              Text(
                category.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text('Selecciona o nível de dificuldade das perguntas.'),

              const SizedBox(height: 24),

              /// Cria um card para cada nível existente.
              ...QuizDifficulty.values.map((difficulty) {
                /// Determina se o nível possui perguntas.
                final enabled = availableDifficulties.contains(difficulty);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DifficultyCard(
                    title: difficulty.title,
                    description: difficulty.description,
                    icon: _getDifficultyIcon(difficulty),
                    enabled: enabled,
                    onTap: () {
                      /// Abre o quiz com a categoria
                      /// e dificuldade seleccionadas.
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
          );
        },

        /// Apresentado enquanto o ficheiro JSON está a ser carregado.
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        /// Apresentado caso ocorra algum problema na leitura
        /// ou conversão do ficheiro JSON.
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 56),

                  const SizedBox(height: 16),

                  const Text(
                    'Não foi possível carregar as dificuldades.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      /// Invalida o estado anterior e força
                      /// uma nova tentativa de carregamento.
                      ref.invalidate(availableDifficultiesProvider(category));
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
