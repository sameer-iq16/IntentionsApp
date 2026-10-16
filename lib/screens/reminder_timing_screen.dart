import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'reminder_actions_screen.dart';

class ReminderTimingScreen extends StatefulWidget {
  final CategoryModel category;
  final SubcategoryModel? subcategory;

  const ReminderTimingScreen({
    super.key,
    required this.category,
    this.subcategory,
  });

  @override
  State<ReminderTimingScreen> createState() => _ReminderTimingScreenState();
}

class _ReminderTimingScreenState extends State<ReminderTimingScreen> {
  ReminderCadence _cadence = ReminderCadence.daily;
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 9, minute: 0);
  bool _isDrawerExpanded = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedIntentionIds = appState.selectedIntentionIds;
    final selectedIntentions = appState.intentions
        .where((i) => selectedIntentionIds.contains(i.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Set Reminder Timing",
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
              // Progress Breadcrumb & Context
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.checklist_rtl, size: 16, color: AppColors.onSecondaryFixed),
                        const SizedBox(width: 4),
                        Text(
                          "${selectedIntentionIds.length} intentions selected",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSecondaryFixed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "STEP 1 OF 3",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Choose when you'd like to receive gentle mindful reflections for your intentions.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 14),

              // Intention Mini Preview Strip
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Overlapping circular icons
                            SizedBox(
                              width: (selectedIntentions.take(3).length * 20.0) + 16,
                              height: 32,
                              child: Stack(
                                children: [
                                  for (int i = 0; i < selectedIntentions.take(3).length; i++)
                                    Positioned(
                                      left: i * 18.0,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: i == 0
                                              ? AppColors.secondaryContainer
                                              : i == 1
                                                  ? AppColors.roseBg
                                                  : AppColors.lavenderBg,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            selectedIntentions[i].icon,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widgetTitleOrCategory,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _isDrawerExpanded = !_isDrawerExpanded);
                          },
                          child: Text(
                            _isDrawerExpanded ? "Hide list" : "View list",
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),

                    // Expandable List of active intentions
                    if (_isDrawerExpanded) ...[
                      const Divider(height: 16),
                      Column(
                        children: selectedIntentions.map((intent) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    intent.title,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.onSurface,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Notification Cadence Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notification Cadence",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                  ),
                  Text(
                    "Customizable later",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Option 1: Daily (Recommended)
              _buildCadenceOption(
                title: "Daily",
                badge: "Recommended",
                subtitle: "Every day at scheduled time",
                icon: Icons.calendar_today,
                cadence: ReminderCadence.daily,
                hasTimePicker: true,
              ),
              const SizedBox(height: 10),

              // Option 2: Weekly
              _buildCadenceOption(
                title: "Weekly",
                subtitle: "Every Monday at 9:00 AM",
                icon: Icons.date_range,
                cadence: ReminderCadence.weekly,
              ),
              const SizedBox(height: 10),

              // Option 3: Custom
              _buildCadenceOption(
                title: "Custom",
                subtitle: "Choose your own frequency & days",
                icon: Icons.edit_calendar,
                cadence: ReminderCadence.custom,
              ),
              const SizedBox(height: 10),

              // Option 4: No reminder
              _buildCadenceOption(
                title: "No reminder",
                subtitle: "Save quietly to intentions without alerts",
                icon: Icons.notifications_off_outlined,
                cadence: ReminderCadence.none,
              ),
              const SizedBox(height: 18),

              // Micro-habit Tip Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.psychology_alt, size: 18, color: AppColors.primaryContainer),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: const [
                            TextSpan(
                              text: "Micro-habit tip: ",
                              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            TextSpan(
                              text: "Reminders at the start of work or after Fajr sustain gentle consistency without cognitive fatigue.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Actions: Next Step Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text(
                    "Next: Suggested Actions",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    // Save draft timing into state
                    appState.setDraftTiming(
                      cadence: _cadence,
                      timeOfDay: _timeOfDay,
                    );

                    // Navigate to Step 2: Suggested Actions Cross-Sell Screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReminderActionsScreen(
                          category: widget.category,
                          subcategory: widget.subcategory,
                        ),
                      ),
                    );
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

  String get widgetTitleOrCategory => widget.subcategory?.name ?? widget.category.name;

  Widget _buildCadenceOption({
    required String title,
    String? badge,
    required String subtitle,
    required IconData icon,
    required ReminderCadence cadence,
    bool hasTimePicker = false,
  }) {
    final isSelected = _cadence == cadence;

    return InkWell(
      onTap: () {
        setState(() => _cadence = cadence);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryContainer.withValues(alpha: 0.25) : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(icon, color: isSelected ? Colors.white : AppColors.primary, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onPrimaryFixedVariant,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
                  size: 22,
                ),
              ],
            ),

            // Nested Time Picker if selected and Daily
            if (isSelected && hasTimePicker) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text("Preferred time: ", style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                        Text(
                          "${_timeOfDay.hour.toString().padLeft(2, '0')}:${_timeOfDay.minute.toString().padLeft(2, '0')} ${_timeOfDay.period == DayPeriod.am ? 'AM' : 'PM'}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      icon: const Icon(Icons.edit, size: 14, color: AppColors.primary),
                      label: const Text("Change", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _timeOfDay,
                        );
                        if (picked != null) {
                          setState(() => _timeOfDay = picked);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
