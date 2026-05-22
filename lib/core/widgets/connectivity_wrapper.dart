import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttershop/core/cubit/connectivity_cubit.dart';
import 'package:fluttershop/core/cubit/connectivity_state.dart';
import 'package:fluttershop/core/widgets/no_internet_screen.dart';
import 'package:fluttershop/helper/app_logg.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onInternetRestored;
  final VoidCallback? onCheckNavigation;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.onInternetRestored,
    this.onCheckNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityCubit, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityOnline) {
          AppLogger.debug('Internet Connection Restored');
          onInternetRestored?.call();
          onCheckNavigation?.call();
        }
      },
      builder: (context, state) {
        if (state is ConnectivityOffline) {
          AppLogger.debug('No Internet Connection - Showing UI');
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: NoInternetScreen(),
            ),
          );
        }
        return child;
      },
    );
  }
}
