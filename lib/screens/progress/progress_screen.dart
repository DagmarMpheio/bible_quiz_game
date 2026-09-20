import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../models/achievement_model.dart';
import '../../models/user_progress_model.dart';
import '../../providers/user_progress_provider.dart';

/// Ecrã responsável por apresentar a progressão do utilizador.
///
/// Mostra:
///
/// - nível;
/// - XP;
/// - progresso para o próximo nível;
/// - sequência actual;
/// - melhor sequência;
/// - conquistas.
class ProgressScreen extends ConsumerWidget {
  /// Nome utilizado pelo GoRouter.
  static const String routeName = 'progress-screen';

  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Observa o progresso calculado a partir do histórico.
    final progress = ref.watch(userProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progresso')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Card principal com nível e XP.
          _LevelCard(progress: progress),

          const SizedBox(height: 16),

          /// Informação relativa às sequências.
          Row(
            children: [
              Expanded(
                child: _StreakCard(
                  icon: Icons.local_fire_department_outlined,
                  title: 'Sequência actual',
                  value: progress.currentStreak,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StreakCard(
                  icon: Icons.emoji_events_outlined,
                  title: 'Melhor sequência',
                  value: progress.longestStreak,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Conquistas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              /// Apresenta quantas conquistas já foram alcançadas.
              Text(
                '${progress.unlockedAchievements}'
                '/'
                '${progress.achievements.length}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Apresenta todas as conquistas disponíveis.
          ...progress.achievements.map((achievement) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AchievementCard(achievement: achievement),
            );
          }),
        ],
      ),
    );
  }
}

/// Card principal responsável pelo nível e XP.
class _LevelCard extends StatelessWidget {
  /// Progresso actual do utilizador.
  final UserProgressModel progress;

  const _LevelCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Representação visual do nível.
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${progress.level}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Nível ${progress.level}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              '${progress.totalXp} XP acumulados',
              style: const TextStyle(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 20),

            /// Barra de progresso para o nível seguinte.
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress.levelProgress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.secondary,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${progress.currentLevelXp}'
                  ' / '
                  '${UserProgressModel.xpPerLevel} XP',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),

                Text(
                  'Faltam '
                  '${progress.xpToNextLevel} XP',
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

/// Card utilizado para apresentar as sequências de actividade.
class _StreakCard extends StatelessWidget {
  /// Ícone representativo.
  final IconData icon;

  /// Título da informação.
  final String title;

  /// Número de dias.
  final int value;

  const _StreakCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Column(
          children: [
            Icon(icon, color: AppColors.secondary, size: 30),

            const SizedBox(height: 10),

            Text(
              '$value',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              value == 1 ? '1 dia' : '$value dias',
              style: const TextStyle(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card responsável por apresentar uma conquista.
class _AchievementCard extends StatelessWidget {
  /// Estado da conquista apresentada.
  final AchievementProgress achievement;

  const _AchievementCard({required this.achievement});

  /// Retorna um ícone apropriado à conquista.
  IconData get _icon {
    switch (achievement.type) {
      case AchievementType.primeiroQuiz:
        return Icons.flag_outlined;

      case AchievementType.perfeccionista:
        return Icons.workspace_premium_outlined;

      case AchievementType.veterano:
        return Icons.military_tech_outlined;

      case AchievementType.sequenciaTresDias:
        return Icons.local_fire_department_outlined;

      case AchievementType.exploradorBiblico:
        return Icons.explore_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            /// Ícone da conquista.
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: unlocked
                    ? AppColors.secondary.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                color: unlocked ? AppColors.secondary : AppColors.textSecondary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.type.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      if (unlocked)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    achievement.type.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  if (!unlocked) ...[
                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: achievement.progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.secondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${achievement.currentValue}'
                      '/'
                      '${achievement.targetValue}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
