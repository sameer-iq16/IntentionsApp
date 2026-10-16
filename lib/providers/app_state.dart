import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/sample_data.dart';

class AppState extends ChangeNotifier {
  // Superadmin Feature Flags
  bool _simpleActionsEnabled = true;
  bool _contentFeatureEnabled = true;
  bool _isAdminMode = false;

  // Repositories
  List<CategoryModel> _categories = [];
  List<SubcategoryModel> _subcategories = [];
  List<IntentionModel> _intentions = [];
  List<ReminderScheduleModel> _reminders = [];
  final Set<String> _savedContentIds = {};

  // Current Multi-select State for Reminder Creation Flow
  final Set<String> _selectedIntentionIds = {};
  ReminderCadence _draftCadence = ReminderCadence.daily;
  TimeOfDay _draftTime = const TimeOfDay(hour: 9, minute: 0);
  final Set<int> _draftDays = {1, 2, 3, 4, 5, 6, 7};
  final Set<String> _selectedActionIds = {};

  AppState() {
    _initData();
  }

  void _initData() {
    _categories = SampleData.getCategories();
    _subcategories = SampleData.getSubcategories();
    _intentions = SampleData.getIntentions();
    _reminders = SampleData.getReminders();

    // Mark initial favorites for demo
    if (_intentions.isNotEmpty) {
      _intentions[0] = _intentions[0].copyWith(isFavorite: true);
    }
  }

  // Getters
  bool get simpleActionsEnabled => _simpleActionsEnabled;
  bool get contentFeatureEnabled => _contentFeatureEnabled;
  bool get isAdminMode => _isAdminMode;

  List<CategoryModel> get categories => List.unmodifiable(_categories);
  List<SubcategoryModel> get subcategories => List.unmodifiable(_subcategories);
  List<IntentionModel> get intentions => List.unmodifiable(_intentions);
  List<ReminderScheduleModel> get reminders => List.unmodifiable(_reminders);

  Set<String> get selectedIntentionIds => _selectedIntentionIds;
  ReminderCadence get draftCadence => _draftCadence;
  TimeOfDay get draftTime => _draftTime;
  Set<int> get draftDays => _draftDays;
  Set<String> get selectedActionIds => _selectedActionIds;

  // Superadmin Toggle Controls
  void setSimpleActionsEnabled(bool value) {
    _simpleActionsEnabled = value;
    notifyListeners();
  }

  void setContentFeatureEnabled(bool value) {
    _contentFeatureEnabled = value;
    notifyListeners();
  }

  void toggleAdminMode() {
    _isAdminMode = !_isAdminMode;
    notifyListeners();
  }

  void setAdminMode(bool value) {
    _isAdminMode = value;
    notifyListeners();
  }

  // Category & Subcategory helpers
  List<SubcategoryModel> getSubcategoriesForCategory(String categoryId) {
    return _subcategories.where((sub) => sub.categoryId == categoryId).toList();
  }

  List<IntentionModel> getIntentionsForCategory(String categoryId) {
    return _intentions.where((intent) => intent.categoryId == categoryId).toList();
  }

  List<IntentionModel> getIntentionsForSubcategory(String subcategoryId) {
    return _intentions.where((intent) => intent.subcategoryId == subcategoryId).toList();
  }

  IntentionModel? getIntentionById(String id) {
    try {
      return _intentions.firstWhere((intent) => intent.id == id);
    } catch (_) {
      return null;
    }
  }

  List<IntentionModel> getFavoriteIntentions() {
    return _intentions.where((intent) => intent.isFavorite).toList();
  }

  List<SupportingContentModel> getAllContent() {
    final list = <SupportingContentModel>[];
    for (var intent in _intentions) {
      list.addAll(intent.supportingContent);
    }
    return list;
  }

  List<SupportingContentModel> getSavedContent() {
    final all = getAllContent();
    return all.where((c) => _savedContentIds.contains(c.id)).toList();
  }

  bool isContentSaved(String contentId) => _savedContentIds.contains(contentId);

  // User Actions: Favorite & Save
  void toggleFavoriteIntention(String intentionId) {
    final idx = _intentions.indexWhere((i) => i.id == intentionId);
    if (idx != -1) {
      final current = _intentions[idx];
      _intentions[idx] = current.copyWith(isFavorite: !current.isFavorite);
      notifyListeners();
    }
  }

