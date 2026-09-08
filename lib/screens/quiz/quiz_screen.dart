import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/screens/result/result_screen.dart';
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

  const QuizScreen({super.key, required this.category});
  static const String routeName = 'quiz-screen';

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress = (quiz.currentIndex + 1) / quiz.questions.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pergunta ${quiz.currentIndex + 1} de ${quiz.questions.length}',
              ),

              const SizedBox(height: 10),

              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
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
                    return _AnswerOption(
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

              if (quiz.answered) ...[
                const SizedBox(height: 16),

                Text(
                  question.bibleReference,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(question.explanation),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if (quiz.isLastQuestion) {
                      context.goNamed(ResultScreen.routeName);
                    } else {
                      ref.read(quizProvider.notifier).nextQuestion();
                    }
                  },
                  child: Text(
                    quiz.isLastQuestion ? 'Ver resultado' : 'Próxima pergunta',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final int index;

  final String text;

  final int? selectedAnswer;

  final int correctAnswer;

  final bool answered;

  final VoidCallback onTap;

  const _AnswerOption({
    required this.index,
    required this.text,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;

    if (answered) {
      if (index == correctAnswer) {
        backgroundColor = AppColors.success.withValues(alpha: 0.15);
      } else if (index == selectedAnswer) {
        backgroundColor = AppColors.error.withValues(alpha: 0.15);
      }
    }

    return InkWell(
      onTap: answered ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              child: Text(String.fromCharCode(65 + index)),
            ),

            const SizedBox(width: 16),

            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
