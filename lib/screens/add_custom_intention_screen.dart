import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AddCustomIntentionScreen extends StatefulWidget {
  final CategoryModel? preselectedCategory;
  final SubcategoryModel? preselectedSubcategory;

  const AddCustomIntentionScreen({
    super.key,
    this.preselectedCategory,
    this.preselectedSubcategory,
  });

  @override
  State<AddCustomIntentionScreen> createState() => _AddCustomIntentionScreenState();
}

class _AddCustomIntentionScreenState extends State<AddCustomIntentionScreen> {
  final TextEditingController _intentionController = TextEditingController();
  late CategoryModel _selectedCategory;
  SubcategoryModel? _selectedSubcategory;
  bool _enableDailyReminder = true;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _selectedCategory = widget.preselectedCategory ??
        (appState.categories.isNotEmpty ? appState.categories.first : SampleData.getCategories().first);

    if (widget.preselectedSubcategory != null) {
      _selectedSubcategory = widget.preselectedSubcategory;
    } else {
      final availableSubs = appState.getSubcategoriesForCategory(_selectedCategory.id);
      _selectedSubcategory = availableSubs.isNotEmpty ? availableSubs.first : null;
    }
  }

  @override
  void dispose() {
    _intentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final availableSubcategories = appState.getSubcategoriesForCategory(_selectedCategory.id);

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "New Intention",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Scenic Niyyah Banner
              ScenicBanner(
                tag: "Niyyah (Intention)",
                title: "Add Custom Intention",
                subtitle: "Personalize your mindfulness journey with your own intention.",
                height: 135,
                trailing: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryContainer,
                  ),
                  child: const Icon(Icons.spa, color: AppColors.primaryContainer, size: 22),
                ),
              ),
              const SizedBox(height: 16),

              // Form Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field 1: Your Intention Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryContainer)),
                            const SizedBox(width: 8),
                            const Text(
                              "Your Intention",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ],
                        ),
                        Text(
                          "${_intentionController.text.length} / 150",
                          style: const TextStyle(fontSize: 12, color: AppColors.outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _intentionController,
                        maxLength: 150,
                        maxLines: 3,
                        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: "e.g., To speak with kindness and patience during family meetings...",
                          hintStyle: TextStyle(color: AppColors.outline, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 2: Preset Category Selector (Curated by Admin)
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryContainer)),
                        const SizedBox(width: 8),
                        const Text(
                          "Category",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CategoryModel>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more, color: AppColors.outline),
                          items: appState.categories.map((cat) {
                            return DropdownMenuItem<CategoryModel>(
                              value: cat,
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: cat.backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Icon(cat.icon, color: cat.iconColor, size: 18),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (cat) {
                            if (cat != null) {
                              setState(() {
                                _selectedCategory = cat;
                                final subs = appState.getSubcategoriesForCategory(cat.id);
                                _selectedSubcategory = subs.isNotEmpty ? subs.first : null;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 3: Subcategory (Optional, if category has subcategories)
                    if (_selectedCategory.hasSubcategories && availableSubcategories.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.outlineVariant)),
                              const SizedBox(width: 8),
                              const Text(
                                "Subcategory",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                            ],
                          ),
                          const Text("Optional", style: TextStyle(fontSize: 12, color: AppColors.outline)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SubcategoryModel?>(
                            value: _selectedSubcategory,
                            isExpanded: true,
                            icon: const Icon(Icons.expand_more, color: AppColors.outline),
                            items: [
                              const DropdownMenuItem<SubcategoryModel?>(
                                value: null,
                                child: Text("General / None", style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                              ),
                              ...availableSubcategories.map((sub) {
                                return DropdownMenuItem<SubcategoryModel?>(
                                  value: sub,
                                  child: Text(sub.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                );
                              }),
                            ],
                            onChanged: (sub) {
                              setState(() => _selectedSubcategory = sub);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // Info Card about preset categories
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondaryContainer,
                            ),
                            child: const Center(
                              child: Icon(Icons.tips_and_updates, size: 16, color: AppColors.primaryContainer),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Note: Categories and subcategories are curated by the app admin. Custom intentions will be saved privately to your profile.",
                              style: TextStyle(fontSize: 12, color: AppColors.onSecondaryContainer, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Enable Daily Reminder Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.notifications_active, color: AppColors.primaryContainer, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Enable Daily Reminder", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            Text("Receive gentle morning prompt at 9:00 AM", style: TextStyle(fontSize: 11, color: AppColors.outline)),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _enableDailyReminder,
                      activeThumbColor: AppColors.primaryContainer,
                      onChanged: (val) => setState(() => _enableDailyReminder = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.bookmark_add, size: 20),
                  label: const Text("Save Intention", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  onPressed: () {
                    final text = _intentionController.text.trim();
                    if (text.isEmpty) {
                      CustomPillToast.show(context, "Please enter your intention");
                      return;
                    }

                    appState.addCustomIntention(
                      title: text,
                      categoryId: _selectedCategory.id,
                      subcategoryId: _selectedSubcategory?.id,
                      enableDailyReminder: _enableDailyReminder,
                    );

                    CustomPillToast.show(context, "Intention saved to your journey!", icon: Icons.check_circle);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
