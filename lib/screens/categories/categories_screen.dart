import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/screens/views.dart';
import 'package:bible_quiz_game/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tela responsável por apresentar todas as categorias disponíveis.
///
/// Cada categoria é representada por um [CategoryCard]. Ao tocar numa categoria,
/// o utilizador é encaminhado para [QuizScreen] e o nome da categoria é enviado
/// como parâmetro da rota.
class CategoriesScreen extends StatelessWidget {
  /// Nome da rota utilizado pelo GoRouter.
  static const String routeName = 'categories-screen';

  const CategoriesScreen({super.key});

  /// Retorna o ícone correspondente a uma categoria.
  ///
  /// Centralizar esta decisão num único método evita condicionais na construção
  /// de cada item da lista.
  IconData _getCategoryIcon(QuizCategory category) {
    switch (category) {
      case QuizCategory.geral:
        return Icons.quiz_rounded;

      case QuizCategory.antigoTestamento:
        return Icons.history_edu_rounded;

      case QuizCategory.novoTestamento:
        return Icons.auto_stories_rounded;

      case QuizCategory.jesusCristo:
        return Icons.favorite_rounded;

      case QuizCategory.personagens:
        return Icons.groups_rounded;

      case QuizCategory.reisEProfetas:
        return Icons.workspace_premium_rounded;

      case QuizCategory.livrosDaBiblia:
        return Icons.menu_book_rounded;
    }
  }

  /// Constrói a interface da tela de categorias.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: ListView.separated(
        /// Espaçamento externo da lista.
        padding: const EdgeInsets.all(16),

        /// O número de itens corresponde à quantidade de valores do enum.
        itemCount: QuizCategory.values.length,

        /// Espaçamento vertical entre os cards.
        separatorBuilder: (_, _) {
          return const SizedBox(height: 10);
        },

        /// Constrói cada categoria disponível.
        itemBuilder: (context, index) {
          /// Recupera a categoria correspondente à posição actual.
          final category = QuizCategory.values[index];

          return CategoryCard(
            title: category.title,
            icon: _getCategoryIcon(category),
            onTap: () {
              /// Abre o quiz e envia o nome interno da categoria como parâmetro.
              context.pushNamed(
                QuizScreen.routeName,
                pathParameters: {'category': category.name},
              );
            },
          );
        },
      ),
    );
  }
}
