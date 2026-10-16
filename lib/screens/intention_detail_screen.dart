import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'reminder_timing_screen.dart';

class IntentionDetailScreen extends StatefulWidget {
  final IntentionModel intention;

  const IntentionDetailScreen({super.key, required this.intention});

  @override
  State<IntentionDetailScreen> createState() => _IntentionDetailScreenState();
}

class _IntentionDetailScreenState extends State<IntentionDetailScreen> {
  final Set<String> _checkedActionIds = {};

  @override
  void initState() {
    super.initState();
    for (var act in widget.intention.suggestedActions) {
      if (act.isDefaultChecked) {
        _checkedActionIds.add(act.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final liveIntention = appState.getIntentionById(widget.intention.id) ?? widget.intention;

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Intention Details",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              liveIntention.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: liveIntention.isFavorite ? AppColors.roseIcon : AppColors.secondary,
            ),
            onPressed: () {
              appState.toggleFavoriteIntention(liveIntention.id);
              CustomPillToast.show(
                context,
                liveIntention.isFavorite ? "Removed from Saved" : "Saved to your intentions",
                icon: liveIntention.isFavorite ? Icons.bookmark_remove : Icons.bookmark_added,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.secondary),
            onPressed: () {
              CustomPillToast.show(context, "Intention copied to share");
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Backdrop / Atmospheric Context Card
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
                    // Header Row with Thematic Dome Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Icon(liveIntention.icon, color: AppColors.primaryContainer, size: 30),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome, size: 13, color: AppColors.secondary),
                              const SizedBox(width: 4),
                              Text(
                                "Foundational Intention",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Spiritual Topic Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        liveIntention.topicTag.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSecondaryContainer,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Title & Description
                    Text(
                      liveIntention.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                            height: 1.3,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      liveIntention.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Serene Scenic Micro-Banner Quote
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF14532D), Color(0xFF1B4D3E)],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.spa, color: AppColors.primaryFixed, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${liveIntention.quote} (${liveIntention.quoteReference})",
                              style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Insight Card: Why it matters
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.lightbulb, size: 16, color: AppColors.primaryContainer),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Why it matters",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 38),
                      child: Text(
                        liveIntention.whyItMatters,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.45,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Actionable Habits: Suggested Actions (Admin enabled toggle)
              if (appState.simpleActionsEnabled && liveIntention.suggestedActions.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.task_alt, size: 16, color: AppColors.primaryContainer),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Suggested actions",
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurface,
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${liveIntention.suggestedActions.length} steps",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // List of Suggested Actions with TIME SHOWN LIKE A PRICE TAG
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: liveIntention.suggestedActions.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final act = liveIntention.suggestedActions[index];
                          final isChecked = _checkedActionIds.contains(act.id);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isChecked) {
                                  _checkedActionIds.remove(act.id);
                                } else {
                                  _checkedActionIds.add(act.id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Checkbox
                                  Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      color: isChecked ? AppColors.primaryContainer : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: isChecked ? AppColors.primaryContainer : AppColors.outlineVariant,
                                      ),
                                    ),
                                    child: isChecked
                                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 10),

                                  // Action content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          act.title,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.onSurface,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          act.description,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: 12,
                                                color: AppColors.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // PRICE TAG STYLE DURATION PILL
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryContainer.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.schedule, size: 12, color: AppColors.onSecondaryContainer),
                                        const SizedBox(width: 3),
                                        Text(
                                          act.durationDisplay,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.onSecondaryContainer,
                                          ),
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
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Reminder Cadence Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondaryContainer,
                          ),
                          child: const Icon(Icons.event_repeat, size: 18, color: AppColors.primaryContainer),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reminder Cadence",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                            Text(
                              "Daily reflection at 9:00 AM",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _startReminderSetup(context, appState);
                      },
                      child: const Text("Edit", style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryContainer)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bottom Primary Action CTA
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
                  icon: const Icon(Icons.notifications_active, size: 20),
                  label: const Text(
                    "Set Reminder for this Intention",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    _startReminderSetup(context, appState);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _startReminderSetup(BuildContext context, AppState appState) {
    appState.clearSelectedIntentions();
    appState.toggleSelectIntention(widget.intention.id);

    // Also pre-check selected actions if any
    for (var actId in _checkedActionIds) {
      appState.toggleSelectSuggestedAction(actId);
    }

    final cat = appState.categories.firstWhere(
      (c) => c.id == widget.intention.categoryId,
      orElse: () => appState.categories.first,
    );

    SubcategoryModel? sub;
    if (widget.intention.subcategoryId != null) {
      try {
        sub = appState.subcategories.firstWhere((s) => s.id == widget.intention.subcategoryId);
      } catch (_) {}
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReminderTimingScreen(category: cat, subcategory: sub),
      ),
    );
  }
}