  void toggleSaveContent(String contentId) {
    if (_savedContentIds.contains(contentId)) {
      _savedContentIds.remove(contentId);
    } else {
      _savedContentIds.add(contentId);
    }
    notifyListeners();
  }

  // User Custom Intention creation (Only personal intentions permitted)
  void addCustomIntention({
    required String title,
    required String categoryId,
    String? subcategoryId,
    bool enableDailyReminder = true,
  }) {
    final category = _categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => _categories.first,
    );

    final newId = 'custom_intent_${DateTime.now().millisecondsSinceEpoch}';
    final customIntention = IntentionModel(
      id: newId,
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      title: title,
      topicTag: "${category.name} • Personal",
      description: "My personal custom intention: $title",
      whyItMatters: "Cultivating mindful personal accountability and inner intention.",
      quote: "“Actions are according to intentions.”",
      quoteReference: "Sahih al-Bukhari 1",
      icon: Icons.psychology_alt,
      iconName: 'psychology_alt',
      isCustom: true,
      isFavorite: true,
      suggestedActions: [
        SuggestedActionModel(
          id: 'custom_act_$newId',
          intentionId: newId,
          title: "Mindfully recite intention at dawn",
          description: "Re-center heart and purpose before daily tasks.",
          durationMinutes: 2,
          durationDisplay: "2 min",
          isDefaultChecked: true,
        ),
      ],
    );

    _intentions.insert(0, customIntention);

    if (enableDailyReminder) {
      final reminder = ReminderScheduleModel(
        id: 'rem_${DateTime.now().millisecondsSinceEpoch}',
        title: title.length > 25 ? '${title.substring(0, 25)}...' : title,
        cadence: ReminderCadence.daily,
        timeOfDay: const TimeOfDay(hour: 9, minute: 0),
        intentionIds: [newId],
        suggestedActionIds: ['custom_act_$newId'],
        isActive: true,
        createdAt: DateTime.now(),
      );
      _reminders.insert(0, reminder);
    }

