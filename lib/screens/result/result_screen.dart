import 'package:bible_quiz_game/screens/categories/categories_screen.dart';
import 'package:bible_quiz_game/screens/home/home_screen.dart';
import 'package:bible_quiz_game/screens/review/review_answers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/quiz_provider.dart';

/// Tela responsável por apresentar o resultado final do quiz.
///
/// Nesta tela o utilizador pode:
/// - consultar a pontuação;
/// - consultar a percentagem de acertos;
/// - receber uma mensagem baseada no desempenho;
/// - rever todas as respostas;
/// - iniciar outro quiz;
/// - voltar para a Home.
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  /// Nome utilizado para identificar a rota no GoRouter.
  static const String routeName = 'result-screen';

  /// Retorna uma mensagem personalizada de acordo com o desempenho.
  ///
  /// As faixas consideradas são:
  ///
  /// - 90% ou mais → Excelente;
  /// - 70% até 89% → Muito bom;
  /// - 50% até 69% → Bom trabalho;
  /// - abaixo de 50% → Incentivo para continuar estudando.
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

  /// Constrói a interface da tela de resultado.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Observa o estado atual do quiz.
    final quiz = ref.watch(quizProvider);

    /// Quantidade total de perguntas da sessão.
    final total = quiz.questions.length;

    /// Calcula a percentagem de respostas corretas.
    ///
    /// A validação de `total == 0` evita uma divisão por zero.
    final percentage = total == 0 ? 0.0 : (quiz.correctAnswers / total) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Ícone que simboliza a conclusão do quiz.
              const Icon(Icons.emoji_events_rounded, size: 100),

              const SizedBox(height: 24),

              /// Apresenta a pontuação no formato:
              ///
              /// 8 / 10
              Text(
                '${quiz.correctAnswers} / $total',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              /// Apresenta a percentagem total de acertos.
              Text(
                '${percentage.toStringAsFixed(0)}% de acertos',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 24),

              /// Mensagem calculada de acordo com o resultado.
              Text(
                _getMessage(percentage),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 48),

              /// Abre a tela onde todas as respostas podem ser revistas.
              ///
              /// Utilizamos `pushNamed` em vez de `goNamed`, pois queremos
              /// manter a ResultScreen na pilha de navegação. Assim, o botão
              /// voltar da AppBar retorna naturalmente ao resultado.
              OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(ReviewAnswersScreen.routeName);
                },
                icon: const Icon(Icons.fact_check_rounded),
                label: const Text('Rever respostas'),
              ),

              const SizedBox(height: 12),

              /// Reinicia o estado atual e leva o utilizador novamente
              /// para a seleção de categorias.
              ElevatedButton(
                onPressed: () {
                  ref.read(quizProvider.notifier).resetQuiz();

                  context.goNamed(CategoriesScreen.routeName);
                },
                child: const Text('Jogar novamente'),
              ),

              const SizedBox(height: 12),

              /// Limpa o quiz atual e regressa à Home.
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
      ),
    );
  }
}
