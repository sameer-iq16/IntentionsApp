import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'intention_detail_screen.dart';
import 'content_detail_screen.dart';
import 'add_custom_intention_screen.dart';
import 'reminder_timing_screen.dart';

class IntentionListScreen extends StatefulWidget {
  final CategoryModel category;
  final SubcategoryModel? subcategory;
  final String title;
  final List<IntentionModel> intentions;

  const IntentionListScreen({
    super.key,
    required this.category,
    this.subcategory,
    required this.title,
    required this.intentions,
  });

  @override
  State<IntentionListScreen> createState() => _IntentionListScreenState();
}

class _IntentionListScreenState extends State<IntentionListScreen> {
  int _selectedTab = 0; // 0 = Intentions, 1 = Content
  ContentType? _selectedContentFilter; // null = All, or text, video, audio

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    // Current fresh intentions from appState
    final liveIntentions = widget.subcategory != null
        ? appState.getIntentionsForSubcategory(widget.subcategory!.id)
        : appState.getIntentionsForCategory(widget.category.id);

    final intentionsToShow = liveIntentions.isNotEmpty ? liveIntentions : widget.intentions;

    // Collect all supporting content from these intentions
    final List<SupportingContentModel> allContent = [];
    for (var intent in intentionsToShow) {
      allContent.addAll(intent.supportingContent);
    }

    final filteredContent = allContent.where((c) {
      if (_selectedContentFilter == null) return true;
      return c.type == _selectedContentFilter;
    }).toList();

