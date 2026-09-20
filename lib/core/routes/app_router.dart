import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/models/quiz_mode.dart';
import 'package:go_router/go_router.dart';
import '/screens/views.dart';

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

    /// Ecrã de selecção da dificuldade.
    ///
    /// Recebe a categoria seleccionada anteriormente.
    GoRoute(
      path: '/difficulty/:category',
      name: DifficultyScreen.routeName,
      builder: (context, state) {
        /// Obtém o nome da categoria através da rota.
        final categoryName = state.pathParameters['category']!;

        /// Converte o texto novamente para o enum correspondente.
        final category = QuizCategory.values.byName(categoryName);

        return DifficultyScreen(category: category);
      },
    ),

    /// Ecrã onde as perguntas são apresentadas.
    ///
    /// A rota recebe a categoria e a dificuldade escolhidas.
    GoRoute(
      path: '/quiz/:category/:difficulty',
      name: QuizScreen.routeName,
      builder: (context, state) {
        final category = QuizCategory.values.byName(
          state.pathParameters['category']!,
        );

        final difficulty = QuizDifficulty.values.byName(
          state.pathParameters['difficulty']!,
        );

        /// Lê o modo enviado através da query string.
        final modeName = state.uri.queryParameters['mode'];

        final mode = QuizMode.values.firstWhere(
          (item) {
            return item.name == modeName;
          },
          orElse: () {
            return QuizMode.standard;
          },
        );

        return QuizScreen(
          category: category,
          difficulty: difficulty,
          mode: mode,
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

    /// Tela utilizada para rever as respostas dadas durante o quiz.
    GoRoute(
      path: '/review-answers',
      name: ReviewAnswersScreen.routeName,
      builder: (context, state) {
        return const ReviewAnswersScreen();
      },
    ),

    /// Rota responsável por apresentar informações institucionais
    /// e legais relacionadas com a aplicação.
    GoRoute(
      path: '/about',
      name: AboutScreen.routeName,
      builder: (context, state) {
        return const AboutScreen();
      },
    ),

    /// Rota responsável por apresentar o histórico
    /// das tentativas realizadas pelo utilizador.
    GoRoute(
      path: '/history',
      name: HistoryScreen.routeName,
      builder: (context, state) {
        return const HistoryScreen();
      },
    ),

    /// Rota responsável por apresentar as estatísticas
    /// de desempenho do utilizador.
    GoRoute(
      path: '/statistics',
      name: StatisticsScreen.routeName,
      builder: (context, state) {
        return const StatisticsScreen();
      },
    ),

    /// Rota responsável por apresentar o progresso,
    /// nível, XP, sequências e conquistas do utilizador.
    GoRoute(
      path: '/progress',
      name: ProgressScreen.routeName,
      builder: (context, state) {
        return const ProgressScreen();
      },
    ),

    /// Rota de entrada do desafio diário.
    GoRoute(
      path: '/daily-quiz',
      name: DailyQuizScreen.routeName,
      builder: (context, state) {
        return const DailyQuizScreen();
      },
    ),
  ],
);
