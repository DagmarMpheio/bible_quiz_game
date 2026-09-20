import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../models/difficulty_model.dart';
import '../../models/quiz_statistics_model.dart';
import '../../providers/quiz_statistics_provider.dart';

/// Ecrã responsável por apresentar as estatísticas
/// de desempenho do utilizador.
///
/// Todos os valores apresentados são calculados dinamicamente
/// a partir do histórico persistido no Hive CE.
class StatisticsScreen extends ConsumerWidget {
  /// Nome utilizado para identificar esta rota no GoRouter.
  static const String routeName = 'statistics-screen';

  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Observa as estatísticas derivadas do histórico.
    final statistics = ref.watch(quizStatisticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas')),
      body: statistics.totalQuizzes == 0
          ? const _EmptyStatistics()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// Indicadores gerais.
                _GeneralStatistics(statistics: statistics),

                const SizedBox(height: 24),

                /// Melhor resultado alcançado.
                _BestResultCard(statistics: statistics),

                const SizedBox(height: 28),

                const _SectionTitle(title: 'Desempenho por categoria'),

                const SizedBox(height: 12),

                /// Estatísticas individuais de cada categoria
                /// em que o utilizador já realizou quizzes.
                ...QuizCategory.values
                    .where((category) {
                      return statistics.byCategory.containsKey(category);
                    })
                    .map((category) {
                      final summary = statistics.byCategory[category]!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PerformanceCard(
                          title: category.title,
                          summary: summary,
                        ),
                      );
                    }),

                const SizedBox(height: 16),

                const _SectionTitle(title: 'Desempenho por dificuldade'),

                const SizedBox(height: 12),

                /// Estatísticas agrupadas por dificuldade.
                ...QuizDifficulty.values
                    .where((difficulty) {
                      return statistics.byDifficulty.containsKey(difficulty);
                    })
                    .map((difficulty) {
                      final summary = statistics.byDifficulty[difficulty]!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PerformanceCard(
                          title: difficulty.title,
                          summary: summary,
                        ),
                      );
                    }),

                const SizedBox(height: 24),
              ],
            ),
    );
  }
}

/// Estado apresentado quando o utilizador ainda não possui
/// dados suficientes para calcular estatísticas.
class _EmptyStatistics extends StatelessWidget {
  const _EmptyStatistics();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 72,
              color: AppColors.textSecondary,
            ),

            SizedBox(height: 18),

            Text(
              'Ainda não existem estatísticas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'Conclui pelo menos um quiz para começar a acompanhar o teu desempenho.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Apresenta os principais indicadores gerais.
class _GeneralStatistics extends StatelessWidget {
  /// Estatísticas completas do utilizador.
  final QuizStatisticsModel statistics;

  const _GeneralStatistics({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      /// Impede que a grelha tenha scroll próprio.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,

      /// Ajusta a proporção dos cards.
      childAspectRatio: 1.45,

      children: [
        _MetricCard(
          icon: Icons.quiz_outlined,
          label: 'Quizzes',
          value: '${statistics.totalQuizzes}',
        ),
        _MetricCard(
          icon: Icons.question_answer_outlined,
          label: 'Respostas',
          value: '${statistics.totalAnswers}',
        ),
        _MetricCard(
          icon: Icons.check_circle_outline,
          label: 'Correctas',
          value: '${statistics.correctAnswers}',
        ),
        _MetricCard(
          icon: Icons.percent_rounded,
          label: 'Taxa de acertos',
          value: '${statistics.accuracy.toStringAsFixed(1)}%',
        ),
      ],
    );
  }
}

/// Card utilizado para apresentar uma métrica geral.
class _MetricCard extends StatelessWidget {
  /// Ícone utilizado pela métrica.
  final IconData icon;

  /// Nome da métrica.
  final String label;

  /// Valor apresentado.
  final String value;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Apresenta o melhor resultado registado.
class _BestResultCard extends StatelessWidget {
  /// Estatísticas utilizadas para obter a melhor tentativa.
  final QuizStatisticsModel statistics;

  const _BestResultCard({required this.statistics});

  @override
  Widget build(BuildContext context) {
    final best = statistics.bestResult;

    if (best == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_events_outlined, color: AppColors.secondary),

                SizedBox(width: 10),

                Text(
                  'Melhor resultado',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              best.category.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            Text(
              best.difficulty.title,
              style: const TextStyle(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${best.correctAnswers}/${best.totalQuestions}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${best.percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Título utilizado para separar as diferentes áreas
/// do ecrã de estatísticas.
class _SectionTitle extends StatelessWidget {
  /// Texto apresentado no título.
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Apresenta o desempenho agregado de uma categoria
/// ou dificuldade.
class _PerformanceCard extends StatelessWidget {
  /// Nome da categoria ou dificuldade.
  final String title;

  /// Dados agregados utilizados pelo card.
  final QuizPerformanceSummary summary;

  const _PerformanceCard({required this.title, required this.summary});

  @override
  Widget build(BuildContext context) {
    /// Converte a percentagem para o intervalo entre 0 e 1,
    /// necessário pelo [LinearProgressIndicator].
    final progress = summary.accuracy / 100;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  '${summary.accuracy.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.secondary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '${summary.correctAnswers} correctas de '
              '${summary.totalAnswers} respostas • '
              '${summary.totalQuizzes} quiz(es)',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
