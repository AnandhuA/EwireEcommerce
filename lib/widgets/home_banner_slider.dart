import 'package:carousel_slider/carousel_slider.dart';
import 'package:ewire_ecommerce/core/constants/app_assets.dart';
import 'package:ewire_ecommerce/core/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  int currentIndex = 0;

  final banners = [
    AppAssets.bannerImage1,
    AppAssets.bannerImage2,
    AppAssets.bannerImage3,
    AppAssets.bannerImage4,
    AppAssets.bannerImage5,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (_, index, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                banners[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
          options: CarouselOptions(
            height: context.res.h(0.2),
            viewportFraction: 1,
            autoPlay: true,
            enlargeFactor: 0.4,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 12),

        AnimatedSmoothIndicator(
          activeIndex: currentIndex,
          count: banners.length,
          effect: const WormEffect(dotHeight: 8, dotWidth: 8),
        ),
      ],
    );
  }
}