    notifyListeners();
  }

  // Multi-Select Reminder Flow States
  void toggleSelectIntention(String intentionId) {
    if (_selectedIntentionIds.contains(intentionId)) {
      _selectedIntentionIds.remove(intentionId);
    } else {
      _selectedIntentionIds.add(intentionId);
    }
    notifyListeners();
  }

  void selectAllIntentions(List<String> ids) {
    final allSelected = ids.every((id) => _selectedIntentionIds.contains(id));
    if (allSelected) {
      for (var id in ids) {
        _selectedIntentionIds.remove(id);
      }
    } else {
      _selectedIntentionIds.addAll(ids);
    }
    notifyListeners();
  }

  void clearSelectedIntentions() {
    _selectedIntentionIds.clear();
    _selectedActionIds.clear();
    notifyListeners();
  }

  void setDraftTiming({
    required ReminderCadence cadence,
    required TimeOfDay timeOfDay,
    Set<int>? days,
  }) {
    _draftCadence = cadence;
    _draftTime = timeOfDay;
    if (days != null) {
      _draftDays.clear();
      _draftDays.addAll(days);
    }
    notifyListeners();
  }

  void toggleSelectSuggestedAction(String actionId) {
    if (_selectedActionIds.contains(actionId)) {
      _selectedActionIds.remove(actionId);
    } else {
      _selectedActionIds.add(actionId);
    }
    notifyListeners();
  }

  void setAllSuggestedActions(List<String> actionIds, bool selectAll) {
    if (selectAll) {
      _selectedActionIds.addAll(actionIds);
    } else {
      for (var id in actionIds) {
        _selectedActionIds.remove(id);
      }
    }
    notifyListeners();
  }

  ReminderScheduleModel commitReminderSchedule({String? customTitle}) {
    final selectedList = _intentions.where((i) => _selectedIntentionIds.contains(i.id)).toList();
    final title = customTitle ?? (selectedList.isNotEmpty ? selectedList.first.topicTag.split('•').first.trim() : 'Mindful Intentions');

    final reminder = ReminderScheduleModel(
      id: 'rem_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      cadence: _draftCadence,
      timeOfDay: _draftTime,
      daysOfWeek: _draftDays.toList(),
      intentionIds: _selectedIntentionIds.toList(),
      suggestedActionIds: _selectedActionIds.toList(),
      isActive: true,
      createdAt: DateTime.now(),
    );

    _reminders.insert(0, reminder);
    clearSelectedIntentions();
    notifyListeners();
    return reminder;
  }

  void toggleReminderActive(String reminderId) {
    final idx = _reminders.indexWhere((r) => r.id == reminderId);
    if (idx != -1) {
      final cur = _reminders[idx];
      _reminders[idx] = cur.copyWith(isActive: !cur.isActive);
      notifyListeners();
    }
  }

  void deleteReminder(String reminderId) {
    _reminders.removeWhere((r) => r.id == reminderId);
    notifyListeners();
  }

  // ==========================================
  // SUPERADMIN CRUD OPERATIONS (Computer / Desktop)
  // ==========================================

  void addCategory(CategoryModel category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(CategoryModel category) {
    final idx = _categories.indexWhere((c) => c.id == category.id);
    if (idx != -1) {
      _categories[idx] = category;
      notifyListeners();
    }
  }

  void deleteCategory(String categoryId) {
    _categories.removeWhere((c) => c.id == categoryId);
    _subcategories.removeWhere((s) => s.categoryId == categoryId);
    _intentions.removeWhere((i) => i.categoryId == categoryId);
    notifyListeners();
  }

  void addSubcategory(SubcategoryModel sub) {
    _subcategories.add(sub);
    notifyListeners();
  }

  void updateSubcategory(SubcategoryModel sub) {
    final idx = _subcategories.indexWhere((s) => s.id == sub.id);
    if (idx != -1) {
      _subcategories[idx] = sub;
      notifyListeners();
    }
  }

  void deleteSubcategory(String subId) {
    _subcategories.removeWhere((s) => s.id == subId);
    _intentions.removeWhere((i) => i.subcategoryId == subId);
    notifyListeners();
  }

  void addAdminIntention(IntentionModel intention) {
    _intentions.add(intention);
    notifyListeners();
  }

  void updateIntention(IntentionModel intention) {
    final idx = _intentions.indexWhere((i) => i.id == intention.id);
    if (idx != -1) {
      _intentions[idx] = intention;
      notifyListeners();
    }
  }

  void deleteIntention(String intentionId) {
    _intentions.removeWhere((i) => i.id == intentionId);
    notifyListeners();
  }

  void addSuggestedAction(String intentionId, SuggestedActionModel action) {
    final idx = _intentions.indexWhere((i) => i.id == intentionId);
    if (idx != -1) {
      final current = _intentions[idx];
      final updatedList = List<SuggestedActionModel>.from(current.suggestedActions)..add(action);
      _intentions[idx] = current.copyWith(suggestedActions: updatedList);
      notifyListeners();
    }
  }

  void deleteSuggestedAction(String intentionId, String actionId) {
    final idx = _intentions.indexWhere((i) => i.id == intentionId);
    if (idx != -1) {
      final current = _intentions[idx];
      final updatedList = current.suggestedActions.where((a) => a.id != actionId).toList();
      _intentions[idx] = current.copyWith(suggestedActions: updatedList);
      notifyListeners();
    }
  }

  void addSupportingContent(String intentionId, SupportingContentModel content) {
    final idx = _intentions.indexWhere((i) => i.id == intentionId);
    if (idx != -1) {
      final current = _intentions[idx];
      final updatedList = List<SupportingContentModel>.from(current.supportingContent)..add(content);
      _intentions[idx] = current.copyWith(supportingContent: updatedList);
      notifyListeners();
    }
  }

  void deleteSupportingContent(String intentionId, String contentId) {
    final idx = _intentions.indexWhere((i) => i.id == intentionId);
    if (idx != -1) {
      final current = _intentions[idx];
      final updatedList = current.supportingContent.where((c) => c.id != contentId).toList();
      _intentions[idx] = current.copyWith(supportingContent: updatedList);
      notifyListeners();
    }
  }
}
