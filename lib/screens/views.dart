/// Ficheiro central de exportação dos ecrãs da aplicação.
///
/// Este ficheiro funciona como um "barrel file", permitindo importar
/// vários ecrãs através de um único ficheiro.
///
/// Em vez de:
///
/// ```dart
/// import 'screens/home/home_screen.dart';
/// import 'screens/quiz/quiz_screen.dart';
/// import 'screens/result/result_screen.dart';
/// ```
///
/// Pode ser utilizado apenas:
///
/// ```dart
/// import 'screens/views.dart';
/// ```
library;

export 'splash/splash_screen.dart';
export 'home/home_screen.dart';
export 'quiz/quiz_screen.dart';
export 'categories/categories_screen.dart';
export 'result/result_screen.dart';
export 'review/review_answers_screen.dart';
