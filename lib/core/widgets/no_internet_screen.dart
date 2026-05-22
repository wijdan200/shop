import 'package:flutter/material.dart';
import 'package:fluttershop/constants/images_constans.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text(
              "Oops !! \nNo Internet Connection ",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
             const SizedBox(height: 24),

            Image.asset(
              ImagesConstans.noInternetJpg,
              width: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: Colors.grey,
              ),
            ),
            // const SizedBox(height: 24),
          
            // const SizedBox(height: 12),
            // Text(
            //   "Please check your network settings\nand try again.",
            //   textAlign: TextAlign.center,
            //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //         color: Colors.grey,
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}
