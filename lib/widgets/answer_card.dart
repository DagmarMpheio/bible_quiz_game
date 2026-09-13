import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Widget reutilizável responsável por apresentar uma alternativa do quiz.
///
/// O card adapta a sua aparência de acordo com o estado da resposta:
/// - neutro enquanto a pergunta ainda não foi respondida;
/// - verde quando representa a alternativa correta;
/// - vermelho quando representa a alternativa incorreta selecionada.
///
/// A própria validação da resposta permanece no provider; este widget cuida
/// apenas da apresentação visual e do evento de toque.
class AnswerCard extends StatelessWidget {
  /// Índice da alternativa dentro da lista de respostas.
  final int index;

  /// Texto apresentado ao utilizador.
  final String text;

  /// Índice da alternativa selecionada pelo utilizador.
  ///
  /// É `null` enquanto nenhuma resposta tiver sido escolhida.
  final int? selectedAnswer;

  /// Índice da alternativa correta.
  final int correctAnswer;

  /// Indica se a pergunta actual já foi respondida.
  final bool answered;

  /// Callback executado quando o utilizador toca no card.
  final VoidCallback onTap;

  const AnswerCard({
    super.key,
    required this.index,
    required this.text,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.answered,
    required this.onTap,
  });

  /// Retorna `true` quando este card corresponde à resposta selecionada.
  bool get isSelected => selectedAnswer == index;

  /// Retorna `true` quando este card representa a resposta correta.
  bool get isCorrect => correctAnswer == index;

  /// Constrói a representação visual da alternativa.
  @override
  Widget build(BuildContext context) {
    /// Valores visuais padrão antes de a pergunta ser respondida.
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color circleColor = Colors.grey.shade100;
    Color textColor = AppColors.textPrimary;

    /// Ícone exibido ao lado da alternativa depois da resposta.
    IconData? statusIcon;

    /// Cor do ícone de estado.
    Color? statusIconColor;

    if (answered) {
      if (isCorrect) {
        /// Toda resposta correta é destacada em verde, independentemente de ter
        /// sido ou não a alternativa escolhida pelo utilizador.
        backgroundColor = AppColors.success.withValues(alpha: 0.10);

        borderColor = AppColors.success;
        circleColor = AppColors.success;
        textColor = AppColors.success;

        statusIcon = Icons.check_circle;
        statusIconColor = AppColors.success;
      } else if (isSelected) {
        /// Se o utilizador selecionar uma resposta errada, apenas essa opção
        /// incorreta é destacada em vermelho.
        backgroundColor = AppColors.error.withValues(alpha: 0.10);

        borderColor = AppColors.error;
        circleColor = AppColors.error;
        textColor = AppColors.error;

        statusIcon = Icons.cancel;
        statusIconColor = AppColors.error;
      }
    }

    return InkWell(
      /// Desativa novos toques depois de a pergunta ser respondida.
      onTap: answered ? null : onTap,

      borderRadius: BorderRadius.circular(16),

      child: AnimatedContainer(
        /// Cria uma transição suave quando as cores do card mudam.
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,

            /// Reforça visualmente a borda da resposta correta ou selecionada.
            width: answered && (isCorrect || isSelected) ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            /// Círculo responsável por apresentar A, B, C, D...
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                /// O código ASCII 65 corresponde à letra "A".
                /// Somando o índice, obtemos A, B, C, D...
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: answered && (isCorrect || isSelected)
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// Texto principal da alternativa.
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// Mostra o ícone somente quando existe um estado a representar.
            if (statusIcon != null) Icon(statusIcon, color: statusIconColor),
          ],
        ),
      ),
    );
  }
}
