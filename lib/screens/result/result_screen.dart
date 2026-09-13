import 'package:bible_quiz_game/screens/categories/categories_screen.dart';
import 'package:bible_quiz_game/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/quiz_provider.dart';

/// Tela responsável por apresentar o resultado final de uma sessão do quiz.
///
/// O resultado é calculado a partir do estado mantido em [quizProvider]. A tela
/// mostra a quantidade de acertos, a percentagem final e uma mensagem de
/// desempenho, além de permitir iniciar outro quiz ou voltar à Home.
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  /// Nome da rota utilizado pelo GoRouter.
  static const String routeName = 'result-screen';

  /// Retorna uma mensagem de feedback de acordo com a percentagem de acertos.
  ///
  /// Faixas utilizadas:
  /// - 90% ou mais: excelente;
  /// - 70% a 89%: muito bom;
  /// - 50% a 69%: bom trabalho;
  /// - abaixo de 50%: incentivo para continuar estudando.
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

  /// Constrói a interface do resultado.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Observa o estado final do quiz.
    final quiz = ref.watch(quizProvider);

    /// Quantidade total de perguntas respondidas na sessão.
    final total = quiz.questions.length;

    /// Calcula a percentagem final.
    ///
    /// A condição `total == 0` evita divisão por zero caso a tela seja aberta
    /// sem existir uma sessão válida.
    final percentage =
        total == 0 ? 0.0 : (quiz.correctAnswers / total) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Ícone decorativo que representa conclusão/conquista.
            const Icon(
              Icons.emoji_events_rounded,
              size: 100,
            ),

            const SizedBox(height: 24),

            /// Exibe a pontuação no formato "acertos / total".
            Text(
              '${quiz.correctAnswers} / $total',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            /// Exibe a percentagem sem casas decimais.
            Text(
              '${percentage.toStringAsFixed(0)}% de acertos',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            /// Mensagem personalizada de acordo com a pontuação.
            Text(
              _getMessage(percentage),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 48),

            /// Reinicia o estado e volta para a seleção de categorias.
            ElevatedButton(
              onPressed: () {
                ref.read(quizProvider.notifier).resetQuiz();

                context.goNamed(
                  CategoriesScreen.routeName,
                );
              },
              child: const Text('Jogar novamente'),
            ),

            const SizedBox(height: 12),

            /// Reinicia o estado e retorna à tela inicial.
            TextButton(
              onPressed: () {
                ref.read(quizProvider.notifier).resetQuiz();

                context.goNamed(
                  HomeScreen.routeName,
                );
              },
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}
