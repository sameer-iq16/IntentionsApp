import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AdminPortalScreen extends StatefulWidget {
  const AdminPortalScreen({super.key});

  @override
  State<AdminPortalScreen> createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends State<AdminPortalScreen> {
  int _activeAdminSection = 0; // 0=Toggles, 1=Categories, 2=Subcategories, 3=Intentions, 4=Actions, 5=Content

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDesktop = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            appState.setAdminMode(false);
          },
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.roseBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "SUPERADMIN",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.roseIcon),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Computer & Mobile CMS",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.visibility, size: 16, color: AppColors.primary),
            label: const Text("User View", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            onPressed: () => appState.setAdminMode(false),
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isDesktop ? _buildDesktopLayout(context, appState) : _buildMobileLayout(context, appState),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppState appState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar for desktop
        Material(
          color: AppColors.surfaceContainerLowest,
          child: SizedBox(
            width: 250,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
              _buildSidebarItem(0, "Feature Toggles", Icons.tune),
              _buildSidebarItem(1, "Categories (${appState.categories.length})", Icons.category),
              _buildSidebarItem(2, "Subcategories (${appState.subcategories.length})", Icons.account_tree),
              _buildSidebarItem(3, "Intentions (${appState.intentions.length})", Icons.eco),
              _buildSidebarItem(4, "Suggested Actions", Icons.task_alt),
              _buildSidebarItem(5, "Supporting Content", Icons.menu_book),
              const Divider(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Platform Rules:\n• Admin manages all curated presets.\n• Users can only add personal intentions.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
      const VerticalDivider(width: 1),
        // Content Area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildSelectedSection(context, appState),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppState appState) {
    return Column(
      children: [
        // Mobile horizontal section tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildTabChip(0, "Toggles"),
              _buildTabChip(1, "Categories"),
              _buildTabChip(2, "Subcategories"),
              _buildTabChip(3, "Intentions"),
              _buildTabChip(4, "Actions"),
              _buildTabChip(5, "Content"),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildSelectedSection(context, appState),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(int index, String label, IconData icon) {
    final isSelected = _activeAdminSection == index;
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.secondaryContainer.withValues(alpha: 0.4),
      leading: Icon(icon, color: isSelected ? AppColors.primaryContainer : AppColors.secondary),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primaryContainer : AppColors.onSurface,
          fontSize: 13,
        ),
      ),
      onTap: () => setState(() => _activeAdminSection = index),
    );
  }

  Widget _buildTabChip(int index, String label) {
    final isSelected = _activeAdminSection == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        selectedColor: AppColors.primaryContainer,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        onSelected: (_) => setState(() => _activeAdminSection = index),
      ),
    );
  }

  Widget _buildSelectedSection(BuildContext context, AppState appState) {
    switch (_activeAdminSection) {
      case 0:
        return _buildFeatureToggles(context, appState);
      case 1:
        return _buildCategoriesManager(context, appState);
      case 2:
        return _buildSubcategoriesManager(context, appState);
      case 3:
        return _buildIntentionsManager(context, appState);
      case 4:
        return _buildActionsManager(context, appState);
      case 5:
        return _buildContentManager(context, appState);
      default:
        return const SizedBox.shrink();
    }
  }

  // 1. FEATURE TOGGLES SECTION
  Widget _buildFeatureToggles(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Global Feature Control", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text(
          "As requested: The admin can enable or disable the 'Simple Action' and 'Content' features on the platform at any time.",
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),

        // Toggle 1: Simple Actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Simple Action / Micro-Habits Feature", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 4),
                    Text("Controls suggested actions cross-sell and micro-habit reminders with durations", style: TextStyle(fontSize: 12, color: AppColors.outline)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: appState.simpleActionsEnabled,
                activeThumbColor: AppColors.primaryContainer,
                onChanged: (val) {
                  appState.setSimpleActionsEnabled(val);
                  CustomPillToast.show(context, val ? "Simple Actions Enabled" : "Simple Actions Disabled");
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Toggle 2: Content Feature
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Supporting Content Feature", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 4),
                    Text("Controls educational articles, video masterclasses, and audio reflections", style: TextStyle(fontSize: 12, color: AppColors.outline)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: appState.contentFeatureEnabled,
                activeThumbColor: AppColors.primaryContainer,
                onChanged: (val) {
                  appState.setContentFeatureEnabled(val);
                  CustomPillToast.show(context, val ? "Supporting Content Enabled" : "Supporting Content Disabled");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. CATEGORIES MANAGER SECTION
  Widget _buildCategoriesManager(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Preset Categories", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer, foregroundColor: Colors.white),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Add Category"),
              onPressed: () => _showAddCategoryDialog(context, appState),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Admin manages all preset domains. Categories can be marked as 'Direct' (e.g. Family & Relationships) to bypass subcategories.",
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appState.categories.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cat = appState.categories[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: cat.backgroundColor, borderRadius: BorderRadius.circular(12)),
                    child: Icon(cat.icon, color: cat.iconColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: cat.hasSubcategories ? AppColors.secondaryContainer : AppColors.amberBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                cat.hasSubcategories ? "Sub-paths" : "Direct (No Sub-paths)",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: cat.hasSubcategories ? AppColors.onSecondaryContainer : AppColors.amberIcon,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text("${cat.intentionCount} intentions", style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                    onPressed: () => appState.deleteCategory(cat.id),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // 3. SUBCATEGORIES MANAGER SECTION
  Widget _buildSubcategoriesManager(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Curated Subcategories", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer, foregroundColor: Colors.white),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Add Subcategory"),
              onPressed: () => _showAddSubcategoryDialog(context, appState),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appState.subcategories.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final sub = appState.subcategories[index];
            final parent = appState.categories.firstWhere((c) => c.id == sub.categoryId, orElse: () => appState.categories.first);

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(10)),
                    child: Icon(sub.icon, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sub.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("Category: ${parent.name} • ${sub.description}", style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                    onPressed: () => appState.deleteSubcategory(sub.id),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // 4. INTENTIONS MANAGER SECTION
  Widget _buildIntentionsManager(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Preset Intentions", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer, foregroundColor: Colors.white),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Add Intention"),
              onPressed: () => _showAddIntentionDialog(context, appState),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appState.intentions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final intent = appState.intentions[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Icon(intent.icon, color: AppColors.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(intent.topicTag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                        Text(intent.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("${intent.suggestedActions.length} actions • ${intent.supportingContent.length} content resources",
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                    onPressed: () => appState.deleteIntention(intent.id),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // 5. SUGGESTED ACTIONS MANAGER SECTION (WITH TIME/PRICE DURATION SETUP)
  Widget _buildActionsManager(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Suggested Micro-Habit Actions", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text(
          "Admin sets the completion time duration for every suggested action, displayed on the app like product price tags.",
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),

        ...appState.intentions.map((intent) {
          if (intent.suggestedActions.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(intent.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text("Add Action", style: TextStyle(fontSize: 12)),
                      onPressed: () => _showAddActionDialog(context, appState, intent.id),
                    ),
                  ],
                ),
                const Divider(),
                ...intent.suggestedActions.map((act) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(act.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                Text(act.description, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(10)),
                            child: Text(act.durationDisplay, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSecondaryContainer)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () => appState.deleteSuggestedAction(intent.id, act.id),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 6. SUPPORTING CONTENT MANAGER SECTION
  Widget _buildContentManager(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Supporting Content Curations", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text(
          "Admin manages educational articles, video masterclasses, and audio meditation guides attached to intentions.",
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),

        ...appState.intentions.map((intent) {
          if (intent.supportingContent.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(intent.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text("Add Content", style: TextStyle(fontSize: 12)),
                      onPressed: () => _showAddContentDialog(context, appState, intent.id),
                    ),
                  ],
                ),
                const Divider(),
                ...intent.supportingContent.map((c) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            c.type == ContentType.text
                                ? Icons.menu_book
                                : c.type == ContentType.video
                                    ? Icons.smart_display
                                    : Icons.headphones,
                            size: 18,
                            color: AppColors.primaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                Text("${c.type.name.toUpperCase()} • ${c.durationDisplay}", style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () => appState.deleteSupportingContent(intent.id, c.id),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        }),
      ],
    );
  }

  // DIALOGS FOR CRUD
  void _showAddCategoryDialog(BuildContext context, AppState appState) {
    final nameCtrl = TextEditingController();
    bool hasSubs = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDState) => AlertDialog(
          title: const Text("Add Preset Category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Category Name (e.g. Daily Worship)"),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text("Has Subcategories?", style: TextStyle(fontSize: 13)),
                subtitle: const Text("Disable for direct intentions like Family", style: TextStyle(fontSize: 11)),
                value: hasSubs,
                onChanged: (val) => setDState(() => hasSubs = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  final id = 'cat_${DateTime.now().millisecondsSinceEpoch}';
                  appState.addCategory(
                    CategoryModel(
                      id: id,
                      name: nameCtrl.text.trim(),
                      icon: Icons.bookmark_border,
                      iconName: 'bookmark',
                      intentionCount: 0,
                      subPathCount: 0,
                      backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.5),
                      iconColor: AppColors.primary,
                      hasSubcategories: hasSubs,
                    ),
                  );
                  Navigator.pop(ctx);
                  CustomPillToast.show(context, "Category added successfully!");
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubcategoryDialog(BuildContext context, AppState appState) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String catId = appState.categories.first.id;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDState) => AlertDialog(
          title: const Text("Add Subcategory"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: catId,
                isExpanded: true,
                items: appState.categories.where((c) => c.hasSubcategories).map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDState(() => catId = val);
                },
              ),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Subcategory Name")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Short Description")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  appState.addSubcategory(
                    SubcategoryModel(
                      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
                      categoryId: catId,
                      name: nameCtrl.text.trim(),
                      icon: Icons.hourglass_empty,
                      iconName: 'hourglass_empty',
                      description: descCtrl.text.trim(),
                    ),
                  );
                  Navigator.pop(ctx);
                  CustomPillToast.show(context, "Subcategory added!");
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddIntentionDialog(BuildContext context, AppState appState) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final quoteCtrl = TextEditingController();
    String catId = appState.categories.first.id;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Preset Intention"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Intention Title")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description / Meaning")),
              TextField(controller: quoteCtrl, decoration: const InputDecoration(labelText: "Quran / Hadith Quote")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                final id = 'int_${DateTime.now().millisecondsSinceEpoch}';
                appState.addAdminIntention(
                  IntentionModel(
                    id: id,
                    categoryId: catId,
                    title: titleCtrl.text.trim(),
                    topicTag: "Curated • Admin",
                    description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : titleCtrl.text.trim(),
                    whyItMatters: "Spiritual centering and deliberate mindful devotion.",
                    quote: quoteCtrl.text.trim().isNotEmpty ? quoteCtrl.text.trim() : "“Actions are according to intentions.”",
                    quoteReference: "Bukhari",
                    icon: Icons.eco_outlined,
                    iconName: 'eco',
                  ),
                );
                Navigator.pop(ctx);
                CustomPillToast.show(context, "Intention created!");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAddActionDialog(BuildContext context, AppState appState, String intentionId) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: "3 min");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Suggested Action"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Action Title")),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Instructions / Prompt")),
            TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: "Completion Time / Price (e.g. 3 min)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                appState.addSuggestedAction(
                  intentionId,
                  SuggestedActionModel(
                    id: 'act_${DateTime.now().millisecondsSinceEpoch}',
                    intentionId: intentionId,
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    durationMinutes: int.tryParse(timeCtrl.text.split(' ').first) ?? 3,
                    durationDisplay: timeCtrl.text.trim(),
                  ),
                );
                Navigator.pop(ctx);
                CustomPillToast.show(context, "Suggested action attached!");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAddContentDialog(BuildContext context, AppState appState, String intentionId) {
    final titleCtrl = TextEditingController();
    final durCtrl = TextEditingController(text: "5 min read");
    ContentType cType = ContentType.text;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDState) => AlertDialog(
          title: const Text("Add Supporting Content"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<ContentType>(
                value: cType,
                isExpanded: true,
                items: ContentType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()))).toList(),
                onChanged: (val) {
                  if (val != null) setDState(() => cType = val);
                },
              ),
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Content Title")),
              TextField(controller: durCtrl, decoration: const InputDecoration(labelText: "Duration Label (e.g. 5 min read)")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  appState.addSupportingContent(
                    intentionId,
                    SupportingContentModel(
                      id: 'cnt_${DateTime.now().millisecondsSinceEpoch}',
                      intentionId: intentionId,
                      title: titleCtrl.text.trim(),
                      type: cType,
                      durationDisplay: durCtrl.text.trim(),
                      imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80",
                      author: "Superadmin Curations",
                      summary: "Curated reflection resource to deepen practice.",
                      fullContent: "Practical spiritual insights curated by admin.",
                    ),
                  );
                  Navigator.pop(ctx);
                  CustomPillToast.show(context, "Supporting content attached!");
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
