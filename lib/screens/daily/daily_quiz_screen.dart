import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../models/daily_quiz_model.dart';
import '../../models/quiz_mode.dart';
import '../../providers/daily_quiz_provider.dart';
import '../../providers/quiz_provider.dart';
import '../views.dart';

/// Ecrã de entrada do Quiz Diário.
///
/// Este ecrã:
///
/// - carrega o desafio correspondente ao dia;
/// - mostra a dificuldade;
/// - impede uma segunda tentativa depois da conclusão;
/// - inicia a sessão no [quizProvider].
class DailyQuizScreen extends ConsumerWidget {
  /// Nome da rota utilizada pelo GoRouter.
  static const String routeName = 'daily-quiz-screen';

  const DailyQuizScreen({super.key});

  /// Inicia o desafio diário.
  void _startDailyQuiz(
    BuildContext context,
    WidgetRef ref,
    DailyQuizModel dailyQuiz,
  ) {
    /// Inicializa o mesmo motor utilizado pelo quiz normal.
    ref
        .read(quizProvider.notifier)
        .startQuiz(
          /// O Quiz Diário utiliza perguntas de várias categorias.
          QuizCategory.geral,

          dailyQuiz.difficulty,

          dailyQuiz.questions,

          /// Identifica esta sessão como desafio diário.
          mode: QuizMode.daily,

          /// O identificador baseado na data impede
          /// múltiplos registos para o mesmo dia.
          sessionId: dailyQuiz.sessionId,
        );

    /// Abre o ecrã normal do quiz.
    ///
    /// O parâmetro `mode=daily` informa ao QuizScreen que as
    /// perguntas já foram preparadas e não devem ser recarregadas.
    context.pushNamed(
      QuizScreen.routeName,
      pathParameters: {
        'category': QuizCategory.geral.name,
        'difficulty': dailyQuiz.difficulty.name,
      },
      queryParameters: {'mode': QuizMode.daily.name},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyQuiz = ref.watch(dailyQuizProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Diário')),
      body: dailyQuiz.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 54,
                    color: AppColors.error,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Não foi possível carregar o Quiz Diário.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: () {
                      ref.invalidate(dailyQuizProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        },

        data: (daily) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                size: 74,
                color: AppColors.primary,
              ),

              const SizedBox(height: 18),

              const Text(
                'Desafio do dia',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                daily.dateKey,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 28),

              _DailyInformationCard(dailyQuiz: daily),

              const SizedBox(height: 24),

              if (daily.isCompleted)
                _CompletedCard(dailyQuiz: daily)
              else
                ElevatedButton.icon(
                  onPressed: () {
                    _startDailyQuiz(context, ref, daily);
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Começar Quiz Diário'),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Apresenta informações sobre o desafio disponível.
class _DailyInformationCard extends StatelessWidget {
  final DailyQuizModel dailyQuiz;

  const _DailyInformationCard({required this.dailyQuiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _InformationRow(
              icon: Icons.quiz_outlined,
              label: 'Perguntas',
              value: '${dailyQuiz.questions.length}',
            ),

            const Divider(height: 28),

            _InformationRow(
              icon: Icons.speed_rounded,
              label: 'Dificuldade',
              value: dailyQuiz.difficulty.title,
            ),

            const Divider(height: 28),

            const _InformationRow(
              icon: Icons.stars_outlined,
              label: 'Bónus',
              value: '+75 XP',
            ),
          ],
        ),
      ),
    );
  }
}

/// Linha reutilizável para informações do Quiz Diário.
class _InformationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),

        const SizedBox(width: 12),

        Expanded(child: Text(label)),

        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// Card apresentado quando o desafio do dia já foi concluído.
class _CompletedCard extends StatelessWidget {
  final DailyQuizModel dailyQuiz;

  const _CompletedCard({required this.dailyQuiz});

  @override
  Widget build(BuildContext context) {
    final result = dailyQuiz.completedHistory!;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 52,
              color: AppColors.success,
            ),

            const SizedBox(height: 12),

            const Text(
              'Desafio concluído',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              '${result.correctAnswers}'
              '/'
              '${result.totalQuestions}'
              ' respostas correctas',
            ),

            const SizedBox(height: 4),

            Text(
              '${result.percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Volta amanhã para um novo desafio.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
