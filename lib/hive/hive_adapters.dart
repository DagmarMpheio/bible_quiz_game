import 'package:hive_ce/hive_ce.dart';

import '../models/quiz_history_model.dart';

/// Configuração central utilizada pelo Hive CE para gerar
/// os adapters dos modelos persistidos pela aplicação.
///
/// Sempre que um novo modelo precisar de ser guardado no Hive,
/// deverá ser acrescentado um novo [AdapterSpec] nesta lista.
///
/// O código gerado não deve ser alterado manualmente.
@GenerateAdapters([AdapterSpec<QuizHistoryModel>()])

part 'hive_adapters.g.dart';
