import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';


//======================================================================
//Widget de Progresso do Quiz
//=====================================================================
class QuizProgress extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const QuizProgress({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions == 0
        ? 0.0
        : currentQuestion / totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pergunta $currentQuestion de $totalQuestions',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
