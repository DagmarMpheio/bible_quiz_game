import 'package:bible_quiz_game/screens/categories/categories_screen.dart';
import 'package:bible_quiz_game/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/quiz_provider.dart';

//===============================================================
// Tela que apresenta o resultado do quiz, incluindo pontuação e mensagens de feedback.
//===============================================================
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});
  static const String routeName = 'result-screen';

  String _getMessage(double percentage) {
    if (percentage >= 90) {
      return 'Excelente! Conheces muito bem a Bíblia.';
    }

    if (percentage >= 70) {
      return 'Muito bom! Continua assim.';
    }

    if (percentage >= 50) {
      return 'Bom trabalho. Continua estudando!';
    }

    return 'Continua estudando a Palavra!';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = ref.watch(quizProvider);

    final total = quiz.questions.length;

    final percentage = total == 0 ? 0.0 : (quiz.correctAnswers / total) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_rounded, size: 100),

            const SizedBox(height: 24),

            Text(
              '${quiz.correctAnswers} / $total',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              '${percentage.toStringAsFixed(0)}% de acertos',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            Text(
              _getMessage(percentage),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                ref.read(quizProvider.notifier).resetQuiz();

                context.goNamed(CategoriesScreen.routeName);
              },
              child: const Text('Jogar novamente'),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                ref.read(quizProvider.notifier).resetQuiz();

                context.goNamed(HomeScreen.routeName);
              },
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}
