import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'intention_list_screen.dart';

class SubcategoriesScreen extends StatelessWidget {
  final CategoryModel category;

  const SubcategoriesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final subcategories = appState.getSubcategoriesForCategory(category.id);

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.name,
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScenicBanner(
                tag: "Domain Focus",
                title: category.name,
                subtitle: "Explore sub-themes and choose deliberate intentions for your character.",
                height: 140,
                trailing: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: category.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, color: category.iconColor, size: 28),
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(
                title: "Choose a sub-theme",
                subtitle: "(${subcategories.length} available)",
              ),
              const SizedBox(height: 8),
              if (subcategories.isNotEmpty) ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subcategories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final sub = subcategories[index];
                    final intentions = appState.getIntentionsForSubcategory(sub.id);

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => IntentionListScreen(
                              category: category,
                              subcategory: sub,
                              title: sub.name,
                              intentions: intentions,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(sub.icon, color: AppColors.primaryContainer, size: 22),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sub.name,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    sub.description,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${intentions.length} curated intentions",
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "No subcategories configured for this category yet.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
