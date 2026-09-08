import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/screens/quiz/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//===============================================================
// Tela que apresenta as categorias disponíveis para o quiz.
//===============================================================
class CategoriesScreen extends StatelessWidget {
  static const String routeName = 'categories-screen';
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: QuizCategory.values.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final category = QuizCategory.values[index];

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: const CircleAvatar(child: Icon(Icons.menu_book)),
              title: Text(
                category.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onTap: () {
                context.pushNamed(
                  QuizScreen.routeName,
                  pathParameters: {'category': category.name},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
