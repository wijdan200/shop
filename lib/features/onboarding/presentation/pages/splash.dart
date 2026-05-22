import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scalify/responsive_scale/scalify_provider.dart';
import 'package:fluttershop/constants/images_constans.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authbloc.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authstate.dart';
import 'package:fluttershop/core/widgets/connectivity_wrapper.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _animationFinished = false;

  @override
  void initState() {
    super.initState();
    print("----------------->>SplashView created");

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkNavigation() {
    if (_animationFinished && mounted) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (authState is AuthUnauthenticated) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      onCheckNavigation: _checkNavigation,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Status change might trigger navigation if animation already finish
          _checkNavigation();
        },
        child: ScalifyProvider(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Lottie.asset(
                ImagesConstans.onlineShopping,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward().whenComplete(() {
                      _animationFinished = true;
                      // Navigation will be checked by ConnectivityWrapper's periodic check
                      // or we can call it here explicitly to be faster
                      _checkNavigation();
                    });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
