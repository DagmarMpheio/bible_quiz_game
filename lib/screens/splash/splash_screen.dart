import 'dart:async';

import 'package:bible_quiz_game/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

/// Tela de abertura apresentada quando o aplicativo é iniciado.
///
/// A Splash Screen apresenta a identidade visual do Quiz Bíblico durante alguns
/// segundos e, em seguida, encaminha automaticamente o utilizador para a Home.
///
/// Futuramente esta tela também poderá ser utilizada para verificar sessão,
/// onboarding, configurações locais ou dados necessários antes da Home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  /// Nome da rota utilizado pelo GoRouter.
  static String routeName = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// Estado interno da [SplashScreen].
class _SplashScreenState extends State<SplashScreen> {
  /// Temporizador responsável por controlar o tempo de exibição da tela.
  Timer? _timer;

  /// Executado uma única vez quando a Splash Screen é criada.
  @override
  void initState() {
    super.initState();

    /// Inicia um temporizador de três segundos.
    _timer = Timer(
      const Duration(seconds: 3),
      () {
        /// Garante que o widget ainda esteja montado antes de navegar.
        ///
        /// Esta verificação evita utilizar o [BuildContext] depois de a tela ter
        /// sido removida da árvore de widgets.
        if (!mounted) return;

        /// Substitui a Splash Screen pela Home.
        context.goNamed(HomeScreen.routeName);
      },
    );
  }

  /// Liberta recursos antes de o estado ser destruído.
  @override
  void dispose() {
    /// Cancela o temporizador caso ele ainda esteja ativo.
    _timer?.cancel();

    super.dispose();
  }

  /// Constrói a interface visual da Splash Screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Área visual que representa o logótipo provisório do app.
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 30),

              /// Nome principal da aplicação.
              const Text(
                'Quiz Bíblico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// Texto complementar apresentado durante a inicialização.
              const Text(
                'Aprenda, responda e fortaleça\nos seus conhecimentos bíblicos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 50),

              /// Indicador visual de carregamento.
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
