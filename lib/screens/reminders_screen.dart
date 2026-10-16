import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class RemindersScreen extends StatelessWidget {
  final Function(int) onTabChange;

  const RemindersScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final reminders = appState.reminders;

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Your Reminders",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text("New", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    onPressed: () => onTabChange(1), // Jump to explore to pick intentions
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Maintain consistent presence of heart with gentle daily prompts.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              // Active Schedule Cards
              if (reminders.isNotEmpty) ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reminders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = reminders[index];
                    return _buildReminderScheduleCard(context, item, appState);
                  },
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
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
                        child: const Icon(Icons.notifications_none, size: 28, color: AppColors.secondary),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "No reminders set yet",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Explore categories, select multiple intentions, and set gentle scheduled alerts.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryContainer,
                          foregroundColor: AppColors.onSecondaryFixed,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () => onTabChange(1),
                        child: const Text("Explore Intentions", style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
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

  Widget _buildReminderScheduleCard(BuildContext context, ReminderScheduleModel item, AppState appState) {
    final timeStr =
        "${item.timeOfDay.hour.toString().padLeft(2, '0')}:${item.timeOfDay.minute.toString().padLeft(2, '0')} ${item.timeOfDay.period == DayPeriod.am ? 'AM' : 'PM'}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isActive ? AppColors.surfaceContainerHigh : AppColors.surfaceContainer,
        ),
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.isActive ? AppColors.secondaryContainer : AppColors.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.isActive ? Icons.notifications_active : Icons.notifications_paused,
                      color: item.isActive ? AppColors.primaryContainer : AppColors.outline,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                      ),
                      Text(
                        "${item.cadence.name.toUpperCase()} • $timeStr",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: item.isActive ? AppColors.primaryContainer : AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: item.isActive,
                activeThumbColor: AppColors.primaryContainer,
                onChanged: (_) {
                  appState.toggleReminderActive(item.id);
                  CustomPillToast.show(
                    context,
                    item.isActive ? "Reminder paused" : "Reminder resumed",
                    icon: item.isActive ? Icons.pause : Icons.play_arrow,
                  );
                },
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item.intentionIds.length} intentions • ${item.suggestedActionIds.length} micro-habits",
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.outline),
                onPressed: () {
                  appState.deleteReminder(item.id);
                  CustomPillToast.show(context, "Reminder removed", icon: Icons.delete);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
