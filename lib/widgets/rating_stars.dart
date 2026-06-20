import 'package:ewire_ecommerce/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: AppColors.ratingStar, size: size);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: AppColors.ratingStar, size: size);
        }

        return Icon(Icons.star_border, color: AppColors.ratingStar, size: size);
      }),
    );
  }
}
