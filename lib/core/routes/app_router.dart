import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../screens/categories/categories_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/quiz/quiz_screen.dart';
import '../../screens/result/result_screen.dart';

/// Configuração central de navegação da aplicação.
///
/// O [GoRouter] define todas as rotas disponíveis no Quiz Bíblico e estabelece
/// qual tela deve ser apresentada para cada caminho.
///
/// A rota inicial é `/`, que apresenta a [SplashScreen].
final GoRouter appRouter = GoRouter(
  /// Caminho carregado assim que a aplicação é iniciada.
  initialLocation: '/',

  /// Lista de rotas disponíveis no aplicativo.
  routes: [
    /// Rota da tela de abertura.
    GoRoute(
      path: '/',
      name: SplashScreen.routeName,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),

    /// Rota da tela inicial.
    GoRoute(
      path: '/home',
      name: HomeScreen.routeName,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),

    /// Rota responsável por apresentar as categorias do quiz.
    GoRoute(
      path: '/categories',
      name: CategoriesScreen.routeName,
      builder: (context, state) {
        return const CategoriesScreen();
      },
    ),

    /// Rota da tela do quiz.
    ///
    /// O parâmetro dinâmico `:category` identifica a categoria escolhida pelo
    /// utilizador e permite reconstruir o respetivo valor de [QuizCategory].
    GoRoute(
      path: '/quiz/:category',
      name: QuizScreen.routeName,
      builder: (context, state) {
        /// Obtém o nome da categoria recebido através da URL.
        ///
        /// O operador `!` é utilizado porque esta rota só é válida quando o
        /// parâmetro `category` estiver presente.
        final categoryName = state.pathParameters['category']!;

        /// Converte o texto recebido na rota para o respetivo valor do enum.
        final category = QuizCategory.values.byName(categoryName);

        /// Abre o quiz já configurado com a categoria escolhida.
        return QuizScreen(
          category: category,
        );
      },
    ),

    /// Rota utilizada para apresentar o resultado final do quiz.
    GoRoute(
      path: '/result',
      name: ResultScreen.routeName,
      builder: (context, state) {
        return const ResultScreen();
      },
    ),
  ],
);
