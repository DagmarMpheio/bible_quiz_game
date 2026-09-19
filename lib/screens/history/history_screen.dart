import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../models/quiz_history_model.dart';
import '../../providers/quiz_history_provider.dart';

/// Ecrã responsável por apresentar todas as tentativas
/// concluídas pelo utilizador.
///
/// Os dados são carregados localmente através do Hive CE.
class HistoryScreen extends ConsumerWidget {
  /// Nome utilizado pelo GoRouter.
  static const String routeName = 'history-screen';

  const HistoryScreen({super.key});

  /// Formata uma data para apresentação simples.
  ///
  /// Exemplo:
  ///
  /// `19/09/2026 14:35`
  String _formatDate(DateTime date) {
    /// Adiciona zero à esquerda quando necessário.
    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${twoDigits(date.day)}/'
        '${twoDigits(date.month)}/'
        '${date.year} '
        '${twoDigits(date.hour)}:'
        '${twoDigits(date.minute)}';
  }

  /// Pede confirmação antes de eliminar todo o histórico.
  Future<void> _confirmClearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Limpar histórico'),
          content: const Text(
            'Pretendes eliminar todas as tentativas guardadas?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(quizHistoryProvider.notifier).clear();
  }

  /// Pede confirmação antes de eliminar uma tentativa.
  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    QuizHistoryModel history,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar tentativa'),
          content: const Text('Pretendes remover esta tentativa do histórico?'),
          actions: [
            TextButton(
              onPressed: () {
              context.pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(quizHistoryProvider.notifier).delete(history.id);
  }

  /// Constrói o ecrã de histórico.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Observa todas as tentativas persistidas.
    final history = ref.watch(quizHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),

        /// O botão de limpeza só aparece quando existem registos.
        actions: [
          if (history.isNotEmpty)
            IconButton(
              tooltip: 'Limpar histórico',
              onPressed: () {
                _confirmClearHistory(context, ref);
              },
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),

      /// Apresenta um estado vazio quando ainda não existem quizzes.
      body: history.isEmpty
          ? const _EmptyHistory()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                final item = history[index];

                return _HistoryCard(
                  history: item,
                  formattedDate: _formatDate(item.completedAt),
                  onDelete: () {
                    _confirmDelete(context, ref, item);
                  },
                );
              },
            ),
    );
  }
}

/// Estado apresentado quando ainda não existe histórico.
class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 72,
              color: AppColors.textSecondary,
            ),

            SizedBox(height: 18),

            Text(
              'Ainda não existem quizzes concluídos.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 8),

            Text(
              'Os teus resultados serão apresentados aqui depois de concluíres um quiz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card responsável por representar uma tentativa no histórico.
class _HistoryCard extends StatelessWidget {
  /// Tentativa apresentada pelo card.
  final QuizHistoryModel history;

  /// Data já formatada pelo ecrã.
  final String formattedDate;

  /// Acção utilizada para eliminar o registo.
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.history,
    required this.formattedDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /// Identificação visual da tentativa.
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.quiz_outlined,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Categoria realizada.
                      Text(
                        history.category.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// Dificuldade da tentativa.
                      Text(
                        history.difficulty.title,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                /// Permite eliminar apenas esta tentativa.
                IconButton(
                  tooltip: 'Eliminar tentativa',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// Pontuação obtida.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${history.correctAnswers}'
                  ' / '
                  '${history.totalQuestions}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${history.percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Barra visual da pontuação.
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: history.percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.secondary,
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// Data em que o quiz foi realizado.
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),

                const SizedBox(width: 7),

                Text(
                  formattedDate,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
