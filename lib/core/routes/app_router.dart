import 'package:bible_quiz_game/models/category_model.dart';
import 'package:go_router/go_router.dart';

import '../../screens/categories/categories_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/quiz/quiz_screen.dart';
import '../../screens/result/result_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.routeName,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),

    GoRoute(
      path: '/categories',
      name: CategoriesScreen.routeName,
      builder: (context, state) {
        return const CategoriesScreen();
      },
    ),

    GoRoute(
      path: '/quiz/:category',
      name: QuizScreen.routeName,
      builder: (context, state) {
        final categoryName =
            state.pathParameters['category']!;

        final category =
            QuizCategory.values.byName(
          categoryName,
        );

        return QuizScreen(
          category: category,
        );
      },
    ),

    GoRoute(
      path: '/result',
      name: ResultScreen.routeName,
      builder: (context, state) {
        return const ResultScreen();
      },
    ),
  ],
);