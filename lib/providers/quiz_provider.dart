import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/question_repository.dart';

/// Provider responsável por disponibilizar o repositório de perguntas.
///
/// Através deste provider, qualquer widget ou notifier que possua acesso ao
/// Riverpod pode obter uma implementação de [QuestionRepository].
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return LocalQuestionRepository();
});

/// Representa todo o estado necessário durante a execução de um quiz.
///
/// O estado é imutável: sempre que algum dado muda, o [QuizNotifier] cria uma
/// nova instância de [QuizState]. Isso torna as alterações previsíveis e
/// permite ao Riverpod reconstruir somente os widgets dependentes.
class QuizState {
  /// Categoria atualmente selecionada.
  ///
  /// É `null` antes de um quiz ser iniciado.
  final QuizCategory? category;

  /// Perguntas carregadas para a sessão actual.
  final List<QuestionModel> questions;

  /// Índice da pergunta atualmente apresentada.
  ///
  /// O índice começa em `0`.
  final int currentIndex;

  /// Quantidade de respostas corretas acumuladas.
  final int correctAnswers;

  /// Índice da alternativa selecionada na pergunta actual.
  ///
  /// É `null` enquanto o utilizador ainda não respondeu.
  final int? selectedAnswer;

  /// Indica se a pergunta actual já foi respondida.
  final bool answered;

  /// Cria um estado para o quiz.
  ///
  /// Os valores padrão representam um quiz ainda não iniciado.
  const QuizState({
    this.category,
    this.questions = const [],
    this.currentIndex = 0,
    this.correctAnswers = 0,
    this.selectedAnswer,
    this.answered = false,
  });

  /// Retorna a pergunta atualmente ativa.
  ///
  /// Retorna `null` quando não existem perguntas carregadas ou quando
  /// [currentIndex] está fora dos limites da lista.
  QuestionModel? get currentQuestion {
    if (questions.isEmpty || currentIndex >= questions.length) {
      return null;
    }

    return questions[currentIndex];
  }

  /// Indica se a pergunta actual é a última pergunta da sessão.
  bool get isLastQuestion {
    if (questions.isEmpty) {
      return false;
    }

    return currentIndex == questions.length - 1;
  }
}

/// Controlador responsável por gerir todas as alterações de estado do quiz.
///
/// O [QuizNotifier] concentra as regras de negócio da sessão: início do quiz,
/// validação das respostas, avanço entre perguntas e reinicialização.
class QuizNotifier extends Notifier<QuizState> {
  /// Define o estado inicial do provider.
  @override
  QuizState build() {
    return const QuizState();
  }

  /// Inicia uma nova sessão de quiz.
  ///
  /// [category] identifica o tema escolhido e [questions] contém a lista que
  /// será utilizada durante esta tentativa.
  ///
  /// Ao iniciar, os contadores e seleções voltam aos valores padrão.
  void startQuiz(QuizCategory category, List<QuestionModel> questions) {
    state = QuizState(category: category, questions: questions);
  }

  /// Regista a resposta selecionada pelo utilizador.
  ///
  /// [answerIndex] corresponde ao índice da alternativa selecionada.
  ///
  /// A resposta só pode ser registada uma vez por pergunta. Se a alternativa
  /// estiver correta, [QuizState.correctAnswers] é incrementado.
  void answerQuestion(int answerIndex) {
    /// Impede que uma pergunta já respondida seja pontuada novamente.
    if (state.answered) {
      return;
    }

    /// Obtém a pergunta que está atualmente visível.
    final question = state.currentQuestion;

    /// Interrompe o método se não existir uma pergunta válida.
    if (question == null) {
      return;
    }

    /// Verifica se o índice selecionado coincide com a resposta correta.
    final isCorrect = answerIndex == question.correctAnswerIndex;

    /// Cria um novo estado preservando os dados anteriores e registando a
    /// resposta selecionada.
    state = QuizState(
      category: state.category,
      questions: state.questions,
      currentIndex: state.currentIndex,
      correctAnswers: state.correctAnswers + (isCorrect ? 1 : 0),
      selectedAnswer: answerIndex,
      answered: true,
    );
  }

  /// Avança para a próxima pergunta da sessão.
  ///
  /// O avanço só é permitido depois de responder à pergunta actual e quando
  /// ainda existe uma pergunta seguinte.
  void nextQuestion() {
    /// Impede avanço sem resposta ou após a última pergunta.
    if (!state.answered || state.isLastQuestion) {
      return;
    }

    /// Incrementa o índice e limpa implicitamente a seleção/resposta porque
    /// `selectedAnswer` e `answered` utilizam os valores padrão do construtor.
    state = QuizState(
      category: state.category,
      questions: state.questions,
      currentIndex: state.currentIndex + 1,
      correctAnswers: state.correctAnswers,
    );
  }

  /// Reinicia completamente o estado do quiz.
  ///
  /// É utilizado ao voltar para o início ou ao preparar uma nova tentativa.
  void resetQuiz() {
    state = const QuizState();
  }
}

/// Provider principal responsável pelo estado e pelas ações do Quiz Bíblico.
///
/// Widgets podem observar este provider com `ref.watch(quizProvider)` e executar
/// ações através de `ref.read(quizProvider.notifier)`.
final quizProvider = NotifierProvider<QuizNotifier, QuizState>(
  QuizNotifier.new,
);
