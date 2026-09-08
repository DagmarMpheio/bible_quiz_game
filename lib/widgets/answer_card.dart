import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

//======================================================================
//Widget de Card de Resposta
//=====================================================================
class AnswerCard extends StatelessWidget {
  final int index;
  final String text;

  final int? selectedAnswer;
  final int correctAnswer;

  final bool answered;

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

  bool get isSelected => selectedAnswer == index;

  bool get isCorrect => correctAnswer == index;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color circleColor = Colors.grey.shade100;
    Color textColor = AppColors.textPrimary;

    IconData? statusIcon;
    Color? statusIconColor;

    if (answered) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withValues(
          alpha: 0.10,
        );

        borderColor = AppColors.success;
        circleColor = AppColors.success;
        textColor = AppColors.success;

        statusIcon = Icons.check_circle;
        statusIconColor = AppColors.success;
      } else if (isSelected) {
        backgroundColor = AppColors.error.withValues(
          alpha: 0.10,
        );

        borderColor = AppColors.error;
        circleColor = AppColors.error;
        textColor = AppColors.error;

        statusIcon = Icons.cancel;
        statusIconColor = AppColors.error;
      }
    }

    return InkWell(
      onTap: answered ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: answered && (isCorrect || isSelected)
                ? 1.5
                : 1,
          ),
        ),
        child: Row(
          children: [
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
                String.fromCharCode(
                  65 + index,
                ),
                style: TextStyle(
                  color: answered &&
                          (isCorrect || isSelected)
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

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

            if (statusIcon != null)
              Icon(
                statusIcon,
                color: statusIconColor,
              ),
          ],
        ),
      ),
    );
  }
}