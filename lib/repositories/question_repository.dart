import 'package:bible_quiz_game/models/category_model.dart';
import 'package:bible_quiz_game/models/difficulty_model.dart';
import 'package:bible_quiz_game/models/question_model.dart';

/// Define o contrato responsável pelo acesso às perguntas do quiz.
///
/// A aplicação não precisa de saber se as perguntas vêm de memória,
/// Hive CE, Firebase ou de uma API. Essa responsabilidade pertence
/// às implementações deste repositório.
abstract class QuestionRepository {
  /// Retorna as perguntas disponíveis para uma determinada categoria
  /// e nível de dificuldade.
  ///
  /// [category] representa a categoria escolhida pelo utilizador.
  ///
  /// [difficulty] representa o nível de dificuldade seleccionado.
  ///
  /// [limit] determina a quantidade máxima de perguntas devolvidas.
  List<QuestionModel> getQuestions({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    int limit = 10,
  });

  /// Retorna os níveis de dificuldade que possuem pelo menos uma
  /// pergunta disponível para determinada categoria.
  ///
  /// Este método permite desactivar níveis ainda sem perguntas.
  List<QuizDifficulty> getAvailableDifficulties(QuizCategory category);
}

/// Implementação local de [QuestionRepository].
///
/// Nesta primeira versão, todas as perguntas ficam armazenadas em memória numa
/// lista constante. Esta implementação é adequada para o MVP e poderá ser
/// substituída posteriormente por uma base persistente.
class LocalQuestionRepository implements QuestionRepository {
  /// Base local de perguntas utilizadas no quiz.
  final List<QuestionModel> _questions = const [
    QuestionModel(
      id: '1',
      question: 'Quem construiu a arca?',
      options: ['Abraão', 'Moisés', 'Noé', 'Davi'],
      correctAnswerIndex: 2,
      category: QuizCategory.antigoTestamento,
      difficulty: QuizDifficulty.facil,
      explanation:
          'Deus ordenou a Noé que construísse uma arca para sobreviver ao dilúvio.',
      bibleReference: 'Génesis 6:14',
    ),

    QuestionModel(
      id: '2',
      question: 'Quem derrotou Golias?',
      options: ['Saul', 'Davi', 'Samuel', 'Salomão'],
      correctAnswerIndex: 1,
      category: QuizCategory.personagens,
      difficulty: QuizDifficulty.facil,
      explanation: 'Davi derrotou Golias utilizando uma funda e uma pedra.',
      bibleReference: '1 Samuel 17:49-50',
    ),

    QuestionModel(
      id: '3',
      question: 'Quem recebeu os Dez Mandamentos?',
      options: ['Moisés', 'Abraão', 'Josué', 'Elias'],
      correctAnswerIndex: 0,
      category: QuizCategory.antigoTestamento,
      difficulty: QuizDifficulty.facil,
      explanation: 'Moisés recebeu os mandamentos de Deus no monte Sinai.',
      bibleReference: 'Êxodo 31:18',
    ),

    QuestionModel(
      id: '4',
      question: 'Em que cidade nasceu Jesus?',
      options: ['Jerusalém', 'Nazaré', 'Belém', 'Cafarnaum'],
      correctAnswerIndex: 2,
      category: QuizCategory.jesusCristo,
      difficulty: QuizDifficulty.facil,
      explanation: 'Jesus nasceu em Belém da Judeia.',
      bibleReference: 'Mateus 2:1',
    ),

    QuestionModel(
      id: '5',
      question: 'Quantos apóstolos Jesus escolheu?',
      options: ['7', '10', '12', '14'],
      correctAnswerIndex: 2,
      category: QuizCategory.novoTestamento,
      difficulty: QuizDifficulty.facil,
      explanation: 'Jesus escolheu doze discípulos para serem seus apóstolos.',
      bibleReference: 'Lucas 6:13',
    ),

    QuestionModel(
      id: '6',
      question: 'Quem traiu Jesus?',
      options: ['Pedro', 'João', 'Tomé', 'Judas Iscariotes'],
      correctAnswerIndex: 3,
      category: QuizCategory.jesusCristo,
      difficulty: QuizDifficulty.medio,
      explanation: 'Judas Iscariotes entregou Jesus às autoridades.',
      bibleReference: 'Mateus 26:14-16',
    ),

    QuestionModel(
      id: '7',
      question: 'Quem foi lançado na cova dos leões?',
      options: ['Daniel', 'Elias', 'Isaías', 'Jeremias'],
      correctAnswerIndex: 0,
      category: QuizCategory.personagens,
      difficulty: QuizDifficulty.medio,
      explanation:
          'Daniel foi lançado na cova dos leões por continuar orando a Deus.',
      bibleReference: 'Daniel 6:16',
    ),

    QuestionModel(
      id: '8',
      question: 'Quem foi o primeiro rei de Israel?',
      options: ['Davi', 'Saul', 'Salomão', 'Samuel'],
      correctAnswerIndex: 1,
      category: QuizCategory.reisEProfetas,
      difficulty: QuizDifficulty.medio,
      explanation: 'Saul foi escolhido como o primeiro rei de Israel.',
      bibleReference: '1 Samuel 10:1',
    ),

    QuestionModel(
      id: '9',
      question: 'Qual é o primeiro livro da Bíblia?',
      options: ['Êxodo', 'Salmos', 'Génesis', 'Mateus'],
      correctAnswerIndex: 2,
      category: QuizCategory.livrosDaBiblia,
      difficulty: QuizDifficulty.facil,
      explanation: 'Génesis é o primeiro livro do Antigo Testamento.',
      bibleReference: 'Génesis 1:1',
    ),

    QuestionModel(
      id: '10',
      question: 'Quem construiu o templo em Jerusalém?',
      options: ['Davi', 'Salomão', 'Saul', 'Josué'],
      correctAnswerIndex: 1,
      category: QuizCategory.reisEProfetas,
      difficulty: QuizDifficulty.dificil,
      explanation: 'O rei Salomão construiu o primeiro templo em Jerusalém.',
      bibleReference: '1 Reis 6:1',
    ),
  ];

