import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/screens/result/result_screen.dart';
import 'package:bible_quiz_game/widgets/answer_card.dart';
import 'package:bible_quiz_game/widgets/quiz_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/quiz_provider.dart';

//===============================================================
// Tela que apresenta as perguntas do quiz com opções de resposta.
//===============================================================
class QuizScreen extends ConsumerStatefulWidget {
  final QuizCategory category;
  static const String routeName = 'quiz-screen';

  const QuizScreen({super.key, required this.category});

  @override
  ConsumerState<QuizScreen> createState() {
    return _QuizScreenState();
  }
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestions();
    });
  }

  void _loadQuestions() {
    final repository = ref.read(questionRepositoryProvider);

    final questions = repository.getQuestionsByCategory(
      widget.category,
      limit: 10,
    );

    ref.read(quizProvider.notifier).startQuiz(widget.category, questions);
  }

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(quizProvider);

    final question = quiz.currentQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuizProgress(
                currentQuestion: quiz.currentIndex + 1,
                totalQuestions: quiz.questions.length,
              ),

              const SizedBox(height: 32),

              Text(
                question.question,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    return AnswerCard(
                      index: index,
                      text: question.options[index],
                      selectedAnswer: quiz.selectedAnswer,
                      correctAnswer: question.correctAnswerIndex,
                      answered: quiz.answered,
                      onTap: () {
                        ref.read(quizProvider.notifier).answerQuestion(index);
                      },
                    );
                  },
                ),
              ),

              if (quiz.answered) _buildExplanation(context, quiz),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation(BuildContext context, QuizState quiz) {
    final question = quiz.currentQuestion!;

    final selectedAnswer = quiz.selectedAnswer;

    final isCorrect = selectedAnswer == question.correctAnswerIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? AppColors.success : AppColors.error,
            ),

            const SizedBox(width: 8),

            Text(
              isCorrect ? 'Resposta correta!' : 'Resposta incorreta',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCorrect ? AppColors.success : AppColors.error,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 20,
                    color: AppColors.secondary,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    question.bibleReference,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(question.explanation),
            ],
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            if (quiz.isLastQuestion) {
              context.go('/result');
              return;
            }

            ref.read(quizProvider.notifier).nextQuestion();
          },
          child: Text(
            quiz.isLastQuestion ? 'Ver resultado' : 'Próxima pergunta',
          ),
        ),
      ],
    );
  }
}
