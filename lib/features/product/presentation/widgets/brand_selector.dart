import 'package:flutter/material.dart';

class BrandSelector extends StatelessWidget {
  final List<String> brands;
  final int selectedIndex;
  final Function(int) onBrandSelected;

  const BrandSelector({
    super.key,
    required this.brands,
    required this.selectedIndex,
    required this.onBrandSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onBrandSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.amber[200] : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                brands[index],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.black
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
