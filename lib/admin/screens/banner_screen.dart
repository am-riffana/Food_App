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

  void showBannerDialog({Map? banner}) {
    final urlCtrl =
        TextEditingController(text: banner?['image_url']);
    final titleCtrl =
        TextEditingController(text: banner?['title']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              banner == null ? "Add Banner" : "Edit Banner",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // IMAGE URL
            TextField(
              controller: urlCtrl,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.image, color: Colors.orange),
                hintText: "Image URL",
                filled: true,
                fillColor: Colors.orange.shade50,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            // TITLE
            TextField(
              controller: titleCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.title, color: Colors.orange),
                hintText: "Title (optional)",
                filled: true,
                fillColor: Colors.orange.shade50,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // PREVIEW
            if (urlCtrl.text.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  urlCtrl.text,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () async {
                  if (urlCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Enter image URL"),
                          backgroundColor: Colors.red));
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
                      await _supabase
                          .from('banners')
                          .update({
                            'image_url': urlCtrl.text.trim(),
                            'title': titleCtrl.text.trim(),
                          })
                          .eq('id', banner['id']);
                    }
                    Navigator.pop(context);
                    loadBanners();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(banner == null
                            ? "Banner added!"
                            : "Banner updated!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                child: Text(
                  banner == null ? "Add Banner" : "Update Banner",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Banners'),
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
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : banners.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 80, color: Colors.orange),
                      SizedBox(height: 16),
                      Text("No banners added yet",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Tap + to add a banner",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: banners.length,
                  itemBuilder: (_, i) {
                    final banner = banners[i];
                    final isActive = banner['is_active'] ?? true;
                    return Opacity(
                      opacity: isActive ? 1.0 : 0.5,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // IMAGE PREVIEW
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              child: Image.network(
                                banner['image_url'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 150,
                                  color: Colors.orange.shade50,
                                  child: const Icon(Icons.image,
                                      color: Colors.orange, size: 50),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          banner['title'] ?? 'No title',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // ACTIVE/INACTIVE BADGE
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? Colors.green.shade50
                                              : Colors.red.shade50,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          isActive ? 'Active' : 'Inactive',
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
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      // EDIT
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                          ),
                                          onPressed: () =>
                                              showBannerDialog(banner: banner),
                                          icon: const Icon(Icons.edit,
                                              color: Colors.white, size: 16),
                                          label: const Text("Edit",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // SHOW/HIDE
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isActive
                                                ? Colors.red
                                                : Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                          ),
                                          onPressed: () => toggleActive(
                                              banner['id'], isActive),
                                          icon: Icon(
                                            isActive
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          label: Text(
                                            isActive ? "Hide" : "Show",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // DELETE
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        onPressed: () =>
                                            deleteBanner(banner['id']),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white, size: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}