  /// Retorna uma lista de perguntas filtradas por categoria.
  ///
  /// Se [category] for [QuizCategory.geral], todas as perguntas ficam elegíveis.
  /// Para qualquer outra categoria, apenas perguntas pertencentes à categoria
  /// escolhida são devolvidas.
  ///
  /// Antes do retorno, a lista é embaralhada para variar a sequência das
  /// perguntas entre diferentes tentativas.
  List<QuestionModel> getQuestionsByCategory(
    QuizCategory category, {
    int limit = 10,
  }) {
    /// Lista que armazenará as perguntas elegíveis para o quiz actual.
    List<QuestionModel> questions;

    if (category == QuizCategory.geral) {
      /// Cria uma cópia da lista original para permitir o `shuffle()` sem
      /// modificar a base interna de perguntas.
      questions = List<QuestionModel>.from(_questions);
    } else {
      /// Mantém apenas as perguntas cuja categoria corresponde à selecionada.
      questions = _questions
          .where((question) => question.category == category)
          .toList();
    }

    /// Altera aleatoriamente a ordem das perguntas.
    questions.shuffle();

    /// Se existirem mais perguntas que o limite solicitado, devolve apenas a
    /// quantidade definida em [limit].
    if (questions.length > limit) {
      return questions.take(limit).toList();
    }

    /// Quando a quantidade disponível é menor ou igual ao limite, retorna todas.
    return questions;
  }

  /// Retorna perguntas filtradas pela categoria e dificuldade escolhidas.
  @override
  List<QuestionModel> getQuestions({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    int limit = 10,
  }) {
    /// Filtra inicialmente as perguntas pela dificuldade seleccionada.
    var questions = _questions.where((question) {
      /// Na categoria Geral, qualquer categoria bíblica é aceite.
      ///
      /// Nas restantes categorias, a pergunta tem obrigatoriamente
      /// de pertencer à categoria seleccionada.
      final matchesCategory =
          category == QuizCategory.geral || question.category == category;

      /// A dificuldade da pergunta deve corresponder exactamente
      /// ao nível escolhido pelo utilizador.
      final matchesDifficulty = question.difficulty == difficulty;

      return matchesCategory && matchesDifficulty;
    }).toList();

    /// Embaralha as perguntas para evitar que sejam apresentadas
    /// sempre pela mesma ordem.
    questions.shuffle();

    /// Limita a quantidade de perguntas devolvidas.
    if (questions.length > limit) {
      return questions.take(limit).toList();
    }

    return questions;
  }

  /// Retorna apenas os níveis que possuem perguntas disponíveis
  /// para determinada categoria.
  @override
  List<QuizDifficulty> getAvailableDifficulties(QuizCategory category) {
    return QuizDifficulty.values.where((difficulty) {
      /// Procura pelo menos uma pergunta que corresponda à categoria
      /// e ao nível de dificuldade actualmente analisado.
      return _questions.any((question) {
        final matchesCategory =
            category == QuizCategory.geral || question.category == category;

        final matchesDifficulty = question.difficulty == difficulty;

        return matchesCategory && matchesDifficulty;
      });
    }).toList();
  }
}
