import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AutoBannerSlider extends StatefulWidget {
  const AutoBannerSlider({super.key});

  @override
  State<AutoBannerSlider> createState() => _AutoBannerSliderState();
}

class _AutoBannerSliderState extends State<AutoBannerSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> banners = [];
  bool isLoading = true;

  final List<String> fallbackImages = [
    'https://img.freepik.com/free-psd/delicious-burger-food-menu-web-banner-template_120329-6365.jpg',
    'https://img.freepik.com/free-psd/delicious-burger-food-menu-web-banner-template_120329-4793.jpg',
    'https://i.pinimg.com/736x/59/36/43/593643e81c33f3eeff13906662a68022.jpg',
    'https://img.freepik.com/free-psd/food-menu-delicious-pizza-facebook-cover-banner-template_120329-4895.jpg',
  ];

  double scale(BuildContext context, double v) {
    if (Responsive.isDesktop(context)) return v * 1.2;
    if (Responsive.isTablet(context)) return v * 1.1;
    return v;
  }

  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  Future<void> loadBanners() async {
    try {
      final data = await Supabase.instance.client
          .from('banners')
          .select()
          .eq('is_active', true);

      banners = List<Map<String, dynamic>>.from(data);
    } catch (_) {}

    setState(() => isLoading = false);

    autoSlide();
  }

  List<String> get images =>
      banners.isEmpty
          ? fallbackImages
          : banners.map((e) => e['image_url'].toString()).toList();

  void autoSlide() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted || images.isEmpty) return;

      _currentPage = (_currentPage + 1) % images.length;

      _controller.animateToPage(
        _currentPage,
        duration:  Duration(milliseconds: 400),
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
    final height = Responsive.h(context);

    final bannerHeight = Responsive.isDesktop(context)
        ? 260.0
        : Responsive.isTablet(context)
            ? 220.0
            : height * 0.20;

    if (isLoading) {
      return SizedBox(
        height: bannerHeight,
        child:  Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    return SizedBox(
      height: bannerHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) {
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    images[i],
                    fit: BoxFit.cover, // 🔥 FIXED STRETCH ISSUE
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == _currentPage;

                return AnimatedContainer(
                  duration:  Duration(milliseconds: 300),
                  margin:  EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: active ? 18 : 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}