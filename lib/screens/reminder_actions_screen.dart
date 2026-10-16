import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'reminder_summary_screen.dart';

class ReminderActionsScreen extends StatefulWidget {
  final CategoryModel category;
  final SubcategoryModel? subcategory;

  const ReminderActionsScreen({
    super.key,
    required this.category,
    this.subcategory,
  });

  @override
  State<ReminderActionsScreen> createState() => _ReminderActionsScreenState();
}

class _ReminderActionsScreenState extends State<ReminderActionsScreen> {
  bool _masterToggle = true;
  bool _isSummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      // Gather all suggested actions for selected intentions
      final selectedIntents = appState.intentions
          .where((i) => appState.selectedIntentionIds.contains(i.id))
          .toList();

      for (var intent in selectedIntents) {
        for (var act in intent.suggestedActions) {
          if (act.isDefaultChecked) {
            appState.toggleSelectSuggestedAction(act.id);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedIntents = appState.intentions
        .where((i) => appState.selectedIntentionIds.contains(i.id))
        .toList();

    // Collect all suggested actions from the selected intentions
    final List<SuggestedActionModel> availableActions = [];
    for (var intent in selectedIntents) {
      availableActions.addAll(intent.suggestedActions);
    }

    final selectedActionCount = appState.selectedActionIds.length;

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Suggested Actions",
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
              // Progress Indicator: Step 2 of 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 24, height: 5, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 4),
                      Container(width: 24, height: 5, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 4),
                      Container(width: 10, height: 5, decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(10))),
                    ],
                  ),
                  Text(
                    "STEP 2 OF 3",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                "Boost your intention with bite-sized daily micro-habits.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 14),

              // Intention Count Badge Strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${selectedIntents.length} intentions selected",
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.onSurface),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => setState(() => _isSummaryExpanded = !_isSummaryExpanded),
                      child: Row(
                        children: [
                          const Text("View", style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryContainer, fontSize: 12)),
                          Icon(
                            _isSummaryExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 18,
                            color: AppColors.primaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable Selected Intentions Tray
              if (_isSummaryExpanded) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: selectedIntents.map((intent) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(intent.icon, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              intent.title.length > 25 ? '${intent.title.substring(0, 25)}...' : intent.title,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // E-COMMERCE CROSS-SELL HERO CARD ("Frequently Added Together")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFEBF8F1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 13, color: AppColors.onSecondaryContainer),
                              SizedBox(width: 4),
                              Text(
                                "RECOMMENDED ADD-ON",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSecondaryContainer,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Why not attach daily concrete habits?",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                            height: 1.25,
                          ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
                        children: const [
                          TextSpan(text: "Muslims who anchor their intentions to small concrete acts of remembrance are "),
                          TextSpan(
                            text: "3× more likely",
                            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryContainer),
                          ),
                          TextSpan(text: " to sustain presence of heart throughout the day."),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Master Switch Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.task_alt, size: 18, color: AppColors.primaryContainer),
                              SizedBox(width: 8),
                              Text(
                                "Include suggested habits",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ],
                          ),
                          Switch(
                            value: _masterToggle,
                            activeThumbColor: AppColors.primaryContainer,
                            onChanged: (val) {
                              setState(() => _masterToggle = val);
                              final allActionIds = availableActions.map((a) => a.id).toList();
                              appState.setAllSuggestedActions(allActionIds, val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Available Micro-Habits List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "AVAILABLE MICRO-HABITS",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                  ),
                  Text(
                    "$selectedActionCount of ${availableActions.length} selected",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Habits List with Price Tag style completion times
              if (availableActions.isNotEmpty) ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: availableActions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final act = availableActions[index];
                    final isChecked = appState.selectedActionIds.contains(act.id);

                    return InkWell(
                      onTap: () {
                        appState.toggleSelectSuggestedAction(act.id);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isChecked ? AppColors.surfaceContainerLowest : AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isChecked ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                            width: isChecked ? 1.5 : 1,
                          ),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: isChecked ? AppColors.primaryContainer : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isChecked ? AppColors.primaryContainer : AppColors.outlineVariant,
                                ),
                              ),
                              child: isChecked
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          act.title,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.onSurface,
                                                height: 1.25,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // TIME SHOWN LIKE A PRICE TAG (Product Price Aesthetic)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryContainer,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.schedule, size: 12, color: AppColors.onSecondaryContainer),
                                            const SizedBox(width: 3),
                                            Text(
                                              act.durationDisplay,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.onSecondaryContainer,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    act.description,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.secondary,
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
              const SizedBox(height: 16),

              // Micro-Reflection Quote
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.format_quote, size: 16, color: AppColors.primaryContainer),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "“The most beloved of deeds to Allah are those that are most consistent, even if they are small.”",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppColors.onSurface,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Navigation Dock
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: const BorderSide(color: AppColors.outlineVariant),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 18, color: AppColors.onSurface),
                        label: const Text("Back", style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text("Confirm Reminder", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        onPressed: () {
                          // Commit reminder in state
                          final schedule = appState.commitReminderSchedule(
                            customTitle: widget.subcategory?.name ?? widget.category.name,
                          );

                          // Open confirmation summary screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => ReminderSummaryScreen(schedule: schedule),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
