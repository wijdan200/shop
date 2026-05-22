import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttershop/constants/images_constans.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:fluttershop/features/product/presentation/cubit/product_cubit.dart';
import 'package:fluttershop/features/product/presentation/cubit/product_state.dart';
import 'package:fluttershop/features/product/presentation/pages/prouductdetails.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fluttershop/helper/app_logg.dart';

import 'package:fluttershop/core/service_locator.dart';

class Favorit extends StatefulWidget {
  const Favorit({super.key});

  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorites',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),

        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {

            if (state is ProductLoading) {
                          AppLogger.debug('Wijdan loading  favorites');

              return Skeletonizer(
                enabled: true,
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 100,
                      child: Lottie.asset(
                        ImagesConstans.onlineShopping,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:GridView.builder(padding: const EdgeInsets.all(16),
                       gridDelegate: 
                       const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.75,
                         crossAxisSpacing: 16, mainAxisSpacing: 16), 
                         itemBuilder: (context, index) {
                  
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 16,
                                        width: 100,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 16,
                                            width: 50,
                                            color: Colors.grey,
                                          ),
                                          const Icon(Icons.favorite, size: 20),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProductError) {
              AppLogger.debug('Wijdan error favorites');
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProductLoaded) {
              AppLogger.debug('Wijdan loading  succes favorites');
              final favorites = state.products
                  .where((p) => p.isFavorite)
                  .toList();

              return Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 100,
                    child: Lottie.asset(
                      ImagesConstans.onlineShopping,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LiquidPullToRefresh(
                      onRefresh: () async {
                        await context.read<ProductCubit>().getProducts();
                      },
                      showChildOpacityTransition: false,
                      child: favorites.isEmpty
                          ? const Center(
                              child: Text(
                                'No favorites yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: favorites.length,
                              itemBuilder: (context, index) {
                                final product = favorites[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetails(product: product),
                                      ),
                                    ).then((_) {
                                      // Refresh when returning to update favorites if changed
                                      context.read<ProductCubit>().getProducts();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(16),
                                                ),
                                            child: Image.network(
                                              product.image,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '\$${product.price}',
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
      ),
    );
  }
}
