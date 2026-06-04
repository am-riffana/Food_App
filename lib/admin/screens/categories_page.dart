import 'package:flutter/material.dart';
import 'package:foodapp/widgets/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AdminCategoriesPage extends StatefulWidget {
  const AdminCategoriesPage({super.key});

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() => isLoading = true);
    try {
      final data = await _supabase
          .from('categories')
          .select()
          .order('created_at', ascending: false);
      setState(() {
        categories = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Load categories error: $e');
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .trim()
        .split(' ')
        .map((w) => w.isEmpty
            ? w
            : w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  // ── Duplicate check ───────────────────────────────────────────────────
  bool isDuplicate(String name, {String? excludeId}) {
    return categories.any(
      (c) =>
          c['name'].toString().toLowerCase() == name.trim().toLowerCase() &&
          c['id'] != excludeId,
    );
  }

  // ── Dialog ────────────────────────────────────────────────────────────
  void showCategoryDialog({Map<String, dynamic>? category}) {
    final nameCtrl =
        TextEditingController(text: category?['name']);
    final imgCtrl =
        TextEditingController(text: category?['image_url']);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final bool isTablet = Responsive.isTablet(context);
        final double screenWidth = Responsive.w(context);
        final double hPad = isTablet ? 32.0 : screenWidth * 0.05;

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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
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
                      category == null
                          ? "Add Category"
                          : "Edit Category",
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Image preview
                    ValueListenableBuilder(
                      valueListenable: imgCtrl,
                      builder: (_, __, ___) {
                        if (imgCtrl.text.isNotEmpty) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(16),
                                child: Image.network(
                                  imgCtrl.text,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(
                                    height: 160,
                                    color: Colors.orange.shade50,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.orange,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Name field
                    TextField(
                      controller: nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category,
                            color: Colors.orange),
                        hintText: "Category Name",
                        filled: true,
                        fillColor: Colors.orange.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Image URL field
                    TextField(
                      controller: imgCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.image,
                            color: Colors.orange),
                        hintText: "Image URL",
                        filled: true,
                        fillColor: Colors.orange.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: isSaving
                            ? null
                            : () async {
                                final name = capitalize(
                                    nameCtrl.text.trim());

                                if (name.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Category name is required"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // ── Duplicate check ──────────────────
                                if (isDuplicate(name,
                                    excludeId: category?['id'])) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '"$name" already exists.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setSheetState(
                                    () => isSaving = true);

                                try {
                                  if (category == null) {
                                    await _supabase
                                        .from('categories')
                                        .insert({
                                      'id': const Uuid().v4(),
                                      'name': name,
                                      'image_url':
                                          imgCtrl.text.trim(),
                                      'is_active': true,
                                    });
                                  } else {
                                    await _supabase
                                        .from('categories')
                                        .update({
                                      'name': name,
                                      'image_url':
                                          imgCtrl.text.trim(),
                                    }).eq('id', category['id']);
                                  }

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          category == null
                                              ? "Category added!"
                                              : "Category updated!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                  loadCategories();
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
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                category == null
                                    ? "Add Category"
                                    : "Update Category",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
      },
    );
  }

  // ── Toggle active ─────────────────────────────────────────────────────
  Future<void> toggleActive(String id, bool current) async {
    await _supabase
        .from('categories')
        .update({'is_active': !current}).eq('id', id);
    loadCategories();
  }

  // ── Delete ────────────────────────────────────────────────────────────
  Future<void> deleteCategory(Map<String, dynamic> cat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Category"),
        content:
            Text('Delete "${cat['name']}"? Foods in this category won\'t be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _supabase
          .from('categories')
          .delete()
          .eq('id', cat['id']);
      loadCategories();
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
            : 16.0;

    final int crossAxis = isDesktop
        ? 4
        : isTablet
            ? 3
            : 2;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Manage Categories",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet || isDesktop ? 22 : 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadCategories,
            icon: Icon(Icons.refresh,
                color: Colors.orange,
                size: isTablet || isDesktop ? 28 : 24),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () => showCategoryDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Category",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange))
          : categories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined,
                          size: isTablet || isDesktop ? 100 : 80,
                          color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "No categories yet",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isTablet || isDesktop ? 20 : 16,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadCategories,
                  color: Colors.orange,
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                        hPad, 16, hPad, 100),
                    itemCount: categories.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxis,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (_, i) {
                      final cat = categories[i];
                      final bool isActive =
                          cat['is_active'] ?? true;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Image
                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                child: cat['image_url'] != null &&
                                        cat['image_url']
                                            .toString()
                                            .isNotEmpty
                                    ? Image.network(
                                        cat['image_url'],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(
                                          color: Colors.orange.shade50,
                                          child: const Icon(
                                            Icons.category,
                                            color: Colors.orange,
                                            size: 40,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        color: Colors.orange.shade50,
                                        child: const Icon(
                                          Icons.category,
                                          color: Colors.orange,
                                          size: 40,
                                        ),
                                      ),
                              ),
                            ),

                            // Name + status
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8, 6, 8, 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      cat['name'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      isActive ? "On" : "Off",
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action buttons
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  4, 0, 4, 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () =>
                                          showCategoryDialog(
                                              category: cat),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text("Edit",
                                          style:
                                              TextStyle(fontSize: 11)),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => toggleActive(
                                          cat['id'], isActive),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.orange,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        isActive ? "Hide" : "Show",
                                        style: const TextStyle(
                                            fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () =>
                                          deleteCategory(cat),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text("Del",
                                          style:
                                              TextStyle(fontSize: 11)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}