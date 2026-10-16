import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'subcategories_screen.dart';
import 'intention_list_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final categories = appState.categories;

    // Filter categories or intentions by query
    final filteredCategories = categories.where((cat) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final matchesName = cat.name.toLowerCase().contains(q);
      final subMatches = appState
          .getSubcategoriesForCategory(cat.id)
          .any((s) => s.name.toLowerCase().contains(q) || s.description.toLowerCase().contains(q));
      final intentMatches = appState
          .getIntentionsForCategory(cat.id)
          .any((i) => i.title.toLowerCase().contains(q) || i.topicTag.toLowerCase().contains(q));
      return matchesName || subMatches || intentMatches;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Title Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Explore Intentions",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.tune, color: AppColors.secondary, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search Input Field
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.cardShadow,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search intentions, categories...",
                    hintStyle: const TextStyle(color: AppColors.outline, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.secondary, size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18, color: AppColors.outline),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Featured Scenic Contemplation Banner
              if (_searchQuery.isEmpty) ...[
                const ScenicBanner(
                  tag: "Daily Niyyah",
                  title: "“Actions are judged solely by intentions.”",
                  subtitle: "Set purposeful intentions before each daily endeavor.",
                  quote: "Focus inward. Cultivate tranquility through deliberate mindfulness.",
                  height: 150,
                  trailing: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.secondaryContainer,
                    child: Icon(Icons.spa, color: AppColors.primaryContainer, size: 26),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Section Header: Browse by category
              SectionHeader(
                title: "Browse by category",
                subtitle: "(${categories.length} core domains)",
                onViewAll: null,
              ),
              const SizedBox(height: 8),

              // Category Cards List
              if (filteredCategories.isNotEmpty) ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCategories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final cat = filteredCategories[index];
                    return _buildCategoryCard(context, cat, appState);
                  },
                ),
              ] else ...[
                _buildEmptySearchState(context),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel cat, AppState appState) {
    return InkWell(
      onTap: () {
        // Direct jump if category has NO subcategories (like Family & Relationships)
        if (!cat.hasSubcategories) {
          final directIntentions = appState.getIntentionsForCategory(cat.id);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => IntentionListScreen(
                category: cat,
                title: cat.name,
                intentions: directIntentions,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SubcategoriesScreen(category: cat),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cat.backgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(cat.icon, color: cat.iconColor, size: 24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          cat.name,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!cat.hasSubcategories) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Direct",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    cat.hasSubcategories
                        ? "${cat.intentionCount} intentions • ${cat.subPathCount} sub-paths"
                        : "${cat.intentionCount} direct intentions",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainer,
            ),
            child: const Center(
              child: Icon(Icons.filter_vintage, color: AppColors.secondary, size: 28),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "No matching intentions found",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            "Try searching for other mindful topics like \"patience\", \"speech\", or \"family\".",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onSecondaryFixed,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            child: const Text("Clear filters", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
