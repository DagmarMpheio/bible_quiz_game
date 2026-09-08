import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/screens/quiz/quiz_screen.dart';
import 'package:bible_quiz_game/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatelessWidget {
  static const String routeName = 'categories-screen';
  const CategoriesScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: QuizCategory.values.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          final category = QuizCategory.values[index];

          return CategoryCard(
            title: category.title,
            icon: _getCategoryIcon(category),
            onTap: () {
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
