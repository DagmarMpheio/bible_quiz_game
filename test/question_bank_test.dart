import 'dart:convert';

import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/models/question_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Conjunto de testes responsável por validar a integridade
/// do banco local de perguntas do Quiz Bíblico.
///
/// Estes testes permitem detectar automaticamente problemas como:
///
/// - identificadores repetidos;
/// - perguntas sem quatro alternativas;
/// - índices de resposta inválidos;
/// - alternativas repetidas;
/// - categorias sem perguntas;
/// - níveis de dificuldade sem conteúdo.
///
/// Desta forma, novas perguntas podem ser acrescentadas ao ficheiro
/// JSON com maior segurança.
void main() {
  /// Inicializa o ambiente necessário para utilizar o [rootBundle]
  /// durante a execução dos testes.
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Caminho do ficheiro JSON utilizado pela aplicação.
  const questionsAsset = 'assets/data/questions.json';

  /// Carrega todas as perguntas existentes no ficheiro JSON.
  ///
  /// O conteúdo é convertido primeiro para uma lista dinâmica e,
  /// em seguida, para uma lista fortemente tipada de [QuestionModel].
  Future<List<QuestionModel>> loadQuestions() async {
    /// Lê o conteúdo integral do ficheiro registado nos assets.
    final jsonString = await rootBundle.loadString(questionsAsset);

    /// Converte o texto JSON numa lista dinâmica.
    final decoded = jsonDecode(jsonString) as List<dynamic>;

    /// Converte cada objecto do JSON para [QuestionModel].
    return decoded.map((item) {
      return QuestionModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  group('Banco de perguntas', () {
    /// Garante que esta versão do banco possui exactamente
    /// as 120 perguntas definidas para o MVP.
    test('deve possuir exactamente 120 perguntas', () async {
      final questions = await loadQuestions();

      expect(questions.length, 120);
    });

    /// Garante que cada pergunta possui um identificador único.
    ///
    /// Esta regra será especialmente importante quando o histórico
    /// e as estatísticas forem persistidos com Hive CE.
    test('não deve possuir identificadores repetidos', () async {
      final questions = await loadQuestions();

      final ids = questions.map((question) => question.id).toList();

      expect(ids.toSet().length, ids.length);
    });

    /// O formato actual do quiz utiliza exactamente quatro
    /// alternativas em cada pergunta.
    test('cada pergunta deve possuir quatro alternativas', () async {
      final questions = await loadQuestions();

      for (final question in questions) {
        expect(
          question.options.length,
          4,
          reason: 'A pergunta ${question.id} não possui quatro alternativas.',
        );
      }
    });

    /// Valida se [QuestionModel.correctAnswerIndex] aponta para
    /// uma posição existente na lista de alternativas.
    test('o índice da resposta correcta deve ser válido', () async {
      final questions = await loadQuestions();

      for (final question in questions) {
        expect(
          question.correctAnswerIndex,
          inInclusiveRange(0, question.options.length - 1),
          reason:
              'A pergunta ${question.id} possui um índice de resposta inválido.',
        );
      }
    });

    /// Impede que a mesma alternativa apareça mais de uma vez
    /// dentro da mesma pergunta.
    test('uma pergunta não deve possuir alternativas repetidas', () async {
      final questions = await loadQuestions();

      for (final question in questions) {
        expect(
          question.options.toSet().length,
          question.options.length,
          reason: 'A pergunta ${question.id} possui alternativas repetidas.',
        );
      }
    });

    /// Garante que todas as perguntas possuem os textos
    /// essenciais necessários para apresentação e revisão.
    test('todas as perguntas devem possuir conteúdo obrigatório', () async {
      final questions = await loadQuestions();

      for (final question in questions) {
        expect(
          question.question.trim(),
          isNotEmpty,
          reason: 'A pergunta ${question.id} não possui enunciado.',
        );

        expect(
          question.explanation.trim(),
          isNotEmpty,
          reason: 'A pergunta ${question.id} não possui explicação.',
        );

        expect(
          question.bibleReference.trim(),
          isNotEmpty,
          reason: 'A pergunta ${question.id} não possui referência bíblica.',
        );
      }
    });

    /// Garante que cada categoria real possui perguntas nos três
    /// níveis de dificuldade.
    ///
    /// [QuizCategory.geral] não é armazenada no JSON, porque funciona
    /// como agregadora das restantes categorias.
    test('todas as categorias devem possuir os três níveis', () async {
      final questions = await loadQuestions();

      final categories = QuizCategory.values.where((category) {
        return category != QuizCategory.geral;
      });

      for (final category in categories) {
        for (final difficulty in QuizDifficulty.values) {
          final filtered = questions.where((question) {
            return question.category == category &&
                question.difficulty == difficulty;
          });

          expect(
            filtered,
            isNotEmpty,
            reason: '${category.name}/${difficulty.name} não possui perguntas.',
          );
        }
      }
    });

    /// Valida a distribuição definida para esta versão:
    ///
    /// - 20 perguntas por categoria;
    /// - 7 perguntas fáceis;
    /// - 7 perguntas médias;
    /// - 6 perguntas difíceis.
    test('cada categoria deve possuir a distribuição 7/7/6', () async {
      final questions = await loadQuestions();

      final categories = QuizCategory.values.where((category) {
        return category != QuizCategory.geral;
      });

      for (final category in categories) {
        final categoryQuestions = questions
            .where((question) => question.category == category)
            .toList();

        expect(
          categoryQuestions.length,
          20,
          reason: '${category.name} deve possuir exactamente 20 perguntas.',
        );

        final easyCount = categoryQuestions
            .where((question) => question.difficulty == QuizDifficulty.facil)
            .length;

        final mediumCount = categoryQuestions
            .where((question) => question.difficulty == QuizDifficulty.medio)
            .length;

        final hardCount = categoryQuestions
            .where((question) => question.difficulty == QuizDifficulty.dificil)
            .length;

        expect(easyCount, 7);
        expect(mediumCount, 7);
        expect(hardCount, 6);
      }
    });
  });
}
