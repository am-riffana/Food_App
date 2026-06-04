import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  Future<void> loadBanners() async {
    setState(() => isLoading = true);

    final data = await _supabase
        .from('banners')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      banners = data;
      isLoading = false;
    });
  }

  // ---------------- RESPONSIVE DIALOG ----------------
  void showBannerDialog({Map? banner}) {
    final urlCtrl = TextEditingController(text: banner?['image_url']);
    final titleCtrl = TextEditingController(text: banner?['title']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final width = MediaQuery.of(context).size.width;

        return Container(
          padding: EdgeInsets.only(
            left: width * 0.05,
            right: width * 0.05,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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

                const SizedBox(height: 18),

                Text(
                  banner == null ? "Add Banner" : "Edit Banner",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: urlCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.image, color: Colors.orange),
                    hintText: "Image URL",
                    filled: true,
                    fillColor: Colors.orange.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.title, color: Colors.orange),
                    hintText: "Title (optional)",
                    filled: true,
                    fillColor: Colors.orange.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      if (urlCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter image URL"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        if (banner == null) {
                          await _supabase.from('banners').insert({
                            'image_url': urlCtrl.text.trim(),
                            'title': titleCtrl.text.trim(),
                            'is_active': true,
                          });
                        } else {
                          await _supabase.from('banners').update({
                            'image_url': urlCtrl.text.trim(),
                            'title': titleCtrl.text.trim(),
                          }).eq('id', banner['id']);
                        }

                        Navigator.pop(context);
                        loadBanners();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              banner == null
                                  ? "Banner added!"
                                  : "Banner updated!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      banner == null ? "Add Banner" : "Update Banner",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
  }

  Future<void> toggleActive(String id, bool current) async {
    await _supabase
        .from('banners')
        .update({'is_active': !current})
        .eq('id', id);
    loadBanners();
  }

  Future<void> deleteBanner(String id) async {
    await _supabase.from('banners').delete().eq('id', id);
    loadBanners();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        title: const Text("Manage Banners"),
        actions: [
          IconButton(
            onPressed: loadBanners,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => showBannerDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))

          : banners.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 80, color: Colors.orange),
                      SizedBox(height: 12),
                      Text(
                        "No banners added yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )

              : ListView.builder(
                  padding: EdgeInsets.all(width * 0.04),
                  itemCount: banners.length,
                  itemBuilder: (_, i) {
                    final banner = banners[i];
                    final isActive = banner['is_active'] ?? true;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                            child: Image.network(
                              banner['image_url'],
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 140,
                                color: Colors.orange.shade50,
                                child: const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(width * 0.04),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        banner['title'] ?? "No title",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.green.shade50
                                            : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isActive ? "Active" : "Inactive",
                                        style: TextStyle(
                                          color: isActive
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          showBannerDialog(banner: banner),
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text("Edit"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          toggleActive(banner['id'], isActive),
                                      icon: Icon(
                                        isActive
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 16,
                                      ),
                                      label: Text(
                                        isActive ? "Hide" : "Show",
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isActive
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          deleteBanner(banner['id']),
                                      icon: const Icon(Icons.delete, size: 16),
                                      label: const Text("Delete"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
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
    );
  }
}