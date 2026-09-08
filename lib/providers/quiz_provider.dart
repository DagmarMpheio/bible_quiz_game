import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/question_repository.dart';

//=============================================================
// Provider responsável por fornecer o repositório de perguntas.
//=============================================================
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return LocalQuestionRepository();
});

//===================================================
// Classe responsável por gerenciar o estado do quiz.
//==================================================
class QuizState {
  final QuizCategory? category;

  final List<QuestionModel> questions;

  final int currentIndex;

  final int correctAnswers;

  final int? selectedAnswer;

  final bool answered;

  const QuizState({
    this.category,
    this.questions = const [],
    this.currentIndex = 0,
    this.correctAnswers = 0,
    this.selectedAnswer,
    this.answered = false,
  });

  QuestionModel? get currentQuestion {
    if (questions.isEmpty || currentIndex >= questions.length) {
      return null;
    }

    return questions[currentIndex];
  }

  bool get isLastQuestion {
    if (questions.isEmpty) {
      return false;
    }

    return currentIndex == questions.length - 1;
  }
}

class QuizNotifier extends Notifier<QuizState> {
  @override
  QuizState build() {
    return const QuizState();
  }

  void startQuiz(QuizCategory category, List<QuestionModel> questions) {
    state = QuizState(category: category, questions: questions);
  }

  void answerQuestion(int answerIndex) {
    if (state.answered) {
      return;
    }

    final question = state.currentQuestion;

    if (question == null) {
      return;
    }

    final isCorrect = answerIndex == question.correctAnswerIndex;

    state = QuizState(
      category: state.category,
      questions: state.questions,
      currentIndex: state.currentIndex,
      correctAnswers: state.correctAnswers + (isCorrect ? 1 : 0),
      selectedAnswer: answerIndex,
      answered: true,
    );
  }

  void nextQuestion() {
    if (!state.answered || state.isLastQuestion) {
      return;
    }

    state = QuizState(
      category: state.category,
      questions: state.questions,
      currentIndex: state.currentIndex + 1,
      correctAnswers: state.correctAnswers,
    );
  }

  void resetQuiz() {
    state = const QuizState();
  }
}

//=====================================================
// Provider responsável por fornecer o estado do quiz.
final quizProvider = NotifierProvider<QuizNotifier, QuizState>(
  QuizNotifier.new,
);
