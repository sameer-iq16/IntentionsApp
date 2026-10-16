import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'intention_list_screen.dart';
import 'subcategories_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final upcomingReminders = appState.reminders.where((r) => r.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header: Salutation & Tone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Assalamualaikum, Ayesha",
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurface,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.eco, color: AppColors.primaryContainer, size: 20),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Small intentions. A kinder, calmer, more meaningful you.",
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: AppColors.secondary),
                        onPressed: () => onTabChange(3),
                        tooltip: "Notifications",
                      ),
                      GestureDetector(
                        onTap: () {
                          // Quick toggle to show Admin Portal dialog or switch
                          _showProfileDialog(context);
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appState.isAdminMode ? AppColors.roseIcon : AppColors.primary,
                          ),
                          child: Center(
                            child: Icon(
                              appState.isAdminMode ? Icons.admin_panel_settings : Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hero Scenic Panorama Banner
              const ScenicBanner(
                tag: "Daily Niyyah",
                title: "Intentions today,\na better tomorrow.",
                subtitle: "Choose, save and set reminders for the intentions that matter to you.",
                height: 155,
              ),
              const SizedBox(height: 16),

              // Quick Navigation 3-Card Row
              Row(
                children: [
                  // 1. Explore Intentions
                  Expanded(
                    child: _buildQuickNavCard(
                      context: context,
                      title: "Explore\nIntentions",
                      icon: Icons.psychology_alt,
                      bgColor: AppColors.secondaryContainer.withValues(alpha: 0.6),
                      iconColor: AppColors.primary,
                      onTap: () => onTabChange(1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 2. Saved Intentions
                  Expanded(
                    child: _buildQuickNavCard(
                      context: context,
                      title: "Saved\nIntentions",
                      icon: Icons.bookmark,
                      bgColor: const Color(0xFFEEE8F7),
                      iconColor: const Color(0xFF553C7B),
                      onTap: () => onTabChange(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 3. Your Reminders
                  Expanded(
                    child: _buildQuickNavCard(
                      context: context,
                      title: "Your\nReminders",
                      icon: Icons.schedule,
                      bgColor: const Color(0xFFFFEDE0),
                      iconColor: const Color(0xFF93451A),
                      onTap: () => onTabChange(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Upcoming Reminder Section
              SectionHeader(
                title: "Upcoming reminder",
                onViewAll: () => onTabChange(3),
              ),
              const SizedBox(height: 6),
              if (upcomingReminders.isNotEmpty) ...[
                _buildUpcomingReminderCard(context, upcomingReminders.first),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_none, color: AppColors.outline),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "No active reminders yet. Pick intentions to schedule one!",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // A Little Inspiration Scenic Quote Card
              SectionHeader(
                title: "A little inspiration",
                onViewAll: () {
                  final characterCat = appState.categories.firstWhere(
                    (c) => c.id == 'cat_character',
                    orElse: () => appState.categories.first,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubcategoriesScreen(category: characterCat),
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              _buildInspirationCard(context),
              const SizedBox(height: 20),

              // Popular Categories Grid
              SectionHeader(
                title: "Popular categories",
                onViewAll: () => onTabChange(1),
              ),
              const SizedBox(height: 8),
              _buildPopularCategories(context, appState),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNavCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(minHeight: 112),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppColors.onSurface,
                        ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: iconColor.withValues(alpha: 0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingReminderCard(BuildContext context, dynamic reminder) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryContainer,
                  ),
                  child: const Center(
                    child: Icon(Icons.spa, color: AppColors.primary, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${reminder.intentionIds.length} intentions • ${reminder.suggestedActionIds.length} suggested action",
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.alarm, size: 14, color: AppColors.primaryContainer),
                const SizedBox(width: 4),
                Text(
                  "${reminder.timeOfDay.hour.toString().padLeft(2, '0')}:${reminder.timeOfDay.minute.toString().padLeft(2, '0')} ${reminder.timeOfDay.period == DayPeriod.am ? 'AM' : 'PM'}",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryContainer,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF7FCF9),
          ],
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryContainer,
                ),
                child: const Center(
                  child: Icon(Icons.local_florist, color: AppColors.primary, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "“Patience is not about enduring difficulties, but about seeking Allah’s pleasure in the process.”",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                        height: 1.4,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "— AN INTENTION ON SABR",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: AppColors.roseIcon, size: 18),
                onPressed: () {
                  CustomPillToast.show(context, "Saved to your inspirations");
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCategories(BuildContext context, AppState appState) {
    final categories = appState.categories.take(4).toList();

    return Row(
      children: categories.map((cat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () {
                // If category has no subcategories (e.g. Family), directly open IntentionListScreen!
                if (!cat.hasSubcategories) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => IntentionListScreen(
                        category: cat,
                        title: cat.name,
                        intentions: appState.getIntentionsForCategory(cat.id),
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                decoration: BoxDecoration(
                  color: cat.backgroundColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(cat.icon, color: cat.iconColor, size: 20),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.name.split(' ').first,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showProfileDialog(BuildContext context) {
    final appState = context.read<AppState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surfaceContainerLowest,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer,
              ),
              child: const Icon(Icons.person, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text("Ayesha's Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Personal Intentions Platform",
              style: TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Superadmin Portal", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      Text("Desktop / Mobile admin controls", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                  Switch(
                    value: appState.isAdminMode,
                    activeThumbColor: AppColors.primaryContainer,
                    onChanged: (val) {
                      appState.setAdminMode(val);
                      Navigator.pop(ctx);
                      CustomPillToast.show(
                        context,
                        val ? "Admin Portal Enabled" : "Switched to User Mode",
                        icon: Icons.admin_panel_settings,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
