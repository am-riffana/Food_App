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
          .eq('is_active', true)
          .order('created_at', ascending: false);

      setState(() {
        banners = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }

    autoSlide();
  }

  List<String> get imageList {
    if (banners.isEmpty) return fallbackImages;
    return banners.map((e) => e['image_url'].toString()).toList();
  }

  void autoSlide() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;
      if (imageList.isEmpty) continue;

      _currentPage = (_currentPage + 1) % imageList.length;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
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
    final width = Responsive.w(context);
    final height = Responsive.h(context);
    final isTablet = Responsive.isTablet(context);

    if (isLoading) {
      return SizedBox(
        height: isTablet ? 260 : height * 0.22,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    return SizedBox(
      height: isTablet ? 260 : height * 0.22,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: imageList.length,
            onPageChanged: (i) {
              setState(() {
                _currentPage = i;
              });
            },
            itemBuilder: (_, i) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    isTablet ? 22 : width * 0.04,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageList[i]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: banners.isNotEmpty &&
                        banners[i]['title'] != null
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.all(width * 0.03),
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(
                              width * 0.02,
                            ),
                          ),
                          child: Text(
                            banners[i]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet
                                  ? 18
                                  : width * 0.04,
                            ),
                          ),
                        ),
                      )
                    : null,
              );
            },
          ),

          Positioned(
            bottom: height * 0.01,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageList.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: width * 0.008,
                  ),
                  width: _currentPage == i
                      ? width * 0.05
                      : width * 0.02,
                  height: width * 0.02,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? Colors.orange
                        : Colors.white,
                    borderRadius: BorderRadius.circular(
                      width * 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}