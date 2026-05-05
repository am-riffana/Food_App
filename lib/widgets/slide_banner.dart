import 'package:flutter/material.dart';

class AutoBannerSlider extends StatefulWidget {
  const AutoBannerSlider({super.key});

  @override
  State<AutoBannerSlider> createState() => _AutoBannerSliderState();
}

class _AutoBannerSliderState extends State<AutoBannerSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> images = [
    'https://img.freepik.com/free-psd/delicious-burger-food-menu-web-banner-template_120329-6365.jpg',
    'https://img.freepik.com/free-psd/delicious-burger-food-menu-web-banner-template_120329-4793.jpg',
    'https://i.pinimg.com/736x/59/36/43/593643e81c33f3eeff13906662a68022.jpg',
  ];

  @override
  void initState() {
    super.initState();
    autoSlide();
  }

  void autoSlide() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      _currentPage = (_currentPage + 1) % images.length;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: images.length,
      itemBuilder: (_, i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(images[i]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}