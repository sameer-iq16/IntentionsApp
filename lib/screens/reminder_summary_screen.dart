import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ReminderSummaryScreen extends StatelessWidget {
  final ReminderScheduleModel schedule;

  const ReminderSummaryScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    // Resolve included intentions
    final includedIntentions = appState.intentions
        .where((i) => schedule.intentionIds.contains(i.id))
        .toList();

    // Resolve included actions
    final List<SuggestedActionModel> includedActions = [];
    for (var intent in appState.intentions) {
      for (var act in intent.suggestedActions) {
        if (schedule.suggestedActionIds.contains(act.id)) {
          includedActions.add(act);
        }
      }
    }

    final timeStr =
        "${schedule.timeOfDay.hour.toString().padLeft(2, '0')}:${schedule.timeOfDay.minute.toString().padLeft(2, '0')} ${schedule.timeOfDay.period == DayPeriod.am ? 'AM' : 'PM'}";

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Success badge
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryContainer,
                ),
                child: const Center(
                  child: Icon(Icons.check_circle, size: 48, color: AppColors.primaryContainer),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Reminders Scheduled!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "Your mindful intentions and attached micro-habits have been set into your cadence.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Summary Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          schedule.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            schedule.cadence.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimaryFixedVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.alarm, size: 18, color: AppColors.primaryContainer),
                        const SizedBox(width: 8),
                        Text(
                          "Alert Time: $timeStr",
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Included Intentions
                    Text(
                      "Included Intentions (${includedIntentions.length})",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...includedIntentions.map((intent) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check, size: 16, color: AppColors.primaryContainer),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  intent.title,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurface),
                                ),
                              ),
                            ],
                          ),
                        )),

                    if (includedActions.isNotEmpty) ...[
                      const Divider(height: 24),
                      Text(
                        "Attached Suggested Habits (${includedActions.length})",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ...includedActions.map((act) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.task_alt, size: 16, color: AppColors.secondary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          act.title,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurface),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    act.durationDisplay,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSecondaryContainer),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Done Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    CustomPillToast.show(context, "Reminder activated!");
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("Return Home", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
