import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Widget responsável por apresentar o progresso do utilizador no quiz.
///
/// Mostra:
/// - o número da pergunta actual;
/// - o total de perguntas;
/// - a percentagem correspondente;
/// - uma barra de progresso visual.
class QuizProgress extends StatelessWidget {
  /// Número da pergunta actualmente apresentada.
  ///
  /// Para a interface, este valor normalmente começa em `1`.
  final int currentQuestion;

  /// Quantidade total de perguntas da sessão actual.
  final int totalQuestions;

  const QuizProgress({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  /// Constrói o indicador de progresso.
  @override
  Widget build(BuildContext context) {
    /// Calcula o progresso numa escala entre 0.0 e 1.0.
    ///
    /// A verificação evita divisão por zero caso não existam perguntas.
    final progress = totalQuestions == 0
        ? 0.0
        : currentQuestion / totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Linha que apresenta o contador e a percentagem.
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

        /// Recorta a barra para que os cantos fiquem arredondados.
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
