import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/widgets/answer_card.dart';
import 'package:bible_quiz_game/widgets/quiz_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/quiz_provider.dart';

/// Tela responsável pela execução de uma sessão do Quiz Bíblico.
///
/// Esta tela:
/// - carrega as perguntas da categoria selecionada;
/// - observa o estado mantido pelo Riverpod;
/// - apresenta a pergunta e as alternativas;
/// - mostra feedback após cada resposta;
/// - permite avançar até ao resultado final.
class QuizScreen extends ConsumerStatefulWidget {
  /// Categoria escolhida pelo utilizador antes de iniciar o quiz.
  final QuizCategory category;

  /// Nível de dificuldade seleccionado.
  final QuizDifficulty difficulty;

  /// Nome da rota utilizado pelo GoRouter.
  static const String routeName = 'quiz-screen';

  const QuizScreen({
    super.key,
    required this.category,
    required this.difficulty,
  });

  /// Cria o estado responsável pela lógica da tela.
  @override
  ConsumerState<QuizScreen> createState() {
    return _QuizScreenState();
  }
}

/// Estado interno da [QuizScreen].
///
/// Como a tela utiliza [ConsumerState], possui acesso direto ao objeto `ref`
/// necessário para ler e observar providers do Riverpod.
class _QuizScreenState extends ConsumerState<QuizScreen> {
  /// Executado uma única vez quando a tela entra na árvore de widgets.
  @override
  void initState() {
    super.initState();

    /// Agenda o carregamento das perguntas para depois do primeiro frame.
    ///
    /// Isso evita modificar o estado do provider durante a fase inicial de
    /// construção da interface.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestions();
    });
  }

  /// Carrega as perguntas correspondentes à categoria e
  /// dificuldade seleccionadas.
  void _loadQuestions() {
    /// Obtém o repositório através do Riverpod.
    final repository = ref.read(questionRepositoryProvider);

    /// Solicita as perguntas adequadas à sessão actual.
    final questions = repository.getQuestions(
      category: widget.category,
      difficulty: widget.difficulty,
      limit: 10,
    );

    /// Inicia o quiz com os filtros seleccionados.
    ref
        .read(quizProvider.notifier)
        .startQuiz(widget.category, widget.difficulty, questions);
  }

  /// Constrói a interface principal do quiz.
  @override
  Widget build(BuildContext context) {
    /// Observa o estado. Sempre que ele for alterado, a tela é reconstruída.
    final quiz = ref.watch(quizProvider);

    /// Obtém a pergunta actualmente selecionada pelo estado.
    final question = quiz.currentQuestion;

    /// Enquanto não existir uma pergunta disponível, mostra carregamento.
    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.category.title} • ${widget.difficulty.title}'),
        ),
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
              /// Indica visualmente a posição actual dentro do quiz.
              QuizProgress(
                currentQuestion: quiz.currentIndex + 1,
                totalQuestions: quiz.questions.length,
              ),

              const SizedBox(height: 32),

              /// Enunciado da pergunta actual.
              Text(
                question.question,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// Área expansível que contém todas as alternativas.
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, _) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    return AnswerCard(
                      /// Índice da alternativa. Também é usado para gerar
                      /// automaticamente as letras A, B, C e D.
                      index: index,

                      /// Texto da alternativa actual.
                      text: question.options[index],

                      /// Alternativa escolhida pelo utilizador.
                      selectedAnswer: quiz.selectedAnswer,

                      /// Índice utilizado pelo widget para destacar a resposta
                      /// correta após a seleção.
                      correctAnswer: question.correctAnswerIndex,

                      /// Informa se a pergunta já foi respondida.
                      answered: quiz.answered,

                      /// Regista a alternativa escolhida no estado global.
                      onTap: () {
                        ref.read(quizProvider.notifier).answerQuestion(index);
                      },
                    );
                  },
                ),
              ),

              /// O feedback só aparece depois de uma resposta ser selecionada.
              if (quiz.answered) _buildExplanation(context, quiz),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói a área de feedback exibida depois da resposta.
  ///
  /// O método apresenta:
  /// - se a resposta foi correta ou incorreta;
  /// - a referência bíblica;
  /// - uma pequena explicação;
  /// - o botão para avançar ou ver o resultado.
  Widget _buildExplanation(BuildContext context, QuizState quiz) {
    /// Nesta fase a pergunta é garantidamente não nula porque este método só é
    /// chamado depois da construção da pergunta actual.
    final question = quiz.currentQuestion!;

    /// Índice selecionado pelo utilizador.
    final selectedAnswer = quiz.selectedAnswer;

    /// Compara a resposta escolhida com a resposta correta.
    final isCorrect = selectedAnswer == question.correctAnswerIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        /// Feedback textual e visual da resposta.
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

        /// Caixa com a referência bíblica e a explicação da resposta.
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
              /// Linha da referência bíblica.
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

              /// Explicação complementar da resposta.
              Text(question.explanation),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// Botão que avança para a pergunta seguinte ou finaliza o quiz.
        ElevatedButton(
          onPressed: () {
            if (quiz.isLastQuestion) {
              /// Ao responder a última pergunta, abre a tela de resultado.
              context.go('/result');
              return;
            }

            /// Caso contrário, actualiza o estado para a próxima pergunta.
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
