import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'intention_detail_screen.dart';
import 'content_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _selectedTab = 0; // 0 = Saved Intentions, 1 = Saved Content

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final savedIntentions = appState.getFavoriteIntentions();
    final savedContent = appState.getSavedContent();

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Saved Items",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "Access your bookmarked spiritual intentions and supporting content.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              // Segmented Controller
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
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
                          child: Center(
                            child: Text(
                              "Intentions (${savedIntentions.length})",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                                color: _selectedTab == 0 ? AppColors.primary : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                          child: Center(
                            child: Text(
                              "Content (${savedContent.length})",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                                color: _selectedTab == 1 ? AppColors.primary : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // TAB 0: SAVED INTENTIONS
              if (_selectedTab == 0) ...[
                if (savedIntentions.isNotEmpty) ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savedIntentions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final intent = savedIntentions[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => IntentionDetailScreen(intention: intent),
                            ),
                          );
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
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(intent.icon, color: AppColors.primary, size: 22),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      intent.topicTag,
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      intent.title,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite, color: AppColors.roseIcon, size: 20),
                                onPressed: () {
                                  appState.toggleFavoriteIntention(intent.id);
                                  CustomPillToast.show(context, "Removed from saved");
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  _buildEmptyState(
                    icon: Icons.bookmark_border,
                    title: "No saved intentions yet",
                    message: "Tap the heart icon on any intention while exploring to save it here for quick access.",
                  ),
                ],
              ]
              // TAB 1: SAVED CONTENT
              else ...[
                if (savedContent.isNotEmpty) ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: savedContent.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = savedContent[index];
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  color: AppColors.secondaryContainer,
                                  child: Image.network(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Icon(Icons.menu_book, color: AppColors.secondary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryContainer,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        item.type.name.toUpperCase(),
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.onSecondaryContainer),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.title,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.bookmark, color: AppColors.primaryContainer, size: 22),
                                onPressed: () {
                                  appState.toggleSaveContent(item.id);
                                  CustomPillToast.show(context, "Removed from saved content");
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  _buildEmptyState(
                    icon: Icons.auto_stories,
                    title: "No saved content yet",
                    message: "Tap the bookmark icon on any article, video, or audio guide to review it later.",
                  ),
                ],
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainer,
            ),
            child: Icon(icon, color: AppColors.secondary, size: 26),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