    final allIntentionIds = intentionsToShow.map((i) => i.id).toList();
    final areAllSelected = allIntentionIds.isNotEmpty &&
        allIntentionIds.every((id) => appState.selectedIntentionIds.contains(id));

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
            ),
            Text(
              "Choose the intentions that matter to you.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Controller: Intentions vs Content (if Content feature enabled by admin)
              if (appState.contentFeatureEnabled) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      // Intentions Tab
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedTab = 0),
                          borderRadius: BorderRadius.circular(26),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedTab == 0 ? AppColors.surfaceContainerLowest : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: _selectedTab == 0 ? AppColors.cardShadow : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.eco,
                                  size: 18,
                                  color: _selectedTab == 0 ? AppColors.primary : AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Intentions",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                                    color: _selectedTab == 0 ? AppColors.primary : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Content Tab
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedTab = 1),
                          borderRadius: BorderRadius.circular(26),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedTab == 1 ? AppColors.surfaceContainerLowest : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: _selectedTab == 1 ? AppColors.cardShadow : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_circle_outline,
                                  size: 18,
                                  color: _selectedTab == 1 ? AppColors.primary : AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Content",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                                    color: _selectedTab == 1 ? AppColors.primary : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // TAB 0: INTENTIONS VIEW
              if (_selectedTab == 0 || !appState.contentFeatureEnabled) ...[
                // Scenic Artwork Banner
                ScenicBanner(
                  title: widget.title,
                  subtitle: "Select multiple intentions to set gentle reminders or deepen reflection.",
                  tag: widget.category.name,
                  height: 130,
                  trailing: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondaryContainer.withValues(alpha: 0.8),
                    ),
                    child: const Icon(Icons.spa, color: AppColors.primary, size: 24),
                  ),
                ),
                const SizedBox(height: 14),

                // Multi-Select Action Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        appState.selectAllIntentions(allIntentionIds);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: areAllSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: areAllSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
                                  width: 1.5,
                                ),
                              ),
                              child: areAllSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Select all (${intentionsToShow.length})",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appState.selectedIntentionIds.isNotEmpty
                            ? AppColors.primaryContainer
                            : AppColors.secondaryContainer,
                        foregroundColor: appState.selectedIntentionIds.isNotEmpty
                            ? Colors.white
                            : AppColors.onSecondaryFixed,
                        shape: const StadiumBorder(),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.notifications_active_outlined, size: 16),
                      label: Text(
                        appState.selectedIntentionIds.isNotEmpty
                            ? "Set reminders (${appState.selectedIntentionIds.length})"
                            : "Set reminders",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        // If none selected, auto select the current one or all
                        if (appState.selectedIntentionIds.isEmpty && intentionsToShow.isNotEmpty) {
                          appState.toggleSelectIntention(intentionsToShow.first.id);
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReminderTimingScreen(
                              category: widget.category,
                              subcategory: widget.subcategory,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Intentions Vertical Stack
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: intentionsToShow.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final intent = intentionsToShow[index];
                    final isSelected = appState.selectedIntentionIds.contains(intent.id);

                    return _buildIntentionCard(
                      context: context,
                      intention: intent,
                      isSelected: isSelected,
                      onToggleSelect: () => appState.toggleSelectIntention(intent.id),
                      onToggleFavorite: () {
                        appState.toggleFavoriteIntention(intent.id);
                        CustomPillToast.show(
                          context,
                          intent.isFavorite ? "Removed from Saved" : "Saved to your intentions",
                          icon: intent.isFavorite ? Icons.bookmark_remove : Icons.bookmark_added,
                        );
                      },
                      onOpenDetail: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => IntentionDetailScreen(intention: intent),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Bottom CTA: Add your own intention
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddCustomIntentionScreen(
                          preselectedCategory: widget.category,
                          preselectedSubcategory: widget.subcategory,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceContainerHigh),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Add your own intention",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
              // TAB 1: SUPPORTING CONTENT VIEW
              else ...[
                // Content Header Banner
                const ScenicBanner(
                  tag: "As-Sabr Reflection",
                  title: "Supporting content",
                  subtitle: "Helpful resources to deepen your understanding and practice this intention.",
                  height: 130,
                  trailing: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.secondaryContainer,
                    child: Icon(Icons.menu_book, color: AppColors.primary, size: 22),
                  ),
                ),
                const SizedBox(height: 14),

                // Media Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip("All", null, null),
                      const SizedBox(width: 8),
                      _buildFilterChip("Text", ContentType.text, Icons.menu_book),
                      const SizedBox(width: 8),
                      _buildFilterChip("Video", ContentType.video, Icons.smart_display),
                      const SizedBox(width: 8),
                      _buildFilterChip("Audio", ContentType.audio, Icons.headphones),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Supporting Content List
                if (filteredContent.isNotEmpty) ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredContent.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredContent[index];
                      return _buildContentCard(context, item, appState);
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
                        "No supporting content matches the selected filter.",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ContentType? type, IconData? icon) {
    final isSelected = _selectedContentFilter == type;
    return InkWell(
      onTap: () => setState(() => _selectedContentFilter = type),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? AppColors.cardShadow : [],
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: isSelected ? Colors.white : AppColors.secondary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntentionCard({
    required BuildContext context,
    required IntentionModel intention,
    required bool isSelected,
    required VoidCallback onToggleSelect,
    required VoidCallback onToggleFavorite,
    required VoidCallback onOpenDetail,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpenDetail,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Custom Rounded Checkbox
                InkWell(
                  onTap: onToggleSelect,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),

                // Icon Avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(intention.icon, color: AppColors.primary, size: 22),
                  ),
                ),
                const SizedBox(width: 12),

                // Intention Title
                Expanded(
                  child: Text(
                    intention.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          height: 1.25,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),

                // Actions: Favorite, Share, Chevron
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        intention.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: intention.isFavorite ? AppColors.roseIcon : AppColors.outline,
                        size: 20,
                      ),
                      onPressed: onToggleFavorite,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: AppColors.outline, size: 18),
                      onPressed: () {
                        CustomPillToast.show(context, "Intention copied to clipboard");
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: AppColors.outlineVariant, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, SupportingContentModel item, AppState appState) {
    final isSaved = appState.isContentSaved(item.id);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(content: item),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            // Thumbnail with format overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    color: AppColors.secondaryContainer,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_outlined,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  if (item.type == ContentType.video)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black26,
                        child: const Center(
                          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 26),
                        ),
                      ),
                    ),
                  if (item.type == ContentType.audio)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black12,
                        child: const Center(
                          child: Icon(Icons.headphones, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.type == ContentType.text
                          ? AppColors.secondaryContainer
                          : item.type == ContentType.video
                              ? AppColors.roseBg
                              : AppColors.lavenderBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.type.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: item.type == ContentType.text
                            ? AppColors.onSecondaryContainer
                            : item.type == ContentType.video
                                ? AppColors.roseIcon
                                : AppColors.lavenderIcon,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        item.type == ContentType.text
                            ? Icons.auto_stories
                            : item.type == ContentType.video
                                ? Icons.timer
                                : Icons.volume_up,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.durationDisplay,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Save Bookmark Button
            IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? AppColors.primaryContainer : AppColors.outline,
                size: 20,
              ),
              onPressed: () {
                appState.toggleSaveContent(item.id);
                CustomPillToast.show(
                  context,
                  isSaved ? "Removed from Saved" : "Content saved",
                  icon: isSaved ? Icons.bookmark_remove : Icons.bookmark_added,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
