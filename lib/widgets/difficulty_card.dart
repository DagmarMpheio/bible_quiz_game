import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Card reutilizável utilizado para apresentar um nível de dificuldade.
///
/// O widget apresenta:
/// - ícone;
/// - título;
/// - descrição;
/// - estado disponível ou indisponível;
/// - acção executada quando é seleccionado.
class DifficultyCard extends StatelessWidget {
  /// Título do nível.
  final String title;

  /// Descrição apresentada abaixo do título.
  final String description;

  /// Ícone associado ao nível de dificuldade.
  final IconData icon;

  /// Indica se o nível possui perguntas disponíveis.
  final bool enabled;

  /// Acção executada quando o utilizador selecciona o card.
  final VoidCallback onTap;

  const DifficultyCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  /// Constrói a representação visual do nível de dificuldade.
  @override
  Widget build(BuildContext context) {
    return Opacity(
      /// Níveis indisponíveis continuam visíveis, mas com menor destaque.
      opacity: enabled ? 1 : 0.45,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          /// O toque é desactivado quando não existem perguntas
          /// disponíveis para este nível.
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                /// Área visual que contém o ícone da dificuldade.
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),

                const SizedBox(width: 16),

                /// Título e descrição do nível.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        enabled
                            ? description
                            : 'Ainda não existem perguntas disponíveis neste nível.',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                /// Só apresenta a seta quando o nível pode ser seleccionado.
                if (enabled)
                  const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
