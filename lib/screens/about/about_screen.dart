import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Ecrã responsável por apresentar informações sobre a aplicação.
///
/// Neste ecrã, o utilizador pode consultar:
///
/// - o nome da aplicação;
/// - a versão actualmente instalada;
/// - o autor original do projecto;
/// - a informação de copyright;
/// - a licença utilizada pelo código-fonte;
/// - informações relativas ao conteúdo bíblico;
/// - as licenças das bibliotecas de terceiros utilizadas.
///
/// Este ecrã concentra as principais informações institucionais
/// e legais do Quiz Bíblico.
class AboutScreen extends StatefulWidget {
  /// Nome utilizado para identificar esta rota no GoRouter.
  static const String routeName = 'about-screen';

  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() {
    return _AboutScreenState();
  }
}

/// Estado interno do [AboutScreen].
///
/// É necessário utilizar um [StatefulWidget] porque as informações
/// da aplicação são obtidas de forma assíncrona através de
/// [PackageInfo].
class _AboutScreenState extends State<AboutScreen> {
  /// Informações obtidas directamente da aplicação instalada.
  ///
  /// O valor permanece `null` enquanto os dados estão
  /// a ser carregados.
  PackageInfo? _packageInfo;

  /// Indica se ocorreu algum erro durante o carregamento
  /// das informações da aplicação.
  bool _hasError = false;

  /// Executado uma única vez quando o ecrã é criado.
  @override
  void initState() {
    super.initState();

    /// Inicia o carregamento das informações da aplicação.
    _loadPackageInfo();
  }

  /// Obtém as informações da aplicação instalada.
  ///
  /// O [PackageInfo] permite obter automaticamente:
  ///
  /// - nome da aplicação;
  /// - versão;
  /// - número da build;
  /// - identificador do package.
  ///
  /// Desta forma, não precisamos de escrever manualmente
  /// a versão no código deste ecrã.
  Future<void> _loadPackageInfo() async {
    try {
      /// Obtém as informações fornecidas pela plataforma.
      final packageInfo = await PackageInfo.fromPlatform();

      /// A operação é assíncrona. Por isso, antes de alterar
      /// o estado, verificamos se o widget continua montado.
      if (!mounted) {
        return;
      }

      /// Guarda as informações obtidas e reconstrói o ecrã.
      setState(() {
        _packageInfo = packageInfo;
        _hasError = false;
      });
    } catch (error) {
      /// Evita actualizar um widget que já tenha sido destruído.
      if (!mounted) {
        return;
      }

      /// Regista apenas que ocorreu um erro.
      ///
      /// Não apresentamos detalhes técnicos ao utilizador.
      setState(() {
        _hasError = true;
      });
    }
  }

  /// Abre o ecrã nativo do Flutter responsável por apresentar
  /// as licenças das bibliotecas utilizadas pela aplicação.
  ///
  /// Muitas dependências Flutter registam automaticamente
  /// as respectivas licenças no sistema de licenciamento
  /// da framework.
  void _showThirdPartyLicenses() {
    showLicensePage(
      context: context,

      /// Nome apresentado no cabeçalho do ecrã de licenças.
      applicationName: AppStrings.appName,

      /// Versão real instalada da aplicação.
      applicationVersion: _packageInfo?.version ?? '',

      /// Ícone apresentado no topo do ecrã.
      applicationIcon: const Icon(
        Icons.menu_book_rounded,
        size: 64,
        color: AppColors.primary,
      ),

      /// Informação complementar apresentada juntamente
      /// com as licenças das dependências.
      applicationLegalese: AppStrings.copyright,
    );
  }

  /// Constrói o ecrã "Sobre".
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            /// Cabeçalho principal da aplicação.
            _buildHeader(context),

            const SizedBox(height: 28),

            /// Secção que apresenta a autoria do projecto.
            _buildInformationCard(
              icon: Icons.person_outline_rounded,
              title: 'Autoria',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Projecto originalmente criado e mantido por:'),

                  SizedBox(height: 8),

                  Text(
                    AppStrings.originalAuthor,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  SizedBox(height: 8),

                  Text(AppStrings.copyright),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// Secção dedicada ao licenciamento do código-fonte.
            _buildInformationCard(
              icon: Icons.gavel_outlined,
              title: 'Licença',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.licenseName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  SizedBox(height: 8),

                  Text(AppStrings.licenseNotice),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// Informação relativa às referências e traduções bíblicas.
            _buildInformationCard(
              icon: Icons.menu_book_outlined,
              title: 'Conteúdo bíblico',
              child: const Text(AppStrings.bibleCopyrightNotice),
            ),

            const SizedBox(height: 14),

            /// Permite consultar as licenças dos packages
            /// utilizados pela aplicação.
            _buildInformationCard(
              icon: Icons.description_outlined,
              title: 'Software de terceiros',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Esta aplicação utiliza bibliotecas e componentes '
                    'de terceiros sujeitos às respectivas licenças.',
                  ),

                  const SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: _showThirdPartyLicenses,
                    icon: const Icon(Icons.policy_outlined),
                    label: const Text('Ver licenças'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// Informação final apresentada no rodapé.
            const Text(
              AppStrings.copyright,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),

            const SizedBox(height: 8),

            const Text(
              AppStrings.licenseName,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o cabeçalho principal do ecrã.
  ///
  /// Apresenta:
  ///
  /// - ícone da aplicação;
  /// - nome;
  /// - versão;
  /// - número da build.
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        /// Representação provisória do logótipo.
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            size: 60,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 18),

        /// Nome da aplicação.
        Text(
          AppStrings.appName,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        /// Mostra o estado correspondente ao carregamento
        /// das informações da versão.
        if (_packageInfo != null)
          Text(
            'Versão ${_packageInfo!.version} '
            '(${_packageInfo!.buildNumber})',
            style: const TextStyle(color: AppColors.textSecondary),
          )
        else if (_hasError)
          const Text(
            'Versão indisponível',
            style: TextStyle(color: AppColors.textSecondary),
          )
        else
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  /// Constrói um card utilizado para agrupar informações
  /// dentro do ecrã "Sobre".
  ///
  /// [icon] representa visualmente o tipo de informação.
  ///
  /// [title] identifica a secção.
  ///
  /// [child] contém o conteúdo específico de cada secção.
  Widget _buildInformationCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cabeçalho da secção.
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Conteúdo específico da secção.
            child,
          ],
        ),
      ),
    );
  }
}
