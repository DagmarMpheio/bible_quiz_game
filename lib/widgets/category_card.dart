import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Widget reutilizável utilizado para representar uma categoria do quiz.
///
/// Recebe o título, o ícone e a acção a executar quando o utilizador toca no
/// card. Dessa forma, a [CategoriesScreen] permanece simples e focada apenas na
/// construção da lista de categorias.
class CategoryCard extends StatelessWidget {
  /// Nome da categoria apresentado no card.
  final String title;

  /// Ícone visual associado à categoria.
  final IconData icon;

  /// Acção executada quando o card é pressionado.
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  /// Constrói a interface do card de categoria.
  @override
  Widget build(BuildContext context) {
    return Card(
      /// O card utiliza uma borda leve em vez de sombra.
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        /// Executa a navegação/acção fornecida pela tela pai.
        onTap: onTap,

        /// Mantém o efeito de toque dentro do formato arredondado do card.
        borderRadius: BorderRadius.circular(18),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              /// Área decorativa que contém o ícone da categoria.
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),

              const SizedBox(width: 16),

              /// O Expanded evita overflow caso o nome da categoria seja longo.
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              /// Indica visualmente que o item leva a outra tela.
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
