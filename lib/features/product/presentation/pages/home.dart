import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttershop/features/product/presentation/cubit/product_cubit.dart';
import 'package:fluttershop/features/product/presentation/cubit/product_state.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authbloc.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authstate.dart';
import 'package:fluttershop/core/cubit/navigation_cubit.dart';
import 'package:fluttershop/features/cart/presentation/pages/cart.dart';
import 'package:fluttershop/core/widgets/custom_drawer.dart';
import 'package:fluttershop/core/widgets/connectivity_wrapper.dart';
import 'package:fluttershop/features/product/presentation/widgets/promo_banner.dart';
import 'package:fluttershop/features/product/presentation/widgets/brand_selector.dart';
import 'package:fluttershop/features/product/presentation/widgets/product_card.dart';
import 'package:fluttershop/features/product/presentation/pages/prouductdetails.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:fluttershop/helper/name_generator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onInternetRestored() {
    if (mounted) {
      context.read<ProductCubit>().getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      onInternetRestored: _onInternetRestored,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacementNamed('/onboarding');
          }
        },
        child: BlocBuilder<NavigationCubit, int>(
          builder: (context, selectedIndex) {
            return Scaffold(
              key: _scaffoldKey,
              drawer: selectedIndex == 0 ? const CustomDrawer() : null,
              bottomNavigationBar: GNav(
                gap: 8,
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  context.read<NavigationCubit>().updateIndex(index);
                },
                tabs: const [
                  GButton(icon: Icons.home, text: "Home"),
                  GButton(icon: Icons.shopping_cart, text: "Cart"),
                ],
              ),
              appBar: selectedIndex == 0
                  ? AppBar(
                      title: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          String displayName = "Guest";
                          if (authState is AuthAuthenticated) {
                            displayName = NameGenerator.getDisplayName(authState.user);
                          } else {
                            displayName = NameGenerator.getDisplayName(null);
                          }
                          return Text(
                            "Hi, $displayName",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: const [
                        SizedBox(width: 10),
                        Icon(Icons.notifications_outlined, color: Colors.black),
                        SizedBox(width: 10),
                      ],
                    )
                  : null,
              body: selectedIndex == 0
                  ? BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                        final isLoading = state is ProductLoading;
                        final products = state is ProductLoaded ? state.products : [];
                        final selectedBrandIndex =
                            state is ProductLoaded ? state.selectedBrandIndex : 0;
                        final brands = [
                          "ALL", "Nike", "Adidas", "Puma", "Reebok", "Skechers", "New Balance"
                        ];

                        return Skeletonizer(
                          enabled: isLoading,
                          child: LiquidPullToRefresh(
                            onRefresh: () async {
                              await context.read<ProductCubit>().getProducts();
                            },
                            showChildOpacityTransition: false,
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        const PromoBanner(),
                                        const SizedBox(height: 20),
                                        BrandSelector(
                                          brands: brands,
                                          selectedIndex: selectedBrandIndex,
                                          onBrandSelected: (index) => context
                                              .read<ProductCubit>()
                                              .changeBrand(index),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 0.7,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final product = products[index];
                                        return ProductCard(
                                          product: product,
                                          isLoading: isLoading,
                                          onTap: () {
                                            if (!isLoading) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ProductDetails(
                                                    product: product,
                                                  ),
                                                ),
                                              ).then((_) {
                                                if (context.mounted) {
                                                  context.read<ProductCubit>().getProducts();
                                                }
                                              });
                                            }
                                          },
                                        );
                                      },
                                      childCount: products.length,
                                    ),
                                  ),
                                ),
                                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const CartPage(),
            );
          },
        ),
      ),
    );
  }
}
