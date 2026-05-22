import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_scalify/responsive_scale/scalify_provider.dart';
import 'package:fluttershop/core/service_locator.dart';
import 'package:fluttershop/core/config/app_config.dart';
import 'package:fluttershop/features/auth/data/auth_service.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authbloc.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authevent.dart';
import 'package:fluttershop/features/auth/presentation/pages/Loginpage.dart';
import 'package:fluttershop/features/product/presentation/pages/home.dart';
import 'package:fluttershop/features/location/presentation/pages/map.dart';
import 'package:fluttershop/features/onboarding/presentation/pages/onboarding.dart';
import 'package:fluttershop/features/product/presentation/pages/prouductdetails.dart';
import 'package:fluttershop/features/onboarding/presentation/pages/splash.dart';
import 'package:fluttershop/core/cubit/theme_cubit.dart';
import 'package:fluttershop/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:fluttershop/core/cubit/navigation_cubit.dart';
import 'package:fluttershop/features/product/presentation/cubit/product_cubit.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:fluttershop/features/cart/presentation/pages/credit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fluttershop/core/cubit/connectivity_cubit.dart';
import 'package:fluttershop/core/cubit/connectivity_state.dart';
import 'package:fluttershop/core/widgets/no_internet_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await initServiceLocator();

  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('\n==================================================');
  debugPrint('FCM TOKEN: $fcmToken');
  debugPrint('==================================================\n');

  final authService = AuthService(FirebaseAuth.instance);

  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: authService)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ConnectivityCubit(sl<Connectivity>()),
          ),
          BlocProvider(
            create: (context) =>
                AuthBloc(authService)..add(AuthCheckRequested()),
          ),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => CartCubit()),
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(
            create: (context) => ProductCubit(
              getProductsUseCase: sl(),
              toggleFavoriteUseCase: sl(),
            )..getProducts(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(AppConfig.oneSignalAppId);
  OneSignal.Notifications.requestPermission(false);
  OneSignal.Notifications.addClickListener((event) {
    debugPrint(
      "OneSignal Notification Clicked: ${event.notification.additionalData}",
    );
    final data = event.notification.additionalData;
    if (data != null && data.containsKey('route')) {
      final route = data['route'];
      if (route == '/map') {
        navigatorKey.currentState?.pushNamed('/map');
      }
    }
  });
}

Future<void> setup() async {
  await dotenv.load(fileName: ".env");
  MapboxOptions.setAccessToken(dotenv.env["MAPBOX_ACCESS_TOKEN"]!);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
    setupInteractedMessage();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      print("Error getting initial link: $e");
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        print("Error processing deep link: $err");
      },
    );
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey('route')) {
      final route = message.data['route'];
      if (route == '/productdetails' && message.data.containsKey('id')) {
        final id = int.tryParse(message.data['id'].toString());
        if (id != null) {
          navigatorKey.currentState?.pushNamed(
            '/productdetails',
            arguments: id,
          );
        }
      } else {
        navigatorKey.currentState?.pushNamed(route);
      }
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.path.contains('/productdetails') || uri.host == 'productdetails') {
      final params = uri.queryParameters;
      final idString = params['id'];
      if (idString != null) {
        final int? id = int.tryParse(idString);
        if (id != null) {
          navigatorKey.currentState?.pushNamed(
            '/productdetails',
            arguments: id,
          );
        }
      }
    } else if (uri.path.contains('/home') || uri.host == 'home') {
      navigatorKey.currentState?.pushNamed('/home');
    } else if (uri.path.contains('/onboarding') || uri.host == 'onboarding') {
      navigatorKey.currentState?.pushNamed('/onboarding');
    } else if (uri.path.contains('/map') || uri.host == 'map') {
      navigatorKey.currentState?.pushNamed('/map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return ScalifyProvider(
          child: MultiBlocListener(
            listeners: [
              BlocListener<ConnectivityCubit, ConnectivityState>(
                listener: (context, state) {
                  if (state is ConnectivityOnline) {
                    context.read<ProductCubit>().getProducts();
                    context.read<AuthBloc>().add(AuthCheckRequested());
                  }
                },
              ),
            ],
            child: Stack(
              textDirection: TextDirection.ltr,
              children: [
                MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode,
                  theme: ThemeData.light(),
                  darkTheme: ThemeData.dark().copyWith(
                    scaffoldBackgroundColor: const Color(0xFF121212),
                    colorScheme: const ColorScheme.dark(
                      primary: Colors.deepPurple,
                      onPrimary: Colors.white,
                      surface: Color(0xFF1E1E1E),
                      onSurface: Colors.white,
                      secondary: Color.fromARGB(255, 162, 130, 210),
                    ),
                    textTheme: ThemeData.dark().textTheme.apply(
                      bodyColor: Colors.white,
                      displayColor: Colors.white,
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  initialRoute: '/',
                  routes: {
                    '/': (context) => const SplashView(),
                    '/login': (context) => const LoginPage(),
                    '/onboarding': (context) => const Onboarding(),
                    '/home': (context) => const HomeView(),
                    '/productdetails': (context) {
                      final args = ModalRoute.of(context)!.settings.arguments;
                      if (args is Product) {
                        return ProductDetails(product: args);
                      } else if (args is int) {
                        return ProductDetails(productId: args);
                      }
                      return const Scaffold(
                        body: Center(child: Text("Product not found")),
                      );
                    },
                    '/map': (context) => MapPage(),
                    '/credit': (context) => const credit(),
                  },
                  navigatorKey: navigatorKey,
                ),
                BlocBuilder<ConnectivityCubit, ConnectivityState>(
                  builder: (context, state) {
                    if (state is ConnectivityOffline) {
                      return const Directionality(
                        textDirection: TextDirection.ltr,
                        child: NoInternetScreen(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
