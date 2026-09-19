import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/models/question_model.dart';
import 'package:bible_quiz_game/models/quiz_answer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/question_repository.dart';

/// Provider responsável por disponibilizar o repositório de perguntas.
///
/// Actualmente utiliza [LocalQuestionRepository], porém esta implementação
/// poderá ser substituída futuramente por Hive CE, Firebase ou uma API.
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return LocalQuestionRepository();
});

/// Provider assíncrono responsável por obter os níveis de
/// dificuldade disponíveis para determinada categoria.
///
/// A família (`family`) permite fornecer uma categoria diferente
/// como parâmetro para cada consulta.
final availableDifficultiesProvider =
    FutureProvider.family<List<QuizDifficulty>, QuizCategory>((
      ref,
      category,
    ) async {
      /// Obtém o repositório configurado na aplicação.
      final repository = ref.watch(questionRepositoryProvider);

      /// Consulta os níveis que possuem perguntas disponíveis.
      return repository.getAvailableDifficulties(category);
    });

/// Representa todo o estado necessário durante uma sessão do quiz.
///
/// Esta classe é imutável. Sempre que alguma informação do quiz é alterada,
/// o [QuizNotifier] cria uma nova instância de [QuizState].
///
/// O estado guarda:
/// - categoria selecionada;
/// - perguntas da sessão;
/// - pergunta actual;
/// - quantidade de acertos;
/// - alternativa selecionada;
/// - informação sobre a pergunta ter sido respondida;
/// - histórico completo das respostas.
class QuizState {
  /// Categoria escolhida para o quiz actual.
  ///
  /// Antes de um quiz ser iniciado, este valor será `null`.
  final QuizCategory? category;

  /// Lista de perguntas utilizadas na sessão actual.
  final List<QuestionModel> questions;

  /// Índice da pergunta actualmente apresentada.
  ///
  /// O índice começa em zero.
  final int currentIndex;

  /// Quantidade de perguntas respondidas corretamente.
  final int correctAnswers;

  /// Índice da alternativa escolhida na pergunta actual.
  ///
  /// Será `null` enquanto o utilizador ainda não tiver respondido.
  final int? selectedAnswer;

  /// Nível de dificuldade escolhido para a sessão actual.
  ///
  /// Antes de um quiz ser iniciado, este valor será `null`.
  final QuizDifficulty? difficulty;

  /// Indica se a pergunta actual já foi respondida.
  ///
  /// Esta propriedade impede que o utilizador responda mais de uma
  /// vez à mesma pergunta.
  final bool answered;

  /// Histórico das respostas dadas durante a sessão actual.
  ///
  /// Cada elemento contém:
  /// - a pergunta;
  /// - a alternativa escolhida;
  /// - informação sobre a resposta estar correta ou incorreta.
  final List<QuizAnswerModel> answerHistory;

  /// Identificador único da sessão actual.
  ///
  /// É criado quando o utilizador inicia um novo quiz e permanece
  /// igual até que essa sessão termine.
  ///
  /// Também é utilizado como identificador do histórico.
  final String? sessionId;

  /// Cria um estado do quiz.
  ///
  /// Os valores padrão representam um quiz ainda não iniciado.
  const QuizState({
    this.sessionId,
    this.category,
    this.questions = const [],
    this.currentIndex = 0,
    this.correctAnswers = 0,
    this.selectedAnswer,
    this.answered = false,
    this.answerHistory = const [],
    this.difficulty,
  });

  /// Retorna a pergunta actualmente apresentada.
  ///
  /// Retorna `null` quando:
  /// - não existem perguntas carregadas;
  /// - o índice actual ultrapassa o tamanho da lista.
  QuestionModel? get currentQuestion {
    if (questions.isEmpty || currentIndex >= questions.length) {
      return null;
    }

    return questions[currentIndex];
  }

  /// Verifica se a pergunta actual é a última da sessão.
  bool get isLastQuestion {
    if (questions.isEmpty) {
      return false;
    }

    return currentIndex == questions.length - 1;
  }
}

/// Controlador responsável pelas regras de negócio do quiz.
///
/// O [QuizNotifier] controla:
/// - início de uma sessão;
/// - registo das respostas;
/// - cálculo da pontuação;
/// - histórico das respostas;
/// - mudança de pergunta;
/// - reinicialização do quiz.
class QuizNotifier extends Notifier<QuizState> {
  /// Define o estado inicial do quiz.
  @override
  QuizState build() {
    return const QuizState();
  }

