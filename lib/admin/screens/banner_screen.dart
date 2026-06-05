import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BannersPage extends StatefulWidget {
  const BannersPage({super.key});

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends State<BannersPage> {
  final _supabase = Supabase.instance.client;
  List banners = [];
  bool isLoading = true;

  static const List<Map<String, String>> _defaultBanners = [
    {
      'image_url':
          'https://img.freepik.com/free-psd/delicious-burger-food-menu-web-banner-template_120329-6365.jpg',
      'title': 'Delicious Burgers',
    },
    {
      'image_url':
          'https://img.freepik.com/free-psd/delicious-burger-food-menu-web-banner-template_120329-4793.jpg',
      'title': 'Best Burger Deals',
    },
    {
      'image_url':
          'https://i.pinimg.com/736x/59/36/43/593643e81c33f3eeff13906662a68022.jpg',
      'title': 'Special Offers',
    },
    {
      'image_url':
          'https://img.freepik.com/free-psd/food-menu-delicious-pizza-facebook-cover-banner-template_120329-4895.jpg',
      'title': 'Pizza Time',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  Future<void> loadBanners() async {
    setState(() => isLoading = true);
    try {
      final data = await _supabase
          .from('banners')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        banners = data;
        isLoading = false;
      });

      if ((data as List).isEmpty) {
        await seedDefaultBanners();
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Load banners error: $e');
    }
  }

  Future<void> seedDefaultBanners() async {
    try {
      for (final b in _defaultBanners) {
        await _supabase.from('banners').insert({
          'image_url': b['image_url'],
          'title': b['title'],
          'is_active': true,
        });
      }
      loadBanners();
    } catch (e) {
      debugPrint('Seed banners error: $e');
    }
  }

  void showBannerDialog({Map? banner}) {
    final urlCtrl =
        TextEditingController(text: banner?['image_url']);
    final titleCtrl =
        TextEditingController(text: banner?['title']);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final bool isTablet = Responsive.isTablet(context);
        final double hPad =
            isTablet ? 32.0 : Responsive.w(context) * 0.05;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: hPad,
                right: hPad,
                top: 20,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                     SizedBox(height: 18),

                    Text(
                      banner == null ? "Add Banner" : "Edit Banner",
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     SizedBox(height: 20),

                    ValueListenableBuilder(
                      valueListenable: urlCtrl,
                      builder: (_, __, ___) {
                        if (urlCtrl.text.isNotEmpty) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(16),
                                child: Image.network(
                                  urlCtrl.text,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(
                                    height: 160,
                                    color: Colors.orange.shade50,
                                    child:  Icon(
                                        Icons.broken_image,
                                        color: Colors.orange,
                                        size: 48),
                                  ),
                                ),
                              ),
                               SizedBox(height: 14),
                            ],
                          );
                        }
                        return  SizedBox.shrink();
                      },
                    ),

                    TextField(
                      controller: urlCtrl,
                      decoration: InputDecoration(
                        prefixIcon:  Icon(Icons.image,
                            color: Colors.orange),
                        hintText: "Image URL",
                        filled: true,
                        fillColor: Colors.orange.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                     SizedBox(height: 14),
                    TextField(
                      controller: titleCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon:  Icon(Icons.title,
                            color: Colors.orange),
                        hintText: "Title (optional)",
                        filled: true,
                        fillColor: Colors.orange.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                     SizedBox(height: 20),

                    if (banner == null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Quick Pick",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 16 : 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                       SizedBox(height: 10),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _defaultBanners.length,
                          itemBuilder: (_, i) {
                            final def = _defaultBanners[i];
                            return GestureDetector(
                              onTap: () {
                                urlCtrl.text =
                                    def['image_url']!;
                                titleCtrl.text =
                                    def['title']!;
                                setSheetState(() {});
                              },
                              child: Container(
                                margin:  EdgeInsets.only(
                                    right: 10),
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange
                                        .withOpacity(0.4),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  child: Image.network(
                                    def['image_url']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(
                                      color: Colors.orange.shade50,
                                      child:  Icon(
                                          Icons.image,
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                       SizedBox(height: 20),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (urlCtrl.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                     SnackBar(
                                      content:
                                          Text("Enter image URL"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setSheetState(
                                    () => isSaving = true);

                                try {
                                  if (banner == null) {
                                    await _supabase
                                        .from('banners')
                                        .insert({
                                      'image_url':
                                          urlCtrl.text.trim(),
                                      'title':
                                          titleCtrl.text.trim(),
                                      'is_active': true,
                                    });
                                  } else {
                                    await _supabase
                                        .from('banners')
                                        .update({
                                      'image_url':
                                          urlCtrl.text.trim(),
                                      'title':
                                          titleCtrl.text.trim(),
                                    }).eq('id', banner['id']);
                                  }

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          banner == null
                                              ? "Banner added!"
                                              : "Banner updated!",
                                        ),
                                        backgroundColor:
                                            Colors.green,
                                      ),
                                    );
                                  }
                                  loadBanners();
                                } catch (e) {
                                  setSheetState(
                                      () => isSaving = false);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Error: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        child: isSaving
                            ?  CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                banner == null
                                    ? "Add Banner"
                                    : "Update Banner",
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> toggleActive(String id, bool current) async {
    await _supabase
        .from('banners')
        .update({'is_active': !current}).eq('id', id);
    loadBanners();
  }

  Future<void> deleteBanner(Map banner) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title:  Text("Delete Banner"),
        content:  Text(
            "Are you sure you want to delete this banner?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child:  Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _supabase
          .from('banners')
          .delete()
          .eq('id', banner['id']);
      loadBanners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final double screenWidth = Responsive.w(context);

    final double hPad = isDesktop
        ? screenWidth * 0.06
        : isTablet
            ? screenWidth * 0.04
            : screenWidth * 0.04;

    final int crossAxis = isDesktop
        ? 3
        : isTablet
            ? 2
            : 1;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Manage Banners",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet || isDesktop ? 22 : 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadBanners,
            icon: Icon(Icons.refresh,
                color: Colors.orange,
                size: isTablet || isDesktop ? 28 : 24),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () => showBannerDialog(),
        icon:  Icon(Icons.add, color: Colors.white),
        label:  Text(
          "Add Banner",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ?  Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : banners.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined,
                          size: isTablet || isDesktop ? 100 : 80,
                          color: Colors.grey.shade300),
                       SizedBox(height: 16),
                      Text(
                        "No banners added yet",
                        style: TextStyle(
                          fontSize: isTablet || isDesktop ? 20 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadBanners,
                  color: Colors.orange,
                  child: crossAxis == 1
                      ? ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                              hPad, 16, hPad, 100),
                          itemCount: banners.length,
                          itemBuilder: (_, i) =>
                              _bannerCard(banners[i], isTablet, isDesktop),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.fromLTRB(
                              hPad, 16, hPad, 100),
                          itemCount: banners.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxis,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio:
                                isDesktop ? 1.4 : 1.2,
                          ),
                          itemBuilder: (_, i) =>
                              _bannerCard(banners[i], isTablet, isDesktop),
                        ),
                ),
    );
  }

  Widget _bannerCard(
      Map banner, bool isTablet, bool isDesktop) {
    final bool isActive = banner['is_active'] ?? true;

    return Container(
      margin: EdgeInsets.only(
          bottom: isTablet || isDesktop ? 0 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner image
          ClipRRect(
            borderRadius:
                 BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(
                  banner['image_url'],
                  height: isTablet || isDesktop ? 160 : 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: isTablet || isDesktop ? 160 : 140,
                    color: Colors.orange.shade50,
                    child:  Icon(Icons.image,
                        size: 50, color: Colors.orange),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? "Active" : "Inactive",
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(
                isTablet || isDesktop ? 14 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner['title']?.isNotEmpty == true
                      ? banner['title']
                      : "No title",
                  style: TextStyle(
                    fontSize: isTablet || isDesktop ? 16 : 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                 SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            showBannerDialog(banner: banner),
                        icon:  Icon(Icons.edit,
                            size: 15, color: Colors.white),
                        label:  Text("Edit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding:  EdgeInsets.symmetric(
                              vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                     SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            toggleActive(banner['id'], isActive),
                        icon: Icon(
                          isActive
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: Text(
                          isActive ? "Hide" : "Show",
                          style:  TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isActive
                              ? Colors.orange
                              : Colors.green,
                          padding:  EdgeInsets.symmetric(
                              vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                     SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => deleteBanner(banner),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:  EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child:  Icon(Icons.delete,
                          color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}