import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/quiz_provider.dart';

/// Tela responsável por apresentar a revisão completa do quiz.
///
/// Nesta tela o utilizador consegue consultar:
/// - cada pergunta respondida;
/// - a resposta escolhida;
/// - a resposta correta;
/// - se acertou ou errou;
/// - a explicação da pergunta;
/// - a referência bíblica.
///
/// Os dados apresentados são obtidos através do histórico armazenado
/// no [quizProvider].
class ReviewAnswersScreen extends ConsumerWidget {
  /// Nome utilizado para identificar esta rota no GoRouter.
  static const String routeName = 'review-answers-screen';

  const ReviewAnswersScreen({super.key});

  /// Constrói a interface da tela de revisão.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Obtém o estado atual do quiz.
    final quiz = ref.watch(quizProvider);

    /// Recupera o histórico completo das respostas.
    final answers = quiz.answerHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('Rever respostas')),

      /// Se não existirem respostas, apresenta uma mensagem informativa.
      ///
      /// Embora normalmente esta tela só seja acessada depois de concluir
      /// um quiz, esta validação deixa a interface mais segura.
      body: answers.isEmpty
          ? const Center(child: Text('Ainda não existem respostas para rever.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),

              /// Cada resposta armazenada gera um card.
              itemCount: answers.length,

              /// Espaçamento entre os cards.
              separatorBuilder: (_, _) {
                return const SizedBox(height: 14);
              },

              itemBuilder: (context, index) {
                /// Obtém a resposta correspondente à posição atual.
                final answer = answers[index];

                /// Obtém a pergunta associada à resposta.
                final question = answer.question;

                /// Determina a cor utilizada no indicador de estado.
                final statusColor = answer.isCorrect
                    ? AppColors.success
                    : AppColors.error;

                return Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    /// Ícone que mostra visualmente se a resposta
                    /// foi correta ou incorreta.
                    leading: CircleAvatar(
                      backgroundColor: statusColor.withValues(alpha: 0.12),
                      child: Icon(
                        answer.isCorrect
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        color: statusColor,
                      ),
                    ),

                    /// Mostra o número e o enunciado da pergunta.
                    title: Text(
                      '${index + 1}. ${question.question}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    /// Pequeno resumo apresentado antes de expandir o card.
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        answer.isCorrect
                            ? 'Resposta correta'
                            : 'Resposta incorreta',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    /// Conteúdo detalhado apresentado quando o utilizador
                    /// expande o card.
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),

                            const SizedBox(height: 12),

                            /// Resposta escolhida pelo utilizador.
                            const Text(
                              'A tua resposta:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              answer.selectedAnswer,
                              style: TextStyle(
                                color: answer.isCorrect
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),

                            const SizedBox(height: 18),

                            /// Se o utilizador errou, mostramos explicitamente
                            /// qual era a alternativa correta.
                            if (!answer.isCorrect) ...[
                              const Text(
                                'Resposta correta:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                answer.correctAnswer,
                                style: const TextStyle(
                                  color: AppColors.success,
                                ),
                              ),

                              const SizedBox(height: 18),
                            ],

                            /// Referência bíblica utilizada para fundamentar
                            /// a resposta da pergunta.
                            Row(
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  size: 20,
                                  color: AppColors.secondary,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    question.bibleReference,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// Explicação complementar da resposta.
                            Text(
                              question.explanation,
                              style: const TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
