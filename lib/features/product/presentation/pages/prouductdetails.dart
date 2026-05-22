import 'package:flutter/material.dart';
import 'package:fluttershop/core/service_locator.dart';
import 'package:flutter_scalify/responsive_scale/scalify_provider.dart';
import 'package:fluttershop/features/product/presentation/cubit/details_cubit.dart';
import 'package:fluttershop/features/product/presentation/cubit/details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttershop/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';
import 'package:fluttershop/features/product/presentation/pages/home.dart';
import 'package:fluttershop/helper/app_logg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fluttershop/features/product/presentation/cubit/product_cubit.dart';

class ProductDetails extends StatefulWidget {
  final Product? product;
  final int? productId;

  const ProductDetails({super.key, this.product, this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  static final Product _dummyProduct = Product(
    id: 0,
    title: "Product Title Placeholder",
    price: 99.99,
    description:
        "This is a placeholder description for the skeleton loader effect. It simulates the length of a real product description.",
    category: "Category",
    image: "https://via.placeholder.com/150",
    rating: Rating(rate: 4.5, count: 100),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProductDetailsCubit(
          getProductDetailsUseCase: sl(),
          toggleFavoriteUseCase: sl(),
          initialFavorite: widget.product?.isFavorite,
        );
        if (widget.productId != null) {
          cubit.getProductDetails(widget.productId!);
        }
        return cubit;
      },
      child: ScalifyProvider(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: BlocBuilder<ProductDetailsCubit, ProductdetailsState>(
            
            builder: (context, state) {
              AppLogger.debug('Wijdan loading  details');
              if (state is ProductError) {
                return Center(child: Text(state.message));
              }

              final bool isLoading = state is ProductLoading;
              Product? displayProduct = widget.product;
              bool isFav = false;
              int selected = 38;

              if (isLoading) {
                displayProduct = _dummyProduct;
              } else if (state is ProductLoaded) {
                displayProduct = state.product;
                isFav = state.isFavorite;
                selected = state.selectedSize;
              } else if (state is ProductdetailsInitial) {
                isFav = state.isFavorite;
                selected = state.selectedSize;
              }

              if (displayProduct == null) {
                return const Center(child: Text("No product found"));
              }

              return Skeletonizer(
                enabled: isLoading,
              
                child: Column(
                  children: [
                    // AppBar area
                    Container(
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BackButton(color: Colors.black),
                          Text(
                            displayProduct.category,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              if (!isLoading) {
                                context
                                    .read<ProductDetailsCubit>()
                                    .toggleFavorite(displayProduct!);
                                
                                context.read<ProductCubit>().updateProductFavoriteStatus(
                                  displayProduct.id, 
                                  !isFav,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 250,
                      child: isLoading
                          ? Container(color: Colors.grey[300])
                          : Image.network(displayProduct.image),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Size",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),

                            // Size Selector
                            Row(
                              children: [37, 38, 39, 40, 41, 42].map((size) {
                                final isSelected = selected == size;
                                return GestureDetector(
                                  onTap: () {
                                    if (!isLoading) {
                                      context
                                          .read<ProductDetailsCubit>()
                                          .selectSize(size);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.amber[300]
                                          : Colors.grey[200],
                                    ),
                                    child: Text(
                                      "$size",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 20),
                            Text(
                              displayProduct.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (!isLoading) {
                                        context.read<CartCubit>().addToCart(
                                          displayProduct!,
                                          selected,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "${displayProduct!.title} added to cart!",
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Add To Cart",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "\$${displayProduct.price}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
