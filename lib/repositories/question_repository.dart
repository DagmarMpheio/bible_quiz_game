import 'dart:convert';

import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/models/question_model.dart';
import 'package:flutter/services.dart';

/// Define o contrato responsável pelo acesso às perguntas.
///
/// Como a origem dos dados pode necessitar de leitura de ficheiros,
/// base de dados ou Internet, os métodos são assíncronos.
abstract class QuestionRepository {
  /// Obtém perguntas filtradas por categoria e dificuldade.
  ///
  /// [limit] define o número máximo de perguntas devolvidas.
  Future<List<QuestionModel>> getQuestions({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    int limit = 10,
  });

  /// Obtém os níveis de dificuldade disponíveis para uma categoria.
  ///
  /// Apenas são devolvidos níveis que possuam pelo menos uma
  /// pergunta disponível.
  Future<List<QuizDifficulty>> getAvailableDifficulties(QuizCategory category);
}

/// Implementação local do repositório de perguntas.
///
/// As perguntas são carregadas a partir do ficheiro:
///
/// `assets/data/questions.json`
///
/// Depois da primeira leitura, os dados ficam guardados em memória
/// para evitar abrir e processar novamente o ficheiro em cada quiz.
class LocalQuestionRepository implements QuestionRepository {
  /// Caminho para o ficheiro que contém as perguntas.
  static const String _questionsAsset = 'assets/data/questions.json';

  /// Cache das perguntas carregadas.
  ///
  /// É `null` enquanto o ficheiro ainda não tiver sido lido.
  List<QuestionModel>? _cachedQuestions;

  /// Carrega todas as perguntas do ficheiro JSON.
  ///
  /// Se as perguntas já estiverem em cache, devolve imediatamente
  /// os dados existentes sem voltar a ler o ficheiro.
  Future<List<QuestionModel>> _loadQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    /// Lê o conteúdo integral do ficheiro registado nos assets.
    final jsonString = await rootBundle.loadString(_questionsAsset);

    /// Converte o texto JSON numa lista dinâmica.
    final decoded = jsonDecode(jsonString) as List<dynamic>;

    /// Converte cada elemento JSON para [QuestionModel].
    final questions = decoded.map((item) {
      final json = Map<String, dynamic>.from(item as Map);

      return QuestionModel.fromJson(json);
    }).toList();

    /// Guarda as perguntas em memória para utilizações seguintes.
    _cachedQuestions = questions;

    return questions;
  }

  /// Obtém perguntas correspondentes aos filtros seleccionados.
  @override
  Future<List<QuestionModel>> getQuestions({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    int limit = 10,
  }) async {
    /// Carrega a base completa de perguntas.
    final allQuestions = await _loadQuestions();

    /// Filtra a lista pela categoria e dificuldade.
    final questions = allQuestions.where((question) {
      /// A categoria Geral aceita perguntas de qualquer categoria.
      final matchesCategory =
          category == QuizCategory.geral || question.category == category;

      /// A dificuldade deve corresponder exactamente
      /// ao nível escolhido.
      final matchesDifficulty = question.difficulty == difficulty;

      return matchesCategory && matchesDifficulty;
    }).toList();

    /// Embaralha as perguntas para evitar uma ordem fixa.
    questions.shuffle();

    /// Limita a quantidade de perguntas devolvidas.
    if (questions.length > limit) {
      return questions.take(limit).toList();
    }

    return questions;
  }

  /// Obtém as dificuldades que possuem perguntas disponíveis
  /// para determinada categoria.
  @override
  Future<List<QuizDifficulty>> getAvailableDifficulties(
    QuizCategory category,
  ) async {
    /// Carrega a base completa.
    final questions = await _loadQuestions();

    /// Percorre todos os níveis disponíveis.
    return QuizDifficulty.values.where((difficulty) {
      /// O nível só fica disponível se existir pelo menos
      /// uma pergunta que corresponda aos filtros.
      return questions.any((question) {
        final matchesCategory =
            category == QuizCategory.geral || question.category == category;

        return matchesCategory && question.difficulty == difficulty;
      });
    }).toList();
  }
}
