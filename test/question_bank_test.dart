import 'dart:convert';

import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/models/question_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Conjunto de testes responsável por validar a integridade
/// do base de dados local de perguntas do Quiz Bíblico.
///
/// Estes testes ajudam a detectar automaticamente problemas como:
///
/// - identificadores repetidos;
/// - perguntas sem quatro alternativas;
/// - índices de resposta incorrectos;
/// - alternativas repetidas;
/// - categorias sem perguntas;
/// - níveis de dificuldade sem conteúdo.
///
/// Desta forma, novas perguntas podem ser acrescentadas ao JSON
/// com maior segurança.
void main() {
  /// Inicializa o ambiente necessário para utilizar serviços
  /// do Flutter durante os testes.
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Caminho do ficheiro JSON utilizado pela aplicação.
  const questionsAsset = 'assets/data/questions.json';

  /// Carrega todas as perguntas existentes no ficheiro JSON.
  ///
  /// O conteúdo do ficheiro é convertido primeiro para uma lista
  /// dinâmica e posteriormente para uma lista de [QuestionModel].
  Future<List<QuestionModel>> loadQuestions() async {
    /// Lê o conteúdo do ficheiro presente nos assets.
    final jsonString = await rootBundle.loadString(questionsAsset);

    /// Converte a String JSON numa lista.
    final decoded = jsonDecode(jsonString) as List<dynamic>;

    /// Converte cada objecto JSON para [QuestionModel].
    return decoded.map((item) {
      return QuestionModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  group('Base de dados de perguntas', () {
    /// Garante que o projecto possui a quantidade mínima
    /// definida para a primeira versão do banco.
    test('deve possuir pelo menos 120 perguntas', () async {
      final questions = await loadQuestions();

      expect(questions.length, greaterThanOrEqualTo(120));
    });

    /// Cada pergunta deve possuir um identificador único.
    ///
    /// Isto será especialmente importante quando utilizarmos
    /// Hive CE e histórico de respostas.
    test('não deve possuir identificadores repetidos', () async {
      final questions = await loadQuestions();

      final ids = questions.map((question) => question.id).toList();

      expect(ids.toSet().length, ids.length);
    });

    /// O formato actual do quiz utiliza exactamente
    /// quatro alternativas por pergunta.
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

    /// Verifica se [correctAnswerIndex] aponta para
    /// uma posição realmente existente.
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

    /// Impede a existência de duas alternativas iguais
    /// dentro da mesma pergunta.
    test('uma pergunta não deve repetir alternativas', () async {
      final questions = await loadQuestions();

      for (final question in questions) {
        expect(
          question.options.toSet().length,
          question.options.length,
          reason: 'A pergunta ${question.id} possui alternativas repetidas.',
        );
      }
    });

    /// Garante que cada categoria real possui conteúdo
    /// nos três níveis de dificuldade.
    test('todas as categorias devem possuir os três níveis', () async {
      final questions = await loadQuestions();

      /// A categoria Geral não precisa de perguntas próprias.
      ///
      /// Ela funciona como agregadora das restantes categorias.
      final categories = QuizCategory.values.where((category) {
        return category != QuizCategory.geral;
      });

      for (final category in categories) {
        for (final difficulty in QuizDifficulty.values) {
          /// Procura perguntas pertencentes simultaneamente
          /// à categoria e dificuldade analisadas.
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
  });
}