  /// Inicia uma nova sessão do Quiz Bíblico.
  ///
  /// Cada nova tentativa recebe um identificador próprio.
  /// Esse identificador será posteriormente utilizado para
  /// persistir o resultado no histórico.
  void startQuiz(
    QuizCategory category,
    QuizDifficulty difficulty,
    List<QuestionModel> questions,
  ) {
    state = QuizState(
      /// O timestamp em microssegundos fornece um identificador
      /// suficientemente único para sessões locais.
      sessionId: 'quiz-${DateTime.now().microsecondsSinceEpoch}',

      category: category,
      difficulty: difficulty,
      questions: questions,
    );
  }

  /// Regista a alternativa escolhida pelo utilizador.
  ///
  /// [answerIndex] corresponde ao índice da alternativa selecionada.
  ///
  /// Este método:
  /// 1. verifica se a pergunta já foi respondida;
  /// 2. obtém a pergunta actual;
  /// 3. verifica se a resposta está correta;
  /// 4. cria um registo para o histórico;
  /// 5. actualiza a pontuação;
  /// 6. marca a pergunta como respondida.
  void answerQuestion(int answerIndex) {
    /// Impede que a mesma pergunta seja respondida novamente.
    ///
    /// Sem esta verificação seria possível aumentar a pontuação
    /// várias vezes na mesma pergunta.
    if (state.answered) {
      return;
    }

    /// Obtém a pergunta actualmente apresentada.
    final question = state.currentQuestion;

    /// Caso não exista uma pergunta válida, interrompe a operação.
    if (question == null) {
      return;
    }

    /// Verifica se a alternativa escolhida corresponde à correta.
    final isCorrect = answerIndex == question.correctAnswerIndex;

    /// Cria o registo da resposta dada pelo utilizador.
    final answerRecord = QuizAnswerModel(
      question: question,
      selectedAnswerIndex: answerIndex,
    );

    /// Atualiza o estado do quiz.
    state = QuizState(
      /// Mantém o identificador da sessão actual.
      sessionId: state.sessionId,

      /// Mantém a categoria seleccionada durante toda a sessão.
      category: state.category,

      /// Mantém a dificuldade durante toda a sessão.
      difficulty: state.difficulty,
      questions: state.questions,
      currentIndex: state.currentIndex,

      /// Soma 1 apenas quando a resposta estiver correta.
      correctAnswers: state.correctAnswers + (isCorrect ? 1 : 0),

      /// Guarda a alternativa escolhida para permitir que a interface
      /// destaque visualmente a resposta.
      selectedAnswer: answerIndex,

      /// Marca a pergunta actual como respondida.
      answered: true,

      /// Cria uma nova lista contendo todas as respostas anteriores
      /// mais a resposta actual.
      ///
      /// Como o estado é imutável, não modificamos diretamente a lista
      /// existente.
      answerHistory: [...state.answerHistory, answerRecord],
    );
  }

  /// Avança para a próxima pergunta.
  ///
  /// Só é possível avançar se:
  /// - a pergunta actual já tiver sido respondida;
  /// - a pergunta actual não for a última.
  void nextQuestion() {
    /// Impede o avanço indevido.
    if (!state.answered || state.isLastQuestion) {
      return;
    }

    /// Cria o estado correspondente à próxima pergunta.
    state = QuizState(
      /// Mantém o identificador da sessão actual.
      sessionId: state.sessionId,
      category: state.category,

      /// Preserva o nível seleccionado.
      difficulty: state.difficulty,
      questions: state.questions,

      /// Incrementa o índice da pergunta.
      currentIndex: state.currentIndex + 1,

      /// Mantém a quantidade acumulada de acertos.
      correctAnswers: state.correctAnswers,

      /// Mantém todo o histórico das respostas.
      answerHistory: state.answerHistory,

      /// `selectedAnswer` não é informado e, portanto, volta a `null`.
      ///
      /// `answered` também não é informado e volta a `false`.
      ///
      /// Isso prepara o estado para a próxima pergunta.
    );
  }

  /// Reinicia completamente a sessão do quiz.
  ///
  /// Este método é chamado ao:
  /// - jogar novamente;
  /// - voltar para a Home;
  /// - iniciar uma nova tentativa.
  void resetQuiz() {
    state = const QuizState();
  }
}

/// Provider principal responsável pelo estado do Quiz Bíblico.
///
/// Para observar o estado:
///
/// ```dart
/// ref.watch(quizProvider);
/// ```
///
/// Para executar ações:
///
/// ```dart
/// ref.read(quizProvider.notifier);
/// ```
final quizProvider = NotifierProvider<QuizNotifier, QuizState>(
  QuizNotifier.new,
);
